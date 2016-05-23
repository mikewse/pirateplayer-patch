param(
    [string] $cmd
)

if ($cmd -eq "start") {
    $script = $MyInvocation.MyCommand.Name
    $dir = (Get-Location).Path
    Start-Process -WorkingDirectory $dir -NoNewWindow -FilePath powershell -ArgumentList "-executionpolicy bypass -file $script"
    exit
}
if ($cmd -eq "stop") {
    Invoke-WebRequest -Uri "http://localhost:1199/exit" >$null
    exit
}

$listenUrl = "http://localhost:1199/"
Write-Host "PiratePlayer backend starting at $listenUrl"

$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add($listenUrl)
$listener.Start()

Write-Host "Waiting for download requests"
$running = $true
while ($running -eq $true)
{
    $context = $listener.GetContext()
    $url = $context.Request.Url

    # Write-Host ''
    # Write-Host "> $url"

    $path = $url.LocalPath
    $query = $context.Request.QueryString
    $found = $true
    if ($path -eq "/download") {
        $videoPageUrl = $query.Item("url")
        $outFile = $query.Item("out")
        $subTitles = $query.Item("sub")
        Write-Host "Downloading $videoPageUrl"
        cmd /c start cmd /c download.bat """$videoPageUrl""" """$outFile""" $subTitles
    } elseif ($path -eq "/exit") {
        $running = $false
    } else {
        $found = $false
    }

    $response = $context.Response
    if ($found -ne $true) {
        $response.StatusCode = 404
    }
    # Write-Host "<" $response.StatusCode
    $response.Close()
}

$listener.Close()
Write-Host "Closing"
