# convert_bmp_all.ps1 - Converts all BMPs in a folder to 24-bit (in-place)
param([string]$Dir)

$files = Get-ChildItem -LiteralPath $Dir -Filter "*.bmp" -File
foreach ($f in $files) {
    $b = [System.IO.File]::ReadAllBytes($f.FullName)
    $bpp = [BitConverter]::ToUInt16($b, 28)
    if ($bpp -eq 24) {
        Write-Host "$($f.Name): already 24-bit, skipping"
        continue
    }
    $w = [BitConverter]::ToInt32($b, 18)
    $h = [BitConverter]::ToInt32($b, 22)
    $off = [BitConverter]::ToInt32($b, 10)
    $hsz = [BitConverter]::ToInt32($b, 14)
    $palBase = 14 + $hsz
    $rowBytes = [Math]::Floor(($w * 24 + 31) / 32) * 4
    $outSize = 54 + [Math]::Abs($h) * $rowBytes
    $out = New-Object byte[] $outSize

    $out[0] = 0x42; $out[1] = 0x4D
    [BitConverter]::GetBytes([int]$outSize).CopyTo($out, 2)
    $out[10] = 54; $out[11] = 0; $out[12] = 0; $out[13] = 0
    for($i = 14; $i -lt 54; $i++) { $out[$i] = $b[$i] }
    $out[28] = 24; $out[29] = 0
    $out[30] = 0; $out[31] = 0; $out[32] = 0; $out[33] = 0
    [BitConverter]::GetBytes([int]([Math]::Abs($h) * $rowBytes)).CopyTo($out, 34)
    $out[46] = 0; $out[47] = 0; $out[48] = 0; $out[49] = 0
    $out[50] = 0; $out[51] = 0; $out[52] = 0; $out[53] = 0

    $absH = [Math]::Abs($h)
    $isTopDown = $h -lt 0
    $rowIn = 0
    for($y = 0; $y -lt $absH; $y++) {
        $srcOff = $off + $rowIn * [Math]::Floor(($w * $bpp + 31) / 32) * 4
        $dstOff = 54 + $y * $rowBytes
        for($x = 0; $x -lt $w; $x++) {
            if($bpp -eq 8) {
                $idx = $b[$srcOff + $x]
                $bgr = $palBase + $idx * 4
                $out[$dstOff + $x * 3 + 0] = $b[$bgr + 0]
                $out[$dstOff + $x * 3 + 1] = $b[$bgr + 1]
                $out[$dstOff + $x * 3 + 2] = $b[$bgr + 2]
            } elseif($bpp -eq 32) {
                $srcP = $srcOff + $x * 4
                $out[$dstOff + $x * 3 + 0] = $b[$srcP + 0]
                $out[$dstOff + $x * 3 + 1] = $b[$srcP + 1]
                $out[$dstOff + $x * 3 + 2] = $b[$srcP + 2]
            }
        }
        $rowIn++
    }
    [System.IO.File]::WriteAllBytes($f.FullName, $out)
    Write-Host "$($f.Name): $bpp -> 24bit, $($w)x$($absH), $outSize bytes"
}
Write-Host "Done."
