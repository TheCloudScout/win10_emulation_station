Import-Module BitsTransfer

# 
# 1. Chocolatey installs 
# 
choco install directx -y
choco install 7zip -y
choco install emulationstation.install -y
choco install vcredist2008 -y
choco install vcredist2010 -y
choco install vcredist2013 -y
choco install vcredist2015 -y

# 
# 2. Acquire files 
# 
$requirementsFolder = "$PSScriptRoot\requirements\"
New-Item -ItemType Directory -Force -Path $requirementsFolder

Get-Content download_list.json | ConvertFrom-Json | Select -expand downloads | ForEach-Object {

    $url = $_.url
    $file = $_.file
    $output = $requirementsFolder + $file

    if(![System.IO.File]::Exists($output)){

        Write-Host $file "does not exist...Downloading."
        Start-BitsTransfer -Source $url -Destination $output

    } else {

        Write-Host $file "Already exists...Skipping download."

    }

}


# 
# 3. Generate es_systems.cfg
# 
& 'C:\Program Files (x86)\EmulationStation\emulationstation.exe'
$configPath = $env:userprofile+"\.emulationstation\es_systems.cfg"

while (!(Test-Path $configPath)) { 
    Write-Host "Checking for config file..."
    Start-Sleep 5
}

Stop-Process -Name "emulationstation"


# 
# 4. Prepare Retroarch
# 
$retroArchPath = $env:userprofile + "\.emulationstation\systems\retroarch\"
$retroArchBinary = $requirementsFolder + "\RetroArch.7z"

New-Item -ItemType Directory -Force -Path $retroArchPath

Function Expand-Archive([string]$Path, [string]$Destination) {
    $7z_Application = "C:\Program Files\7-Zip\7z.exe"
    $7z_Arguments = @(
        'x'                         ## eXtract files with full paths
        '-y'                        ## assume Yes on all queries
        "`"-o$($Destination)`""     ## set Output directory
        "`"$($Path)`""              ## <archive_name>
    )
    & $7z_Application $7z_Arguments 
}

Expand-Archive -Path $retroArchBinary -Destination $retroArchPath


# 
# 5. Prepare cores
# 
$coresPath = $retroArchPath + "cores"
$newCoreZipFile = $requirementsFolder + "\Cores-v1.0.0.2-64-bit.zip"
New-Item -ItemType Directory -Force -Path $coresPath
Expand-Archive -Path $newCoreZipFile -Destination $coresPath

# NES Setup
$nesCore = $requirementsFolder + "\fceumm_libretro.dll.zip"
Expand-Archive -Path $nesCore -Destination $coresPath

# N64 Setup
$n64Core = $requirementsFolder + "\parallel_n64_libretro.dll.zip"
Expand-Archive -Path $n64Core -Destination $coresPath

# FBA Setup
$fbaCore = $requirementsFolder + "\fbalpha2012_libretro.dll.zip"
Expand-Archive -Path $fbaCore -Destination $coresPath

# GBA Setup
$gbaCore = $requirementsFolder + "\vba_next_libretro.dll.zip"
Expand-Archive -Path $gbaCore -Destination $coresPath

# SNES Setup
$snesCore = $requirementsFolder + "\snes9x_libretro.dll.zip"
Expand-Archive -Path $snesCore -Destination $coresPath

# Genesis GX Setup
$mdCore = $requirementsFolder + "\genesis_plus_gx_libretro.dll.zip"
Expand-Archive -Path $mdCore -Destination $coresPath

# PSX Setup
$psxCore = $requirementsFolder + "\mednafen_psx_libretro.dll.zip"
$psxEmulatorPath = $env:userprofile + "\.emulationstation\systems\epsxe\"
$psxEmulator = $requirementsFolder + "\ePSXe205.zip"
$psxBiosPath = $env:userprofile + "\.emulationstation\bios\"
Expand-Archive -Path $psxCore -Destination $coresPath
New-Item -ItemType Directory -Force -Path $psxEmulatorPath
Expand-Archive -Path $psxEmulatorPath -Destination $psxEmulator


# 
# 6. Start Retroarch and generate a config.
# 
$retroarchExecutable = $retroArchPath + "retroarch.exe"
$retroarchConfigPath = $retroArchPath + "\retroarch.cfg"

& $retroarchExecutable

while (!(Test-Path $retroarchConfigPath)) { 
    Write-Host "Checking for config file..."
    Start-Sleep 5
}

Stop-Process -Name "retroarch"


# 
# 7. Let's hack that config!
# 
$settingToFind = 'video_fullscreen = "false"'
$settingToSet = 'video_fullscreen = "true"'
(Get-Content $retroarchConfigPath) -replace $settingToFind, $settingToSet | Set-Content $retroarchConfigPath


# 
# 8. Add those roms!
# 
$romPath =  $env:userprofile+"\.emulationstation\roms"
New-Item -ItemType Directory -Force -Path $romPath

# Path creation + Open-Source / Freeware Rom population
$nesPath =  $romPath+"\nes"
$nesRom = $requirementsFolder + "\assimilate_full.zip" 
New-Item -ItemType Directory -Force -Path $nesPath
Expand-Archive -Path $nesRom -Destination $nesPath

$n64Path =  $romPath+"\n64"
$n64Rom = $requirementsFolder + "\pom-twin.zip"
New-Item -ItemType Directory -Force -Path $n64Path
Expand-Archive -Path $n64Rom -Destination $n64Path

$gbaPath =  $romPath+"\gba"
$gbaRom = $requirementsFolder + "\uranus0ev_fix.gba"
New-Item -ItemType Directory -Force -Path $gbaPath
Move-Item -Path $gbaRom -Destination $gbaPath

$mdPath = $romPath+"\megadrive"
$mdRom =  $requirementsFolder + "\rickdangerous.gen"
New-Item -ItemType Directory -Force -Path $mdPath
Move-Item -Path $mdRom -Destination $mdPath

$snesPath = $romPath+"\snes"
$snesRom = $requirementsFolder + "\N-Warp Daisakusen V1.1.smc"
New-Item -ItemType Directory -Force -Path $snesPath
Move-Item -Path $snesRom -Destination $snesPath

$psxPath = $romPath+"\psx"
$psxRom = $requirementsFolder + "\Marilyn_In_the_Magic_World_(010a).7z"
New-Item -ItemType Directory -Force -Path $psxPath
Expand-Archive -Path $psxRom -Destination $psxPath

$fbaPath =  $romPath+"\fba"
New-Item -ItemType Directory -Force -Path $fbaPath




# 
# 9. Hack the es_config file
# 
$esConfigFile = $env:userprofile+"\.emulationstation\es_systems.cfg"
$newConfig = "
<systemList>
    <system>
        <name>nes</name>
        <fullname>Nintendo Entertainment System</fullname>
        <path>$nesPath</path>
        <extension>.nes .NES</extension>
        <command>$retroarchExecutable -L $coresPath\fceumm_libretro.dll %ROM%</command>
        <platform>nes</platform>
        <theme>nes</theme>
    </system>
    <system>
        <fullname>Nintendo 64</fullname>
        <name>n64</name>
        <path>$n64Path</path>
        <extension>.z64 .Z64 .n64 .N64 .v64 .V64</extension>
        <command>$retroarchExecutable -L $coresPath\parallel_n64_libretro.dll %ROM%</command>
        <platform>n64</platform>
        <theme>n64</theme>
    </system>
    <system>
        <fullname>Final Burn Alpha</fullname>
        <name>fba</name>
        <path>$fbaPath</path>
        <extension>.zip .ZIP .fba .FBA</extension>
        <command>$retroarchExecutable -L $coresPath\fbalpha2012_libretro.dll %ROM%</command>
        <platform>arcade</platform>
        <theme></theme>
    </system>
    <system>
        <fullname>Game Boy Advance</fullname>
        <name>gba</name>
        <path>$gbaPath</path>
        <extension>.gba .GBA</extension>
        <command>$retroarchExecutable -L $coresPath\vba_next_libretro.dll %ROM%</command>
        <platform>gba</platform>
        <theme>gba</theme>
    </system>
    <system>
        <fullname>Sega Mega Drive / Genesis</fullname>
        <name>megadrive</name>
        <path>$mdPath</path>
        <extension>.smd .SMD .bin .BIN .gen .GEN .md .MD .zip .ZIP</extension>
        <command>$retroarchExecutable -L $coresPath\genesis_plus_gx_libretro.dll %ROM%</command>
        <platform>genesis,megadrive</platform>
        <theme>megadrive</theme>
    </system>
    <system>
        <fullname>Super Nintendo</fullname>
        <name>snes</name>
        <path>$snesPath</path>
        <extension>.smc .sfc .fig .swc .SMC .SFC .FIG .SWC</extension>
        <command>$retroarchExecutable -L $coresPath\snes9x_libretro.dll %ROM%</command>
        <platform>snes</platform>
        <theme>snes</theme>
    </system>
    <system>
        <fullname>Playstation</fullname>
        <name>psx</name>
        <path>$psxPath</path>
        <extension>.cue .iso .pbp .CUE .ISO .PBP</extension>
        <command>%HOME%\.emulationstation\systems\epsxe\ePSXe.exe -bios .emulationstation\bios\SCPH1001.BIN -nogui -loadbin %ROM_RAW%</command>
        <platform>psx</platform>
        <theme>psx</theme>
    </system>
</systemList>
"

Set-Content $esConfigFile -Value $newConfig


# 
# 11. Setup a nice looking theme.
# 
$themesPath = $env:userprofile+"\.emulationstation\themes\"
New-Item -ItemType Directory -Force -Path $themesPath
$themesFile = $requirementsFolder + "\es_theme_recalbox_for_retropie-master.zip"
Expand-Archive -Path $themesFile -Destination $themesPath


# 
# 12. Use updated binaries.
# 
# TO-DO: Find a way to download the new binaries.


# 
# 13. Run the updated EmulationStation binary manually. You can run it from anywhere.
# 
Write-Host "Manually grab the EmulationStation updated binary as stated in Github."


# 14. Enjoy your retro games!
Write-Host "Enjoy!"