param(
    [string]$Out = (Join-Path (Split-Path -Parent $PSScriptRoot) 'disk\system\compiled\prism\bitmap\face.bmp')
)

# Gera um BMP 24-bit (BI_RGB, bottom-up) 16x16 de exemplo:
# um "rosto" usado como sprite de teste. O kernel converte cada pixel
# para a paleta VGA 8bpp e blita no framebuffer.
#
# Referencia de cores (para conferir no serial do kernel):
#   boca  (255,0,0)   -> indice VGA 196
#   olho  (0,0,0)     -> indice VGA 16
#   borda (0,0,128)   -> indice VGA 19

$ErrorActionPreference = 'Stop'

$W = 16
$H = 16
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
Write-LE32 $b 2  ($b.Length)      # file size
Write-LE32 $b 10 54               # pixel data offset
Write-LE32 $b 14 40               # BITMAPINFOHEADER
Write-LE32 $b 18 $W
Write-LE32 $b 22 $H
$b[26] = 1; $b[27] = 0            # planes
Write-LE16 $b 28 24               # bpp
Write-LE32 $b 30 0                # BI_RGB
Write-LE32 $b 34 0                # image size (can be 0)
Write-LE32 $b 38 2835
Write-LE32 $b 42 2835
Write-LE32 $b 46 0
Write-LE32 $b 50 0

$o = 54
for ($y = $H - 1; $y -ge 0; $y--) {
    for ($x = 0; $x -lt $W; $x++) {
        $r = 255; $g = 210; $bl = 160          # pele
        if ($x -eq 0 -or $y -eq 0 -or $x -eq ($W - 1) -or $y -eq ($H - 1)) {
            $r = 0; $g = 0; $bl = 128          # borda azul
        }
        elseif (($x -eq 4 -or $x -eq 11) -and $y -eq 6) {
            $r = 0; $g = 0; $bl = 0            # olhos
        }
        elseif ($y -eq 10 -and $x -ge 6 -and $x -le 9) {
            $r = 255; $g = 0; $bl = 0          # boca (vermelho puro)
        }
        $b[$o]   = $bl
        $b[$o+1] = $g
        $b[$o+2] = $r
        $o += 3
    }
}

$dir = Split-Path -Parent $Out
if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
[IO.File]::WriteAllBytes($Out, $b)
Write-Output "bmp criado: $Out ($($b.Length) bytes, ${W}x$H 24bpp)"
