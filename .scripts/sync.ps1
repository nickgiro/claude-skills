$ErrorActionPreference = "Stop"
$skillsDir = "$env:USERPROFILE\.claude\skills"
$logFile   = "$env:USERPROFILE\.claude\skills-sync.log"

function Log($msg) {
    "$([DateTime]::Now.ToString('yyyy-MM-dd HH:mm:ss'))  $msg" | Out-File -FilePath $logFile -Append -Encoding utf8
}

try {
    Set-Location $skillsDir
    Log "Starting weekly sync"

    git add -A 2>&1 | Out-Null

    $status = git status --porcelain
    if ([string]::IsNullOrWhiteSpace($status)) {
        Log "No local changes — nothing to sync"
        exit 0
    }

    $stamp = [DateTime]::Now.ToString('yyyy-MM-dd HH:mm')
    git commit -m "Weekly sync $stamp" 2>&1 | ForEach-Object { Log $_ }
    git push origin main 2>&1 | ForEach-Object { Log $_ }
    Log "Sync complete"
}
catch {
    Log "ERROR: $_"
    exit 1
}
