param(
    [Parameter(Mandatory=$true)][string]$Path
)

# Corrige objetos ELF32 convertidos de COFF (objcopy).
# Relocacoes R_386_PC32 (type 2) convertidas do COFF DISP32 mantem o campo com
# addend 0, mas o ELF espera addend -4 (porque P aponta para o campo e a CPU
# soma +4). Resultado: chamadas caindo em simbolo+4. Aqui subtraimos 4 do addend.

$ErrorActionPreference = 'Stop'
$bytes = [System.IO.File]::ReadAllBytes($Path)
if ($bytes.Length -lt 52) { throw "arquivo pequeno demais para ELF" }

$e_shoff   = [BitConverter]::ToUInt32($bytes, 0x20)
$e_shentsz = [BitConverter]::ToUInt16($bytes, 0x2E)
$e_shnum   = [BitConverter]::ToUInt16($bytes, 0x30)

if ($e_shnum -eq 0 -or $e_shoff -eq 0) { throw "sem section headers (nao e ELF relocavel?)" }

$fixed = 0

for ($i = 0; $i -lt $e_shnum; $i++) {
    $base = [int]$e_shoff + ($i * [int]$e_shentsz)
    $sh_type   = [BitConverter]::ToUInt32($bytes, $base + 4)
    $sh_offset = [BitConverter]::ToUInt32($bytes, $base + 16)
    $sh_size   = [BitConverter]::ToUInt32($bytes, $base + 20)
    $sh_info   = [BitConverter]::ToUInt32($bytes, $base + 28)
    $sh_entsz  = [BitConverter]::ToUInt32($bytes, $base + 36)

    if ($sh_type -ne 9) { continue }          # SHT_REL

    $target_shoff = [BitConverter]::ToUInt32($bytes, [int]$e_shoff + ([int]$sh_info * [int]$e_shentsz) + 16)

    $count = [int]($sh_size / [int]$sh_entsz)
    for ($j = 0; $j -lt $count; $j++) {
        $ebase = [int]$sh_offset + ($j * [int]$sh_entsz)
        $r_offset = [BitConverter]::ToUInt32($bytes, $ebase)
        $r_info   = [BitConverter]::ToUInt32($bytes, $ebase + 4)
        $r_type   = [int]($r_info -band 0xFF)

        if ($r_type -ne 2) { continue }        # R_386_PC32

        $pos = [int]$target_shoff + [int]$r_offset
        if ($pos + 4 -gt $bytes.Length) { continue }
        $val = [BitConverter]::ToInt32($bytes, $pos)
        $new = $val - 4
        $b = [BitConverter]::GetBytes($new)
        for ($k = 0; $k -lt 4; $k++) { $bytes[$pos + $k] = $b[$k] }
        $fixed++
    }
}

[System.IO.File]::WriteAllBytes($Path, $bytes)
Write-Output "fixrelocs: $fixed R_386_PC32 ajustados em $Path"
