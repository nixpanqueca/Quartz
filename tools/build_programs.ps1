# Compiles Aether programs (Pascal units) into flat binaries placed on the
# ISO disk tree:
#   programs\general\*.pas  ->  disk\<NAME>.BIN
#   programs\system\*.pas   ->  disk\system\compiled\<NAME>.BIN
# Each program is linked at PROGRAM_BASE (0x100000) via programs.ld and its
# flat binary is loaded + called by the kernel (kernel\svc.pas RunProgram).

param(
    [string]$RootDir = (Split-Path -Parent $PSScriptRoot)
)

$ErrorActionPreference = 'Stop'

$fpc      = 'fpc'
$nasm     = 'nasm'
$objcopy  = 'i386-elf-objcopy'
$ld       = 'i386-elf-ld'
$fix      = Join-Path $PSScriptRoot 'fixrelocs.ps1'
$progld   = Join-Path $RootDir 'programs.ld'
$stub     = Join-Path $RootDir 'programs\start_program.asm'
$common   = Join-Path $RootDir 'programs\common\svcapi.pas'
$winapi   = Join-Path $RootDir 'programs\common\winapi.pas'
$staging  = Join-Path $RootDir 'build\prog'

if (Test-Path $staging) { Remove-Item $staging -Recurse -Force }
New-Item -ItemType Directory -Path $staging | Out-Null

# --- compile shared service API once --------------------------------------
& $fpc -Sg -al $common | Out-Null
if ($LASTEXITCODE -ne 0) { throw "fpc svcapi falhou" }
& $fpc -Sg -al $winapi | Out-Null
if ($LASTEXITCODE -ne 0) { throw "fpc winapi falhou" }

# --- assemble shared entry stub --------------------------------------------
$stubObj = Join-Path $staging 'start_program.o'
& $nasm $stub -f elf32 -o $stubObj
if ($LASTEXITCODE -ne 0) { throw "nasm start_program falhou" }

function Build-Program([string]$Src, [string]$DestDir) {
    $name   = [IO.Path]::GetFileNameWithoutExtension($Src)
    $obj    = [IO.Path]::ChangeExtension($Src, '.o')     # fpc escreve ao lado da fonte
    $elfObj = Join-Path $staging ($name + '_elf.o')
    $elf    = Join-Path $staging ($name + '.elf')
    $flat   = Join-Path $DestDir ($name.ToUpper() + '.BIN')
    $commonDir = Join-Path $RootDir 'programs\common'
    $svcapiCoff = Join-Path $commonDir 'svcapi.o'
    $svcapiElf  = Join-Path $staging 'svcapi_elf.o'
    $winapiCoff = Join-Path $commonDir 'winapi.o'
    $winapiElf  = Join-Path $staging 'winapi_elf.o'

    & $fpc -Sg -al -Fu"$commonDir" "$Src" | Out-Null
    if ($LASTEXITCODE -ne 0) { throw "fpc $name falhou" }

    & $objcopy -O elf32-i386 --input-target=coff-i386 $obj $elfObj
    if ($LASTEXITCODE -ne 0) { throw "objcopy $name falhou" }
    & $objcopy -O elf32-i386 --input-target=coff-i386 $svcapiCoff $svcapiElf
    if ($LASTEXITCODE -ne 0) { throw "objcopy svcapi falhou" }
    & $objcopy -O elf32-i386 --input-target=coff-i386 $winapiCoff $winapiElf
    if ($LASTEXITCODE -ne 0) { throw "objcopy winapi falhou" }

    & powershell -ExecutionPolicy Bypass -File $fix -Path $elfObj | Out-Null
    & powershell -ExecutionPolicy Bypass -File $fix -Path $svcapiElf | Out-Null
    & powershell -ExecutionPolicy Bypass -File $fix -Path $winapiElf | Out-Null

    & $ld -T $progld $stubObj $svcapiElf $winapiElf $elfObj -o $elf
    if ($LASTEXITCODE -ne 0) { throw "ld $name falhou" }

    & $objcopy -O binary $elf $flat
    if ($LASTEXITCODE -ne 0) { throw "objcopy bin $name falhou" }
    Write-Output ("build_programs: {0} -> {1}" -f $name, $flat)
}

$general = Join-Path $RootDir 'programs\general'
if (Test-Path $general) {
    foreach ($f in Get-ChildItem -Path $general -Filter *.pas) {
        Build-Program $f.FullName (Join-Path $RootDir 'disk')
    }
}

$system = Join-Path $RootDir 'programs\system'
$sysDest = Join-Path $RootDir 'disk\system\compiled'
if (Test-Path $system) {
    foreach ($f in Get-ChildItem -Path $system -Filter *.pas) {
        Build-Program $f.FullName $sysDest
    }
}

# --- cleanup object artifacts from the source dirs -------------------------
foreach ($d in @((Join-Path $RootDir 'programs\common'),
                  (Join-Path $RootDir 'programs\general'),
                  (Join-Path $RootDir 'programs\system'))) {
    if (-not (Test-Path $d)) { continue }
    Get-ChildItem -Path $d -File -Include *.o,*.ppu,*.s -ErrorAction SilentlyContinue |
        Remove-Item -Force -ErrorAction SilentlyContinue
}
