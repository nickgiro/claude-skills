$skillsDir = "$env:USERPROFILE\.claude\skills"
$logFile   = "$env:USERPROFILE\.claude\skills-sync.log"

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
    ShowToast "Claude Skills Sync - Failed" $msg
    exit 1
}

Set-Location $skillsDir
Log "Starting weekly sync"

git pull --rebase --autostash origin main | Out-Null
if ($LASTEXITCODE -ne 0) { FailAndExit "git pull --rebase failed (exit $LASTEXITCODE) - check working tree for conflict markers" }

git add -A | Out-Null
if ($LASTEXITCODE -ne 0) { FailAndExit "git add failed (exit $LASTEXITCODE)" }

$status = git status --porcelain
if ([string]::IsNullOrWhiteSpace($status)) {
    Log "No local changes - nothing to sync"
    exit 0
}

$stamp = [DateTime]::Now.ToString('yyyy-MM-dd HH:mm')
git commit -m "Weekly sync $stamp" | Out-Null
if ($LASTEXITCODE -ne 0) { FailAndExit "git commit failed (exit $LASTEXITCODE)" }

git push origin main | Out-Null
if ($LASTEXITCODE -ne 0) { FailAndExit "git push failed (exit $LASTEXITCODE)" }

Log "Sync complete"
