param(
    [string]$Out = (Join-Path (Split-Path -Parent $PSScriptRoot) 'disk\system\compiled\prism\bitmap\app.bmp')
)

# Generates a 32x32 24-bit (BI_RGB, bottom-up) placeholder "app" icon for
# the desktop shortcut demo. Uses a blue rounded window with a lighter
# glyph so it reads well on the gray desktop.

$ErrorActionPreference = 'Stop'

$W = 32
$H = 32
$RowSize = [int][Math]::Ceiling($W * 3 / 4) * 4
$b = New-Object 'System.Byte[]' (54 + $RowSize * $H)

function Write-LE32([byte[]]$b, [int]$o, [int]$v) {
    $b[$o]   = $v -band 0xFF
    $b[$o+1] = ($v -shr 8)  -band 0xFF
    $b[$o+2] = ($v -shr 16) -band 0xFF
    $b[$o+3] = ($v -shr 24) -band 0xFF
}
function Write-LE16([byte[]]$b, [int]$o, [int]$v) {
    $b[$o]   = $v -band 0xFF
    $b[$o+1] = ($v -shr 8)  -band 0xFF
}

$b[0] = 0x42
$b[1] = 0x4D
Write-LE32 $b 2  ($b.Length)
Write-LE32 $b 10 54
Write-LE32 $b 14 40
Write-LE32 $b 18 $W
Write-LE32 $b 22 $H
$b[26] = 1; $b[27] = 0
Write-LE16 $b 28 24
Write-LE32 $b 30 0
Write-LE32 $b 34 0
Write-LE32 $b 38 2835
Write-LE32 $b 42 2835
Write-LE32 $b 46 0
Write-LE32 $b 50 0

function Rgba($x, $y) {
    # body blue
    $r = 45; $g = 100; $bl = 200
    $in = ($x -ge 4 -and $x -lt 28 -and $y -ge 4 -and $y -lt 28)
    # rounded corners (cut the 4 corners of the body)
    $corner = ($x -lt 4 -or $x -ge 28 -or $y -lt 4 -or $y -ge 28) -and
              (($x -eq 3 -or $x -eq 28) -or ($y -eq 3 -or $y -eq 28))
    if ($in) {
        $r = 45; $g = 110; $bl = 210
    }
    # border
    if ($x -eq 4 -or $x -eq 27 -or $y -eq 4 -or $y -eq 27) {
        $r = 20; $g = 55; $bl = 130
    }
    # light glyph: a simple "A" made of 3 lines
    if ($in -and ($x -ge 9 -and $x -le 22)) {
        $mid = 10 + (($x - 9) * 1)
        if ($y -ge 12 -and $y -le 24) {
            # left + right legs and crossbar of an "A"
            if (($x -eq $mid -and $x -ge 9 -and $x -le 15) -and $y -lt 20) { $r=235; $g=240; $bl=255 }
            if ($x -eq (22 - ($x - 9)) -and $x -ge 17 -and $x -le 22) { $r=235; $g=240; $bl=255 }
            if ($y -eq 16 -and $x -ge 10 -and $x -le 21) { $r=235; $g=240; $bl=255 }
        }
    }
    return ,@($r, $g, $bl)
}

$o = 54
for ($y = $H - 1; $y -ge 0; $y--) {
    for ($x = 0; $x -lt $W; $x++) {
        $c = Rgba $x $y
        $b[$o]   = $c[2]
        $b[$o+1] = $c[1]
        $b[$o+2] = $c[0]
        $o += 3
    }
}

$dir = Split-Path -Parent $Out
if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
[IO.File]::WriteAllBytes($Out, $b)
Write-Output "app.bmp criado: $Out ($($b.Length) bytes, ${W}x$H 24bpp)"
