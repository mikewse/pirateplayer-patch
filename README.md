# pirateplayer-patch

If **PiratePlayer** is giving the error:
```
Ett fel uppstod!
```
then this patch is for you.

The original PiratePlayer has not been updated for a long time so channel definitions are in many cases out of sync with the play sites, leading to errors. Sometimes errors are caused by PiratePlayer's dependency to the external service on pirateplay.se.

This patch installs modifications that make your existing PiratePlayer installation come alive again by installing updated channel definitions and replacing the media download backend so it doesn't rely on pirateplay.se.

## Prerequisites

Existing PiratePlayer installation on Windows

PowerShell 2.0+ (preinstalled on Windows 7 and onwards)

## Installing

Download and run the install script:

[pirateplayer-patch-install.bat](https://github.com/mikewse/pirateplayer-patch/releases/download/1.0/pirateplayer-patch-install.bat)

Accept any UAC elevation prompt.

The installation script will patch some PiratePlayer files and also add some of its own files in `(program files)\Pirateplayer\patch`. **Svtplay-dl** will also be downloaded to this directory and will effectively replace PiratePlayer's dependency to the stream handling on `pirateplay.se`.

## Update to latest version of patch

Run `update.bat` in the `patch` directory to update to the latest changes as they are published.

## Usage

PiratePlayer should be started through `pirateplayer-start.bat` in the `patch` directory to function correctly. The installation script will update PiratePlayer's start menu to reflect this, but you need to update any other shortcuts yourself.

You'll notice a minimized command prompt window when starting with the patch. This window handles the new download backend and will pop new windows showing progress for each download.

## Latest updates

2017 feb 15: updated SVT support after site changes

## Credits

[pirateplayer](https://github.com/jackuess/pirateplayer) by **jackuess** - the original application updated by this patch (my updates [in this fork](https://github.com/mikewse/pirateplayer))

[svtplay-dl](https://github.com/spaam/svtplay-dl) by **spaam** - media download engine used in this patch
