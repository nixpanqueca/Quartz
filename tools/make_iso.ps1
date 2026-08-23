param(
    [string]$RootDir = (Split-Path -Parent $PSScriptRoot)
)

# Builds a minimal ISO 9660 image with an El Torito no-emulation boot
# image, plus KERNEL.BIN, ABOUT.TXT and the assets tree (assets\ -> ISO
# root), without relying on external ISO tools.
#
# Logical block size = 2048 bytes. Layout:
#   LBA 0..15    system area (zeros)
#   LBA 16       Primary Volume Descriptor
#   LBA 17       El Torito Boot Record volume descriptor
#   LBA 18       Volume Descriptor Set Terminator
#   LBA 19       El Torito Boot Catalog (validation + initial entry)
#   LBA 20..23   boot image (boot.bin padded to 4 x 2048)
#   LBA 24       Path Table L
#   LBA 25       Path Table M
#   LBA 26       root directory
#   LBA 27..     KERNEL.BIN data, ABOUT.TXT data, asset directories
#                and asset files (directories first, DFS, then files DFS)
#
# The bootloader/kernel read the PVD + directory records directly and
# never touch the path tables; the path tables are built correctly so
# external ISO readers (e.g. Windows) can browse the image.
#
# Directory record layout used here is plain ISO 9660:
#   +0  LEN_DR (incl. padding), +1 XAR, +2..5 extent (LE), +6..9 (BE),
#   +10..13 data length (LE), +14..17 (BE), +18..24 date, +25 flags,
#   +26 unit size, +27 gap, +28..29 vol seq (LE), +30..31 (BE),
#   +32 LEN_FI, +33.. name ("FILE.BMP;1" for files, "DIR" for dirs,
#   byte 0 / byte 1 for "." / "..").

$ErrorActionPreference = 'Stop'

$BootBin = Join-Path $RootDir 'build\boot.bin'
$Kernel  = Join-Path $RootDir 'build\quartz.flat'
$AboutTxt = Join-Path $RootDir 'about.txt'
$AssetsDir = Join-Path $RootDir 'assets'
$OutIso  = Join-Path $RootDir 'build\AetherSystemSoftware.iso'

if (-not (Test-Path $BootBin)) { throw "boot.bin nao encontrado: $BootBin" }
if (-not (Test-Path $Kernel))  { throw "quartz.flat nao encontrado: $Kernel" }

$boot   = [IO.File]::ReadAllBytes($BootBin)
$kernel = [IO.File]::ReadAllBytes($Kernel)
if ($boot.Length -gt 2048)  { throw "boot.bin maior que 2048 bytes ($($boot.Length))" }
if ($kernel.Length -eq 0)   { throw 'quartz.flat vazio' }

if (Test-Path $AboutTxt) {
    $aboutBytes = [IO.File]::ReadAllBytes($AboutTxt)
} else {
    $aboutBytes = [Text.Encoding]::ASCII.GetBytes('AETHER SYSTEM SOFTWARE')
}
if ($aboutBytes.Length -eq 0) { $aboutBytes = [byte[]](0x0A) }

function New-Sector { New-Object 'System.Byte[]' 2048 }

function Write-LE16($b, $o, $v) {
    $b[$o]   = $v -band 0xFF
    $b[$o+1] = ($v -shr 8) -band 0xFF
}
function Write-BE16($b, $o, $v) {
    $b[$o+1] = $v -band 0xFF
    $b[$o]   = ($v -shr 8) -band 0xFF
}
function Write-LE32($b, $o, $v) {
    $b[$o]   = $v -band 0xFF
    $b[$o+1] = ($v -shr 8)  -band 0xFF
    $b[$o+2] = ($v -shr 16) -band 0xFF
    $b[$o+3] = ($v -shr 24) -band 0xFF
}
function Write-BE32($b, $o, $v) {
    $b[$o+3] = $v -band 0xFF
    $b[$o+2] = ($v -shr 8)  -band 0xFF
    $b[$o+1] = ($v -shr 16) -band 0xFF
    $b[$o]   = ($v -shr 24) -band 0xFF
}
function Copy-Ascii($dst, $dOff, $text) {
    $bytes = [Text.Encoding]::ASCII.GetBytes($text)
    [Array]::Copy($bytes, 0, $dst, $dOff, $bytes.Length)
}

# --- asset tree -------------------------------------------------------
# Each directory object: { LBA; Size; Entries = ArrayList }
# Each entry: { Name; IsDir; Bytes; Sub; LBA; Size; Sectors }
function Collect-Dir($abs) {
    $o = @{ LBA = 0; Size = 0; Entries = New-Object System.Collections.ArrayList }
    foreach ($f in Get-ChildItem -LiteralPath $abs -File | Sort-Object Name) {
        $bytes = [IO.File]::ReadAllBytes($f.FullName)
        if ($bytes.Length -eq 0) { continue }
        $o.Entries.Add(@{
            Name = $f.Name; IsDir = $false; Bytes = $bytes; Sub = $null
            LBA = 0; Size = $bytes.Length; Sectors = [int][Math]::Ceiling($bytes.Length / 2048)
        }) | Out-Null
    }
    foreach ($d in Get-ChildItem -LiteralPath $abs -Directory | Sort-Object Name) {
        $sub = Collect-Dir $d.FullName
        $o.Entries.Add(@{
            Name = $d.Name; IsDir = $true; Bytes = $null; Sub = $sub
            LBA = 0; Size = 0; Sectors = 0
        }) | Out-Null
    }
    return $o
}

$root = @{ LBA = 26; Size = 0; Entries = New-Object System.Collections.ArrayList }

# kernel + about primeiro na raiz
$root.Entries.Add(@{ Name = 'KERNEL.BIN'; IsDir = $false; Bytes = $kernel; Sub = $null;
    LBA = 27; Size = $kernel.Length; Sectors = [int][Math]::Ceiling($kernel.Length / 2048) }) | Out-Null
$aboutLBA = 27 + [int][Math]::Ceiling($kernel.Length / 2048)
$root.Entries.Add(@{ Name = 'ABOUT.TXT'; IsDir = $false; Bytes = $aboutBytes; Sub = $null;
    LBA = $aboutLBA; Size = $aboutBytes.Length; Sectors = [int][Math]::Ceiling($aboutBytes.Length / 2048) }) | Out-Null

if (Test-Path $AssetsDir) {
    foreach ($e in (Collect-Dir $AssetsDir).Entries) {
        $root.Entries.Add($e) | Out-Null
    }
}

# --- directory sizes ----------------------------------------------------
# LEN_DR de um registro: 33 + LEN_FI, arredondado para par.
function Dir-RecLen([int]$nameLen) {
    $l = 33 + $nameLen
    if (($l % 2) -ne 0) { $l += 1 }
    return $l
}

# Computa (e grava em $d.Size) o tamanho do diretorio em bytes (multiplo de 2048).
function Compute-DirSizes($d) {
    $total = (Dir-RecLen 1) * 2                     # "." e ".."
    foreach ($e in $d.Entries) {
        if ($e.IsDir) {
            $e.Sub.Size = Compute-DirSizes $e.Sub
            $e.Sub.Sectors = [int][Math]::Ceiling($e.Sub.Size / 2048)
            $total += Dir-RecLen $e.Name.Length
        } else {
            $total += Dir-RecLen ($e.Name.Length + 2)   # ";1"
        }
    }
    return [int][Math]::Ceiling($total / 2048) * 2048
}
$root.Size = Compute-DirSizes $root
$root.Sectors = [int][Math]::Ceiling($root.Size / 2048)

# --- LBA allocation ------------------------------------------------------
$next = $aboutLBA + [int][Math]::Ceiling($aboutBytes.Length / 2048)
function Alloc-Dirs($d) {
    foreach ($e in $d.Entries) {
        if ($e.IsDir) {
            $e.Sub.LBA = $script:next
            $script:next += $e.Sub.Sectors
            Alloc-Dirs $e.Sub
        }
    }
}
function Alloc-Files($d) {
    foreach ($e in $d.Entries) {
        if ($e.IsDir) { Alloc-Files $e.Sub }
        else { $e.LBA = $script:next; $script:next += $e.Sectors }
    }
}
Alloc-Dirs $root
Alloc-Files $root
$totalSectors = $next

# --- Primary Volume Descriptor ------------------------------------------
$pvd = New-Sector
$pvd[0] = 1
Copy-Ascii $pvd 1 'CD001'
$pvd[6] = 1
Copy-Ascii $pvd 8 'AETHERBOOT'
Copy-Ascii $pvd 40 'AETHER SYSTEM SOFTWARE'
Write-LE32 $pvd 80 $totalSectors; Write-BE32 $pvd 84 $totalSectors
Write-LE16 $pvd 88 1;  Write-BE16 $pvd 92 1     # volume set size
Write-LE16 $pvd 96 1;  Write-BE16 $pvd 100 1    # volume sequence
Write-LE32 $pvd 104 2048; Write-BE32 $pvd 108 2048   # logical block size

# path table size (preenchido depois que os path tables forem montados)

# root directory record at +136 (34 bytes)
$pvd[136] = 34
$pvd[137] = 0
Write-LE32 $pvd 138 $root.LBA; Write-BE32 $pvd 142 $root.LBA     # extent
Write-LE32 $pvd 146 $root.Size; Write-BE32 $pvd 150 $root.Size   # data length
for ($i = 0; $i -lt 7; $i++) { $pvd[154 + $i] = 0 }              # date/time
$pvd[161] = 2                                       # flags: directory
$pvd[162] = 0
$pvd[163] = 0
Write-LE16 $pvd 164 1; Write-BE16 $pvd 166 1        # volume sequence
$pvd[168] = 1                                       # name length
$pvd[169] = 0                                       # name = root
Copy-Ascii $pvd 170 'AETHER SYSTEM SOFTWARE'
$pvd[861] = 1                                       # file structure version

# --- El Torito Boot Record volume descriptor ---------------------------
$br = New-Sector
$br[0] = 0
Copy-Ascii $br 1 'CD001'
$br[6] = 1
Copy-Ascii $br 7 'EL TORITO SPECIFICATION'          # 32-byte field
Write-LE32 $br 71 19                                # boot catalog LBA

# --- Volume Descriptor Set Terminator ----------------------------------
$term = New-Sector
$term[0] = 255
Copy-Ascii $term 1 'CD001'
$term[6] = 1

# --- El Torito Boot Catalog --------------------------------------------
$cat = New-Sector
$cat[0] = 1                          # header ID
$cat[1] = 0                          # platform = 80x86
$cat[2] = 0; $cat[3] = 0
Copy-Ascii $cat 4 'AETHER SYSTEM SOFTWARE '          # 24-byte id string
$sum = 0
for ($i = 0; $i -lt 28; $i += 2) {
    $sum += ([int]$cat[$i]) + ([int]$cat[$i + 1] * 256)   # 16-bit LE word
}
$sum = $sum % 0x10000
$chk = (0x10000 - $sum) % 0x10000
$cat[28] = $chk -band 0xFF
$cat[29] = ($chk -shr 8) -band 0xFF
$cat[30] = 0x55
$cat[31] = 0xAA
# initial/default entry (32 bytes)
$cat[32] = 0x88                      # bootable
$cat[33] = 0                         # no emulation
Write-LE16 $cat 34 0x0060            # load segment
$cat[36] = 0                         # system type
$cat[37] = 0
Write-LE16 $cat 38 4                 # sector count (512-byte sectors)
Write-LE32 $cat 40 20                # load RBA (2048-byte LBA: SeaBIOS
                                     # interprets it directly in 2048-unit
                                     # sectors, not 512 like the spec)

# --- boot image ---------------------------------------------------------
$bootImg = New-Object 'System.Byte[]' 8192
[Array]::Copy($boot, 0, $bootImg, 0, $boot.Length)

# --- path tables ---------------------------------------------------------
# BFS: raiz = numero 1; subdiretorios numerados em ordem de varredura.
$ptEntries = New-Object System.Collections.ArrayList
$entryOf = @{ }   # dir object -> entry que aponta para ele no pai
$queue = New-Object System.Collections.Queue
$dnum = 1
$root.Number = 1
$root.Parent = 1
$queue.Enqueue($root)
while ($queue.Count -gt 0) {
    $d = $queue.Dequeue()
    foreach ($e in $d.Entries) {
        if ($e.IsDir) {
            $dnum += 1
            $e.Sub.Number = $dnum
            $e.Sub.Parent = $d.Number
            $entryOf[$e.Sub] = $e
            $queue.Enqueue($e.Sub)
            $ptEntries.Add($e.Sub) | Out-Null
        }
    }
}
# raiz vai primeiro (numero 1)
$ptAll = New-Object System.Collections.ArrayList
$ptAll.Add($root) | Out-Null
foreach ($e in $ptEntries) { $ptAll.Add($e) | Out-Null }

$ptSize = 0
foreach ($d in $ptAll) {
    $len = if ($d.Number -eq 1) { 1 } else { $entryOf[$d].Name.Length }
    $ptSize += 8 + $len
    if ((8 + $len) % 2 -ne 0) { $ptSize += 1 }
}

$pt  = New-Sector                     # type L
$ptm = New-Sector                     # type M
$po = 0
foreach ($d in $ptAll) {
    if ($d.Number -eq 1) {
        $name = [byte[]](0)
        $nameLen = 1
    } else {
        $name = [Text.Encoding]::ASCII.GetBytes($entryOf[$d].Name)
        $nameLen = $name.Length
    }
    $recLen = 8 + $nameLen
    $pad = if (($recLen % 2) -ne 0) { 1 } else { 0 }

    $pt[$po] = $nameLen
    $pt[$po + 1] = 0
    Write-LE32 $pt ($po + 2) $d.LBA
    Write-LE16 $pt ($po + 6) $d.Parent
    [Array]::Copy($name, 0, $pt, $po + 8, $nameLen)
    if ($pad -eq 1) { $pt[$po + 8 + $nameLen] = 0 }

    $ptm[$po] = $nameLen
    $ptm[$po + 1] = 0
    Write-BE32 $ptm ($po + 2) $d.LBA
    Write-BE16 $ptm ($po + 6) $d.Parent
    [Array]::Copy($name, 0, $ptm, $po + 8, $nameLen)
    if ($pad -eq 1) { $ptm[$po + 8 + $nameLen] = 0 }

    $po += $recLen + $pad
}
if ($ptSize -gt 2048) { throw "path table maior que um setor ($ptSize bytes)" }
Write-LE32 $pvd 112 $ptSize; Write-BE32 $pvd 116 $ptSize
Write-LE32 $pvd 120 24                                 # L path table LBA
Write-LE32 $pvd 124 0
Write-LE32 $pvd 128 25                                 # M path table LBA
Write-LE32 $pvd 132 0

# --- directory records ---------------------------------------------------
function Write-DirEntry($b, $o, $lba, $size, $flags, $nameBytes) {
    $len = 33 + $nameBytes.Length
    if (($len % 2) -ne 0) { $len += 1 }
    $b[$o]   = $len
    $b[$o+1] = 0
    Write-LE32 $b ($o+2)  $lba
    Write-BE32 $b ($o+6)  $lba
    Write-LE32 $b ($o+10) $size
    Write-BE32 $b ($o+14) $size
    for ($i = 0; $i -lt 7; $i++) { $b[$o+18+$i] = 0 }
    $b[$o+25] = $flags
    $b[$o+26] = 0
    $b[$o+27] = 0
    Write-LE16 $b ($o+28) 1
    Write-BE16 $b ($o+30) 1
    $b[$o+32] = $nameBytes.Length
    [Array]::Copy($nameBytes, 0, $b, $o+33, $nameBytes.Length)
    return ($o + $len)
}

function Ascii-Bytes($text) {
    return [Text.Encoding]::ASCII.GetBytes($text)
}

function Find-Entry($d, $name) {
    foreach ($e in $d.Entries) { if ($e.Name -eq $name) { return $e } }
    return $null
}

# Monta os bytes de um diretorio. $parent é o objeto do diretorio pai
# (ou $null para a raiz, cujo ".." aponta para ela mesma).
function New-DirBytes($d, $parent) {
    $b = New-Object 'System.Byte[]' $d.Size
    $o = Write-DirEntry $b 0  $d.LBA  $d.Size  2 ([byte[]](0))     # "."
    $plba = if ($parent) { $parent.LBA } else { $d.LBA }
    $psize = if ($parent) { $parent.Size } else { $d.Size }
    $o = Write-DirEntry $b $o $plba  $psize  2 ([byte[]](1))       # ".."
    foreach ($e in $d.Entries) {
        if ($e.IsDir) {
            $o = Write-DirEntry $b $o $e.Sub.LBA $e.Sub.Size 2 (Ascii-Bytes $e.Name)
        } else {
            $o = Write-DirEntry $b $o $e.LBA $e.Size 0 (Ascii-Bytes ($e.Name + ';1'))
        }
    }
    return $b
}

$rootDirBytes = New-DirBytes $root $null

$dirBlob = @{ }   # dir object -> bytes (so para subdiretorios)
function Collect-DirBytes($d) {
    foreach ($e in $d.Entries) {
        if ($e.IsDir) {
            $dirBlob[$e.Sub] = New-DirBytes $e.Sub $d
            Collect-DirBytes $e.Sub
        }
    }
}
Collect-DirBytes $root

# --- assemble ISO -------------------------------------------------------
# Lista de (lba, byte[]) escrita em ordem crescente de LBA.
$blocks = New-Object System.Collections.ArrayList

$zero = New-Object 'System.Byte[]' 2048
for ($i = 0; $i -lt 16; $i++) { $blocks.Add(@{ LBA = $i; Data = $zero }) | Out-Null }
$blocks.Add(@{ LBA = 16; Data = $pvd }) | Out-Null
$blocks.Add(@{ LBA = 17; Data = $br }) | Out-Null
$blocks.Add(@{ LBA = 18; Data = $term }) | Out-Null
$blocks.Add(@{ LBA = 19; Data = $cat }) | Out-Null
for ($i = 0; $i -lt 4; $i++) { $blocks.Add(@{ LBA = 20 + $i; Data = $bootImg }) | Out-Null }
$blocks.Add(@{ LBA = 24; Data = $pt }) | Out-Null
$blocks.Add(@{ LBA = 25; Data = $ptm }) | Out-Null
$blocks.Add(@{ LBA = 26; Data = $rootDirBytes }) | Out-Null

# kernel/about/assets files e subdiretorios: escritos abaixo em DFS
# (mesma ordem da alocacao de LBA).
function Add-DirBlocks($d) {
    foreach ($e in $d.Entries) {
        if ($e.IsDir) {
            $b = $dirBlob[$e.Sub]
            for ($i = 0; $i -lt $e.Sub.Sectors; $i++) {
                $sector = New-Object 'System.Byte[]' 2048
                $srcLen = [Math]::Min(2048, $b.Length - $i * 2048)
                if ($srcLen -gt 0) {
                    [Array]::Copy($b, $i * 2048, $sector, 0, $srcLen)
                }
                $blocks.Add(@{ LBA = $e.Sub.LBA + $i; Data = $sector }) | Out-Null
            }
            Add-DirBlocks $e.Sub
        }
    }
}
Add-DirBlocks $root

# arquivos de assets (DFS)
function Add-FileBlocks($d) {
    foreach ($e in $d.Entries) {
        if ($e.IsDir) { Add-FileBlocks $e.Sub }
        else {
            $b = $e.Bytes
            for ($i = 0; $i -lt $e.Sectors; $i++) {
                $sector = New-Object 'System.Byte[]' 2048
                $srcLen = [Math]::Min(2048, $b.Length - $i * 2048)
                if ($srcLen -gt 0) {
                    [Array]::Copy($b, $i * 2048, $sector, 0, $srcLen)
                }
                $blocks.Add(@{ LBA = $e.LBA + $i; Data = $sector }) | Out-Null
            }
        }
    }
}
Add-FileBlocks $root

$sorted = @($blocks | Sort-Object { $_.LBA })
$TmpIso = $OutIso + '.tmp'
if (Test-Path $TmpIso) { Remove-Item $TmpIso -Force }
$fs = [IO.File]::Create($TmpIso)
try {
    $cur = 0
    foreach ($blk in $sorted) {
        if ($blk.LBA -ne $cur) {
            $null = $fs.Seek($blk.LBA * 2048, [IO.SeekOrigin]::Begin)
            $cur = $blk.LBA
        }
        $fs.Write($blk.Data, 0, 2048)
        $cur += 1
    }
    $fs.SetLength($cur * 2048)
} finally {
    $fs.Dispose()
}

$isoLen = (Get-Item $TmpIso).Length
$assetCount = 0
$dirCount = 0
function Count-Assets($d) {
    foreach ($e in $d.Entries) {
        if ($e.IsDir) { $script:dirCount += 1; Count-Assets $e.Sub }
        else { $script:assetCount += 1 }
    }
}
Count-Assets $root

# --- isohybrid MBR for USB boot support ---
$MbrBin = Join-Path $RootDir 'build\mbr.bin'
if (Test-Path $MbrBin) {
    $mbr = [IO.File]::ReadAllBytes($MbrBin)
    $fs2 = [IO.File]::Open($TmpIso, [IO.FileMode]::Open, [IO.FileAccess]::Write)
    $null = $fs2.Seek(0, [IO.SeekOrigin]::Begin)
    $fs2.Write($mbr, 0, [Math]::Min($mbr.Length, 512))
    $fs2.Dispose()
    Write-Output "make_iso: isohybrid MBR inserted at offset 0"
}

if (Test-Path $OutIso) { Remove-Item $OutIso -Force }
Rename-Item $TmpIso $OutIso
Write-Output "make_iso: ISO criado em $OutIso"
Write-Output "make_iso: kernel=$($kernel.Length) bytes, about=$($aboutBytes.Length) bytes, assets=$assetCount arquivos, $dirCount subdiretorios, iso=$isoLen bytes ($totalSectors setores de 2048)"
