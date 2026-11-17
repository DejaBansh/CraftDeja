param(
    [string]$ProjectPath = (Split-Path -Parent $PSScriptRoot),
    [switch]$AsJson,
    [switch]$Strict
)
# Read-only, local snapshot. No fetch, build, install, process scan or report writes.
$ErrorActionPreference = 'Stop'
$root = (Resolve-Path -LiteralPath $ProjectPath).Path
$warnings = New-Object 'System.Collections.Generic.List[string]'
function Local-Path([string]$Relative) {
    if ([IO.Path]::IsPathRooted($Relative)) { throw 'Expected repository-relative path' }
    $full = [IO.Path]::GetFullPath((Join-Path $root $Relative))
    $prefix = $root.TrimEnd([IO.Path]::DirectorySeparatorChar) + [IO.Path]::DirectorySeparatorChar
    if (-not $full.StartsWith($prefix, [StringComparison]::OrdinalIgnoreCase)) { throw 'Path escapes project' }
    return $full
}
function Read-Json([string]$Relative) {
    Get-Content -LiteralPath (Local-Path $Relative) -Raw -Encoding UTF8 | ConvertFrom-Json
}
function Git-Read([string[]]$Arguments) {
    $value = & git --no-optional-locks -C $root @Arguments 2>$null
    if ($LASTEXITCODE -ne 0) { throw ('Git read failed: ' + ($Arguments -join ' ')) }
    return ($value -join "`n").TrimEnd()
}
$config = Read-Json 'wowlua.json'
$git = $null
if (Get-Command git -CommandType Application -ErrorAction SilentlyContinue) {
    $remotes = @()
    foreach ($remote in @((Git-Read @('remote')) -split "`n" | Where-Object { $_ })) {
        # Do not expose credentials embedded in a remote URL.
        $url = Git-Read @('remote','get-url',$remote)
        $url = $url -replace '(https?://)[^/@\s]+@','$1[redacted]@' -replace '[?#].*$',''
        $remotes += [ordered]@{name=$remote;url=$url}
    }
    $git = [ordered]@{
        version = Git-Read @('--version')
        root = Git-Read @('rev-parse','--show-toplevel')
        branch = Git-Read @('branch','--show-current')
        head = Git-Read @('rev-parse','HEAD')
        changes = @( (Git-Read @('status','--porcelain=v1','--untracked-files=normal')) -split "`n" | Where-Object { $_ } )
        remotes = $remotes
        remoteVerified = $false
    }
    if (-not $git.branch) { $warnings.Add('Detached HEAD; inspect exact tag/commit before changes.') }
    if ([IO.Path]::GetFullPath($git.root) -ne $root) { $warnings.Add('Project path differs from Git root; inspect checkout selection.') }
} else { $warnings.Add('Git unavailable; branch, commit and worktree not verified.') }
$wowlua = $null
$exe = $null
if ($env:USERPROFILE) {
    $candidate = Join-Path $env:USERPROFILE '.wowlua/bin/wowlua.exe'
    if (Test-Path -LiteralPath $candidate -PathType Leaf) { $exe = $candidate }
}
if (-not $exe) {
    $command = Get-Command wowlua -CommandType Application -ErrorAction SilentlyContinue
    if ($command) { $exe = $command.Source }
}
if ($exe) {
    $version = & $exe --version 2>&1
    if ($LASTEXITCODE -eq 0) { $wowlua = [ordered]@{path=$exe;version=($version -join "`n").Trim()} }
    else { $warnings.Add('WoWLua version query failed.') }
} else { $warnings.Add('WoWLua unavailable; no installation attempted.') }

$evidence = [ordered]@{status='unavailable';hashScope='Recorded Lua sources, wowlua tests and inputs only; no artwork/live proof'}
try {
    $index = Read-Json 'docs/evidence/index.json'
    if ($index.schemaVersion -ne 1) { throw 'Unsupported evidence index schema' }
    $entries = @($index.entries | Where-Object { $_.id -eq $index.current })
    if ($entries.Count -ne 1) { throw 'Evidence current ID must identify exactly one entry' }
    $entry = $entries[0]
    $manifest = Read-Json $entry.manifest
    $differences = New-Object 'System.Collections.Generic.List[string]'
    if ($manifest.addonVersion -ne $config.package.version -or $entry.version -ne $manifest.addonVersion) {
        $differences.Add('Addon version differs from evidence')
    }
    foreach ($field in @('sourceHashes','testHashes','inputHashes')) {
        $map = $manifest.$field
        if (-not $map -or @($map.PSObject.Properties).Count -eq 0) { throw ('Empty hash map: '+$field) }
        $recorded = @{}
        foreach ($property in $map.PSObject.Properties) {
            if ($property.Value -notmatch '^[a-fA-F0-9]{64}$') { throw ('Invalid SHA256: '+$property.Name) }
            $relative = $property.Name
            if ($field -eq 'sourceHashes') { $relative = 'src/' + $relative + '.lua' }
            $relative = $relative.Replace('\','/')
            $path = Local-Path $relative
            $recorded[$relative] = $true
            if (-not (Test-Path -LiteralPath $path -PathType Leaf)) { $differences.Add('Missing: '+$relative) }
            elseif ((Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash -ne $property.Value) {
                $differences.Add('Changed: '+$relative)
            }
        }
        if ($field -eq 'inputHashes') {
            foreach ($required in @('wowlua.json','wowlua.lock','tools/Test-CraftDeja.ps1')) {
                if (-not $recorded.ContainsKey($required)) { $differences.Add('Input not recorded: '+$required) }
            }
        }
        # A matching old subset must not silently cover newly added runtime/tests.
        if ($field -in @('sourceHashes','testHashes')) {
            $folder = 'src'; $filter = '*.lua'
            if ($field -eq 'testHashes') { $folder = 'tests'; $filter = '*.wowlua' }
            foreach ($file in Get-ChildItem -LiteralPath (Local-Path $folder) -Recurse -File -Filter $filter) {
                $relative = $file.FullName.Substring($root.Length + 1).Replace('\','/')
                if (-not $recorded.ContainsKey($relative)) { $differences.Add('Not recorded: '+$relative) }
            }
        }
    }
    $reportPath = Local-Path $entry.report
    $reportStatus = 'missing'
    if (Test-Path -LiteralPath $reportPath -PathType Leaf) {
        $reportStatus = 'hash_mismatch'
        if ((Get-FileHash -LiteralPath $reportPath -Algorithm SHA256).Hash -eq $entry.reportSHA256) { $reportStatus = 'hash_match' }
    }
    $passed = $manifest.result -eq 'passed' -and $manifest.build -eq 'passed' -and
        $manifest.buildProfile -eq 'release' -and $manifest.failed -eq 0 -and
        $manifest.skipped -eq 0 -and $manifest.passed -gt 0 -and
        $entry.profile -eq $manifest.buildProfile -and $entry.passed -eq $manifest.passed -and
        $entry.failed -eq $manifest.failed -and $entry.skipped -eq $manifest.skipped -and
        $entry.releaseCommit -eq $manifest.releaseCommit
    $evidence.id = $entry.id
    $evidence.version = $manifest.addonVersion
    $evidence.releaseCommit = $entry.releaseCommit
    $evidence.reportGitCommit = $manifest.gitCommit
    $evidence.passed = $manifest.passed
    $evidence.report = $entry.report
    $evidence.reportStatus = $reportStatus
    $evidence.sourceStatus = 'match'
    if ($differences.Count) { $evidence.sourceStatus = 'mismatch' }
    $evidence.differences = @($differences.ToArray())
    $evidence.status = 'verified_recorded_scope'
    if (-not $passed) { $evidence.status = 'invalid_result' }
    elseif ($differences.Count) { $evidence.status = 'source_mismatch' }
    elseif ($reportStatus -ne 'hash_match') { $evidence.status = 'report_' + $reportStatus }
    $evidence.ciRun = $entry.ciRun
    $evidence.liveAcceptance = $entry.liveAcceptance
    if ($evidence.status -ne 'verified_recorded_scope') { $warnings.Add('Evidence requires review: '+$evidence.status) }
} catch {
    $evidence.status = 'invalid_or_missing_evidence'
    $warnings.Add($_.Exception.Message)
}
$result = [ordered]@{
    capturedAt = [DateTimeOffset]::Now.ToString('o')
    workingDirectory = (Get-Location).Path
    project = $root
    addonVersion = $config.package.version
    git = $git
    wowlua = $wowlua
    evidence = $evidence
    warnings = @($warnings.ToArray())
    constraints = @('Local read-only snapshot; no remote fetch/verification', 'No build, install, upload or game inspection', 'Hash agreement is not a new test run or live acceptance')
}
if ($AsJson) { $result | ConvertTo-Json -Depth 12 }
else { $result | ConvertTo-Json -Depth 12 }
if ($Strict -and ($warnings.Count -gt 0)) { exit 1 }
