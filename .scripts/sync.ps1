$skillsDir = "$env:USERPROFILE\.claude\skills"
$logFile   = "$env:USERPROFILE\.claude\skills-sync.log"

function Log($msg) {
    "$([DateTime]::Now.ToString('yyyy-MM-dd HH:mm:ss'))  $msg" | Out-File -FilePath $logFile -Append -Encoding utf8
}

Set-Location $skillsDir
Log "Starting weekly sync"

git add -A | Out-Null
if ($LASTEXITCODE -ne 0) { Log "git add failed (exit $LASTEXITCODE)"; exit 1 }

$status = git status --porcelain
if ([string]::IsNullOrWhiteSpace($status)) {
    Log "No local changes - nothing to sync"
    exit 0
}

$stamp = [DateTime]::Now.ToString('yyyy-MM-dd HH:mm')
git commit -m "Weekly sync $stamp" | Out-Null
if ($LASTEXITCODE -ne 0) { Log "git commit failed (exit $LASTEXITCODE)"; exit 1 }

git push origin main | Out-Null
if ($LASTEXITCODE -ne 0) { Log "git push failed (exit $LASTEXITCODE)"; exit 1 }

Log "Sync complete"
