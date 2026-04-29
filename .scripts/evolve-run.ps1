$logFile   = "$env:USERPROFILE\.claude\evolve-run.log"
$claudeBin = "$env:USERPROFILE\.local\bin\claude.exe"

function Log($msg) {
    "$([DateTime]::Now.ToString('yyyy-MM-dd HH:mm:ss'))  $msg" | Out-File -FilePath $logFile -Append -Encoding utf8
}

function ShowToast($title, $body) {
    try {
        [void][Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime]
        [void][Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime]
        $xml = New-Object Windows.Data.Xml.Dom.XmlDocument
        $xml.LoadXml("<toast><visual><binding template='ToastGeneric'><text>$title</text><text>$body</text></binding></visual></toast>")
        $toast = New-Object Windows.UI.Notifications.ToastNotification($xml)
        [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("Microsoft.PowerShell").Show($toast)
    } catch {
        Log "Toast failed: $_"
    }
}

function FailAndExit($msg) {
    Log $msg
    ShowToast "Evolve Skills - Failed" $msg
    exit 1
}

Set-Location $env:USERPROFILE
Log "Starting evolve-skills run"

if (-not (Test-Path $claudeBin)) { FailAndExit "claude.exe not found at $claudeBin" }

$output = & $claudeBin -p "/evolve-skills" `
    --permission-mode bypassPermissions `
    --no-session-persistence `
    --max-budget-usd 2

$exitCode = $LASTEXITCODE
Log "claude exit code: $exitCode"
$output | ForEach-Object { Log "claude: $_" }

if ($exitCode -ne 0) {
    FailAndExit "evolve-skills run failed (exit $exitCode) - check log"
}

Log "evolve-skills run complete"
