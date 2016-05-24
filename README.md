# pirateplayer-patch

Scripts that install updated channel definitions and replaces the media download backend in an existing **PiratePlayer** installation.

## Preqrequisites

Existing PiratePlayer installation on Windows

PowerShell 2.0+

## Installing

Download and run the install script:

[pirateplayer-patch-install.bat](https://github.com/mikewse/pirateplayer-patch/releases/download/1.0/pirateplayer-patch-install.bat)

Accept any UAC elevation prompt.

The installation script will patch some PiratePlayer files and also add some of its own files in `(program files)\Pirateplayer\patch`. **Svtplay-dl** will also be downloaded to this directory and will effectively replace PiratePlayer's dependency to the stream handling on `pirateplay.se`.

Run `update.bat` in the `patch` directory to update to the latest changes as they are published.

## Usage

PiratePlayer should be started through `pirateplayer-start.bat` in the `patch` directory to function correctly. The installation script will update PiratePlayer's start menu to reflect this, but you need to update any other shortcuts yourself.

You'll notice a minimized command prompt window when starting with the patch. This window handles the new download backend and will pop new windows showing progress for each download.

## Credits

[pirateplayer](https://github.com/jackuess/pirateplayer) by jackuess - the original application updated by this patch (my updates [in this fork](https://github.com/mikewse/pirateplayer))

[svtplay-dl](https://github.com/spaam/svtplay-dl) by spaam - media download engine used in this patch
