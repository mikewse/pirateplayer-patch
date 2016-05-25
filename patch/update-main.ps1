param(
    [string] $programDir,
    [string] $outfile
)

# Check some stuff while in user mode and then respawn ourselves in elevated shell (trigger UAC prompt)
if ($programDir -eq "" -or $outfile -eq "") {
    try {
        if ($PSVersionTable.PSVersion.Major -lt 2) {
            throw "Installation requires Powershell 2.0 or later"
        }

        $script = $MyInvocation.MyCommand.Path

        # Find existing Pirateplayer installation
        $scriptDir = Split-Path -Parent $script
        $parentDir = Split-Path -Parent $scriptDir
        if (Test-Path "${env:ProgramFiles}\Pirateplayer") {
            $programDir = "${env:ProgramFiles}\Pirateplayer"
        } elseif (Test-Path "${env:ProgramFiles(x86)}\Pirateplayer") {
            $programDir = "${env:ProgramFiles(x86)}\Pirateplayer"
        } elseif (((Split-Path -Leaf $scriptDir) -eq "patch") -and (Test-Path "$parentDir\pirateplayer.exe")) {
            $programDir = $parentDir
        } else {
            $programDir = Read-Host "Specify full path to existing PiratePlayer installation directory"
        }

        $outfile = "${env:TEMP}\update-output-$pid.txt"
        New-Item -Type File -Force -Path $outfile >$null
        Start-Process -FilePath powershell.exe -Verb runas -WindowStyle Hidden -ArgumentList "-executionpolicy bypass -file ""$script"" ""$programDir"" ""$outfile"""
        Get-Content -Path $outfile -Wait 2>$null
    } catch {
        Write-Output "Error: $_"
    }
    Start-Sleep -Milliseconds 2000
    if ($parentDir -ne $programDir) {
        del $script
    }
    return
}

# Do main work redirecting output to file
& {
    function CreateDirectoryIfNeeded($path) {
        if (-not $(Test-Path -Path $path)) {
            Write-Output "Creating directory $path"
            mkdir $path >$null
        }
    }

    function UpdateLocalFile($src, $target) {
        if (-not $(Test-Path $target)) {
            Write-Output "Copying $(Split-Path -Leaf $target)"
            Copy-Item $src $target
        }
    }

    function UpdateDownloadedFile($url, $path) {
        Write-Output "Checking $(Split-Path -Leaf $path)"
        $tmp = "$path-$pid.tmp"
        (New-Object System.Net.WebClient).DownloadFile("$url", "$tmp") # no Invoke-WebRequest on Win 7
        fc.exe /b "$path" "$tmp" 2>&1 >$null
        if ($LastExitCode -ne 0) {
            Write-Output "- updating"
            move -Force "$tmp" "$path"
        } else {
            del "$tmp"
        }
    }

    try {
        # Check input valid
        if (!(Test-Path "$programDir\pirateplayer.exe")) {
            throw "Invalid Pirateplayer installation directory"
        }

		# Find existing gui dir
        $guiDir = "${env:LOCALAPPDATA}\pirateplay\pirateplayer\gui"
        if (!(Test-Path $guiDir)) {
            throw "Can't find Pirateplayer gui directory"
        }

        Write-Output "Updating PiratePlayer in $programDir"

        # Create patch directory
        $patchDir = "$programDir\patch"
        CreateDirectoryIfNeeded $patchDir

        # Update patch directory
        $patchFiles = 
            "backend-server.ps1",
            "download.bat",
            "pirateplayer-start.bat",
            "update.bat",
            "update-main.ps1"
        foreach($f in $patchFiles) {
            $patchGithub = "https://raw.githubusercontent.com/mikewse/pirateplayer-patch/master"
            UpdateDownloadedFile "$patchGithub/patch/$f" "$patchDir\$f"
        }
        UpdateLocalFile "$programDir\ffmpeg.exe" "$patchDir\ffmpeg.exe"
        UpdateDownloadedFile https://svtplay-dl.se/download/latest/svtplay-dl.exe "$patchDir\svtplay-dl.exe"

        # Update gui directory
        $guiFiles = 
            "main.qml", 
            "browser/pirateplay.qml", 
            "browser/menu.qml", 
            "browser/svt/alfabetical.qml", 
            "browser/svt/open_a-z.qml", 
            "browser/svt/open_program.qml", 
            "browser/svt/program.qml", 
            "browser/tv4/a-z.qml", 
            "browser/tv4/program.qml", 
            "imports/_common/Components/StreamDialog.qml", 
            "JSONListModel/JSONListModel.qml"
        foreach($f in $guiFiles) {
            $guiGithub = "https://raw.githubusercontent.com/mikewse/pirateplayer/master"
            UpdateDownloadedFile "$guiGithub/src/gui/qml/$f" ("$guiDir\$f" -replace "/","\")
        }

        # Update start menu shortcut
        $startMenuDir = "${env:APPDATA}\Microsoft\Windows\Start Menu\Programs\Pirateplayer"
        $newTarget = "$patchDir\pirateplayer-start.bat"
        if (Test-Path $startMenuDir) {
            $shell = New-Object -ComObject Wscript.Shell
            $lnk = $shell.createShortcut("$startMenuDir\Pirateplayer.lnk")
            $oldTarget = $lnk.targetPath
            if ($oldTarget -ne $newTarget) {
                Write-Output "Updating start menu shortcut"
                $lnk.targetPath = $newTarget
                $lnk.windowStyle = 7
                $lnk.Save()
            }
        }
        Write-Output "Update completed"
    } catch {
        Write-Output "Error: $_"
    }
} >$outfile

Start-Sleep -Milliseconds 1000
del $outfile
