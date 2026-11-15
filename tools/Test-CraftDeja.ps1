param(
    [string]$ProjectPath = (Split-Path -Parent $PSScriptRoot),
    [string[]]$Filter = @(),
    [switch]$SkipBuild,
    [switch]$OpenReportFolder
)
$ErrorActionPreference = 'Stop'
$project = (Resolve-Path -LiteralPath $ProjectPath).Path
$started = [DateTimeOffset]::Now
$reportRoot = Join-Path $project 'reports/tests'
$runName = $started.ToString('yyyyMMdd-HHmmss') + '-' + [guid]::NewGuid().ToString('N').Substring(0,6)
$reportDir = Join-Path $reportRoot $runName
New-Item -ItemType Directory -Path $reportDir -Force | Out-Null
$utf8 = New-Object System.Text.UTF8Encoding($false)
$log = New-Object System.Text.StringBuilder
$code = 1
$summary = 'Tests not started / Tests nicht gestartet'
$runnerError = ''
$meta = [ordered]@{
    started = $started.ToString('o'); ended = $null; project = $project
    addonVersion = $null; toolVersion = $null; gitCommit = $null; gitBranch = $null
    sourceHashes = [ordered]@{}; blizzardUI = $null; filters = @($Filter)
    build = 'not_started'; testExitCode = $null; passed = $null; failed = $null; skipped = $null
    result = 'not_started'; runnerError = $null
}

function ConvertTo-NativeArgument([string]$Value) {
    if ($Value.Length -gt 0 -and $Value -notmatch '[\s"]') { return $Value }
    $escaped = [regex]::Replace($Value, '(\\*)"', '$1$1\"')
    $escaped = [regex]::Replace($escaped, '(\\+)$', '$1$1')
    return '"' + $escaped + '"'
}
function Invoke-LoggedProcess([string]$Executable, [string[]]$NativeArgs, [string]$Label) {
    $info = New-Object System.Diagnostics.ProcessStartInfo
    $info.FileName = $Executable
    $info.Arguments = (($NativeArgs | ForEach-Object { ConvertTo-NativeArgument $_ }) -join ' ')
    $info.WorkingDirectory = $project
    $info.UseShellExecute = $false
    $info.RedirectStandardOutput = $true
    $info.RedirectStandardError = $true
    $info.StandardOutputEncoding = [System.Text.Encoding]::UTF8
    $info.StandardErrorEncoding = [System.Text.Encoding]::UTF8
    $info.CreateNoWindow = $true
    $process = New-Object System.Diagnostics.Process
    $process.StartInfo = $info
    [void]$log.AppendLine("=== $Label ===")
    [void]$log.AppendLine('Command: wowlua ' + $info.Arguments)
    Write-Host "Starting $Label. Report: $reportDir"
    $timer = [System.Diagnostics.Stopwatch]::StartNew()
    try {
        if (-not $process.Start()) { throw "$Label could not start." }
        $outTask = $process.StandardOutput.ReadToEndAsync()
        $errTask = $process.StandardError.ReadToEndAsync()
        $lastNotice = 0
        while (-not $process.WaitForExit(1000)) {
            $seconds = [int]$timer.Elapsed.TotalSeconds
            if ($seconds -ge $lastNotice + 15) {
                Write-Host "$Label running: $seconds seconds."
                $lastNotice = $seconds
            }
        }
        $outText = $outTask.Result
        $errText = $errTask.Result
        $nativeCode = $process.ExitCode
        [void]$log.AppendLine('STDOUT:')
        [void]$log.AppendLine($outText)
        [void]$log.AppendLine('STDERR:')
        [void]$log.AppendLine($errText)
        [void]$log.AppendLine("Exit code: $nativeCode")
        Write-Host $outText
        Write-Host $errText
        return [pscustomobject]@{ ExitCode=$nativeCode; Text=($outText + "`n" + $errText) }
    }
    finally { $process.Dispose() }
}

try {
    Set-Location -LiteralPath $project
    if ($env:USERPROFILE) {
        $wowluaBin = Join-Path $env:USERPROFILE '.wowlua/bin'
        $env:PATH = $wowluaBin + [System.IO.Path]::PathSeparator + $env:PATH
    }
    if (-not $env:WOWLUA_WOW_PATH) {
        $defaultWow = 'C:\Program Files (x86)\World of Warcraft'
        if (Test-Path -LiteralPath (Join-Path $defaultWow '_forever_')) { $env:WOWLUA_WOW_PATH = $defaultWow }
    }
    $config = Get-Content -LiteralPath (Join-Path $project 'wowlua.json') -Raw | ConvertFrom-Json
    $meta.addonVersion = $config.package.version
    $meta.blizzardUI = [bool]$config.test.'blizzard-ui'
    foreach ($name in @('Start','Client','Economy','Poisons','Run','Access','MapPins','Trainers','Data/RecipeSourceCorrections','Data/FactionAccess','AuctionBridge','PurchaseState','Shopping','CraftActions','PlanningGoals','Acquisition','Screen','UnifiedUI')) {
        $source = Join-Path $project "src/$name.lua"
        if (Test-Path -LiteralPath $source) { $meta.sourceHashes[$name] = (Get-FileHash -LiteralPath $source -Algorithm SHA256).Hash }
    }
    if (Get-Command git -CommandType Application -ErrorAction SilentlyContinue) {
        $commit = git rev-parse HEAD 2>$null
        if ($LASTEXITCODE -eq 0) { $meta.gitCommit = ($commit | Out-String).Trim() }
        $branch = git branch --show-current 2>$null
        if ($LASTEXITCODE -eq 0) { $meta.gitBranch = ($branch | Out-String).Trim() }
    }
    $exe = (Get-Command wowlua -CommandType Application -ErrorAction Stop).Source
    $version = Invoke-LoggedProcess $exe @('--version') 'version'
    if ($version.ExitCode -ne 0) { throw 'Version query failed.' }
    $meta.toolVersion = $version.Text.Trim()
    if ($SkipBuild) { $meta.build = 'skipped' }
    else {
        $build = Invoke-LoggedProcess $exe @('build','--color','never') 'build'
        $meta.build = if ($build.ExitCode -eq 0) { 'passed' } else { 'failed' }
        if ($build.ExitCode -ne 0) { throw 'Build failed; tests not run.' }
    }
    $nativeArgs = @('test','--color','never') + @($Filter)
    $tests = Invoke-LoggedProcess $exe $nativeArgs 'tests'
    $meta.testExitCode = $tests.ExitCode
    $match = [regex]::Match($tests.Text, '(?:Tested\s+|tests failed:\s*)(\d+) passed,\s*(\d+) failed,\s*(\d+) skipped[^\r\n]*')
    if ($match.Success) {
        $meta.passed = [int]$match.Groups[1].Value
        $meta.failed = [int]$match.Groups[2].Value
        $meta.skipped = [int]$match.Groups[3].Value
        $summary = $match.Value
    }
    else { $summary = 'No standard test summary found; inspect the complete log.' }
    if ($tests.ExitCode -eq 0 -and $match.Success -and $meta.passed -gt 0 -and $meta.failed -eq 0) {
        $code = 0
        $meta.result = if ($meta.skipped -gt 0) { 'passed_with_skips' } else { 'passed' }
    }
    else { $code = 1; $meta.result = 'failed_or_incomplete' }
}
catch {
    $runnerError = ($_ | Out-String).Trim()
    $meta.result = 'runner_or_build_error'
    $meta.runnerError = $runnerError
    [void]$log.AppendLine('RUNNER ERROR:')
    [void]$log.AppendLine($runnerError)
    $code = 1
    Write-Host $runnerError
}
finally {
    $meta.ended = [DateTimeOffset]::Now.ToString('o')
    $scope = if ($Filter.Count -gt 0) { $Filter -join ', ' } else { 'ALL tests / alle Tests' }
    $text = @"
# CraftDeja Testbericht

Ergebnis / result: $($meta.result)
Version: $($meta.addonVersion)
Tool: $($meta.toolVersion)
Git: $($meta.gitCommit) | $($meta.gitBranch)
Beginn: $($meta.started)
Ende: $($meta.ended)
Umfang / scope: $scope
Blizzard UI enabled: $($meta.blizzardUI)
Build: $($meta.build)

$summary

$runnerError

Das Protokoll trennt STDOUT und STDERR je Prozess; die Reihenfolge zwischen diesen Streams ist nicht rekonstruiert.
Automatisierte Tests, kein Nachweis einer vollstaendigen Liveserver-Pruefung.
Diese ZIP kannst du im Chat anhaengen. Ein lokaler C:\-Pfad allein ist kein erreichbarer Downloadlink.
"@
    $summaryPath = Join-Path $reportDir 'BERICHT.md'
    $logPath = Join-Path $reportDir 'PROTOKOLL.txt'
    $metaPath = Join-Path $reportDir 'METADATEN.json'
    [System.IO.File]::WriteAllText($summaryPath, $text, $utf8)
    [System.IO.File]::WriteAllText($logPath, $log.ToString(), $utf8)
    [System.IO.File]::WriteAllText($metaPath, ($meta | ConvertTo-Json -Depth 8), $utf8)
    $archive = $reportDir + '.zip'
    Compress-Archive -LiteralPath @($summaryPath,$logPath,$metaPath) -DestinationPath $archive
    [System.IO.File]::WriteAllText((Join-Path $reportRoot 'LETZTER_BERICHT.txt'), $archive, $utf8)
    Write-Host "`n$summary"
    Write-Host "BERICHT-ZIP ZUM ANHAENGEN: $archive"
    if ($OpenReportFolder -and $env:OS -eq 'Windows_NT') {
        Start-Process -FilePath explorer.exe -ArgumentList "/select,`"$archive`""
    }
}
exit $code
