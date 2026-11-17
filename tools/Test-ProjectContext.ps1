# Isolated developer checks for the read-only context utility; not an addon test run.
$ErrorActionPreference = 'Stop'
$project = Split-Path -Parent $PSScriptRoot
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$folder = Join-Path $project ('reports/context/' + $stamp + '-' + [guid]::NewGuid().ToString('N').Substring(0,6))
New-Item -ItemType Directory -Path $folder -Force | Out-Null
$fixture = Join-Path $folder 'fixture'
$tool = Join-Path $PSScriptRoot 'Get-ProjectContext.ps1'
$rows = New-Object 'System.Collections.Generic.List[object]'
$utf8 = New-Object Text.UTF8Encoding($false)
function Write-Fixture([string]$Relative,[string]$Content) {
    $file = Join-Path $fixture $Relative
    New-Item -ItemType Directory -Path (Split-Path -Parent $file) -Force | Out-Null
    [IO.File]::WriteAllText($file,$Content,$utf8)
}
function Invoke-Context([string]$Root) {
    $out = & powershell -NoProfile -ExecutionPolicy Bypass -File $tool -ProjectPath $Root -AsJson -Strict 2>&1
    $code = $LASTEXITCODE
    $text = $out -join "`n"
    return [pscustomobject]@{code=$code;data=($text | ConvertFrom-Json)}
}
function Case([string]$Name,[scriptblock]$Check) {
    try { & $Check; $rows.Add([pscustomobject]@{name=$Name;result='passed'}) }
    catch { $rows.Add([pscustomobject]@{name=$Name;result='failed';error=$_.Exception.Message}) }
}
function Assert($Condition,[string]$Message) { if (-not $Condition) { throw $Message } }
$exitCode = 1
Start-Transcript -LiteralPath (Join-Path $folder 'PROTOKOLL.txt') | Out-Null
try {
    Case 'PowerShell parser' {
        foreach ($file in @($tool,$PSCommandPath)) {
            $tokens=$null; $errors=$null
            [void][Management.Automation.Language.Parser]::ParseFile($file,[ref]$tokens,[ref]$errors)
            Assert ($errors.Count -eq 0) ($errors | Out-String)
        }
    }
    Write-Fixture 'wowlua.json' '{"package":{"version":"fixture.1"}}'
    Write-Fixture 'wowlua.lock' '{}'
    Write-Fixture 'tools/Test-CraftDeja.ps1' '# fixture; never executed'
    Write-Fixture 'src/Start.lua' '-- fixture'
    Write-Fixture 'tests/check.test.wowlua' '// fixture'
    Write-Fixture 'reports/check.zip' 'fixture ZIP bytes; hash only, not a real test report'
    $manifest = [ordered]@{
        addonVersion='fixture.1';gitCommit=('a'*40);releaseCommit=('b'*40)
        sourceHashes=@{Start=(Get-FileHash (Join-Path $fixture 'src/Start.lua')).Hash}
        testHashes=@{'tests/check.test.wowlua'=(Get-FileHash (Join-Path $fixture 'tests/check.test.wowlua')).Hash}
        inputHashes=@{}
        buildProfile='release';build='passed';result='passed';passed=1;failed=0;skipped=0
    }
    foreach ($p in @('wowlua.json','wowlua.lock','tools/Test-CraftDeja.ps1')) {
        $manifest.inputHashes[$p]=(Get-FileHash (Join-Path $fixture $p)).Hash
    }
    Write-Fixture 'docs/evidence/manifest.json' ($manifest | ConvertTo-Json -Depth 8)
    $index = @{schemaVersion=1;current='fixture';entries=@(@{id='fixture';version='fixture.1';releaseCommit=('b'*40);manifest='docs/evidence/manifest.json';report='reports/check.zip';reportSHA256=(Get-FileHash (Join-Path $fixture 'reports/check.zip')).Hash;profile='release';passed=1;failed=0;skipped=0;liveAcceptance='pending'})}
    Write-Fixture 'docs/evidence/index.json' ($index | ConvertTo-Json -Depth 8)
    & git -C $fixture init --quiet
    & git -C $fixture -c user.name=Fixture -c user.email=fixture@example.invalid commit --quiet --allow-empty -m fixture
    if ($LASTEXITCODE -ne 0) { throw 'Cannot prepare fixture Git repository' }
    Case 'Complete matching fixture' {
        $r=Invoke-Context $fixture
        Assert ($r.code -eq 0 -and $r.data.evidence.status -eq 'verified_recorded_scope') 'Expected matching evidence'
        Assert ($r.data.git.changes.Count -gt 0) 'Dirty files must remain visible and allowed'
    }
    Case 'Changed source' {
        Write-Fixture 'src/Start.lua' '-- changed'
        $r=Invoke-Context $fixture
        Assert ($r.code -eq 1 -and $r.data.evidence.sourceStatus -eq 'mismatch') 'Changed source not rejected'
        Write-Fixture 'src/Start.lua' '-- fixture'
    }
    Case 'New source' {
        Write-Fixture 'src/Added.lua' '-- new'
        $r=Invoke-Context $fixture
        Assert ($r.code -eq 1 -and $r.data.evidence.differences -contains 'Not recorded: src/Added.lua') 'New source not rejected'
        # Keep the fixture artifact; move outside the scanned runtime directory.
        Move-Item -LiteralPath (Join-Path $fixture 'src/Added.lua') -Destination (Join-Path $fixture 'Added.saved')
    }
    Case 'Missing source' {
        Move-Item -LiteralPath (Join-Path $fixture 'src/Start.lua') -Destination (Join-Path $fixture 'Start.saved')
        $r=Invoke-Context $fixture
        Assert ($r.code -eq 1 -and $r.data.evidence.differences -contains 'Missing: src/Start.lua') 'Missing source not rejected'
        Move-Item -LiteralPath (Join-Path $fixture 'Start.saved') -Destination (Join-Path $fixture 'src/Start.lua')
    }
    Case 'Changed test' {
        Write-Fixture 'tests/check.test.wowlua' '// changed'
        $r=Invoke-Context $fixture
        Assert ($r.code -eq 1 -and $r.data.evidence.sourceStatus -eq 'mismatch') 'Changed test not rejected'
        Write-Fixture 'tests/check.test.wowlua' '// fixture'
    }
    Case 'New test' {
        Write-Fixture 'tests/new.test.wowlua' '// new'
        $r=Invoke-Context $fixture
        Assert ($r.code -eq 1 -and $r.data.evidence.differences -contains 'Not recorded: tests/new.test.wowlua') 'New test not rejected'
        Move-Item -LiteralPath (Join-Path $fixture 'tests/new.test.wowlua') -Destination (Join-Path $fixture 'test.saved')
    }
    Case 'Missing local report with matching source' {
        Move-Item -LiteralPath (Join-Path $fixture 'reports/check.zip') -Destination (Join-Path $fixture 'report.saved')
        $r=Invoke-Context $fixture
        Assert ($r.code -eq 1 -and $r.data.evidence.status -eq 'report_missing' -and $r.data.evidence.sourceStatus -eq 'match') 'Missing report confused with source mismatch'
        Move-Item -LiteralPath (Join-Path $fixture 'report.saved') -Destination (Join-Path $fixture 'reports/check.zip')
    }
    Case 'Incorrect report checksum' {
        Write-Fixture 'reports/check.zip' 'changed'
        $r=Invoke-Context $fixture
        Assert ($r.code -eq 1 -and $r.data.evidence.status -eq 'report_hash_mismatch') 'Bad ZIP hash not rejected'
        Write-Fixture 'reports/check.zip' 'fixture ZIP bytes; hash only, not a real test report'
    }
    Case 'Addon version changed' {
        Write-Fixture 'wowlua.json' '{"package":{"version":"fixture.2"}}'
        $r=Invoke-Context $fixture
        Assert ($r.code -eq 1 -and $r.data.evidence.status -eq 'source_mismatch') 'Version mismatch not rejected'
        Write-Fixture 'wowlua.json' '{"package":{"version":"fixture.1"}}'
    }
    Case 'Manifest cannot escape checkout' {
        $index.entries[0].manifest='../escape.json'
        Write-Fixture 'docs/evidence/index.json' ($index | ConvertTo-Json -Depth 8)
        $r=Invoke-Context $fixture
        Assert ($r.code -eq 1 -and $r.data.evidence.status -eq 'invalid_or_missing_evidence') 'Escaping manifest path not rejected'
        $index.entries[0].manifest='docs/evidence/manifest.json'
        Write-Fixture 'docs/evidence/index.json' ($index | ConvertTo-Json -Depth 8)
    }
    Case 'Missing mandatory build input cannot pass' {
        $saved = $manifest.inputHashes['wowlua.lock']
        $manifest.inputHashes.Remove('wowlua.lock')
        Write-Fixture 'docs/evidence/manifest.json' ($manifest | ConvertTo-Json -Depth 8)
        $r=Invoke-Context $fixture
        Assert ($r.code -eq 1 -and $r.data.evidence.differences -contains 'Input not recorded: wowlua.lock') 'Partial input manifest accepted'
        $manifest.inputHashes['wowlua.lock']=$saved
        Write-Fixture 'docs/evidence/manifest.json' ($manifest | ConvertTo-Json -Depth 8)
    }
    Case 'Skipped tests cannot be a complete release proof' {
        $manifest.skipped=1
        Write-Fixture 'docs/evidence/manifest.json' ($manifest | ConvertTo-Json -Depth 8)
        $r=Invoke-Context $fixture
        Assert ($r.code -eq 1 -and $r.data.evidence.status -eq 'invalid_result') 'Skipped tests accepted'
        $manifest.skipped=0
        Write-Fixture 'docs/evidence/manifest.json' ($manifest | ConvertTo-Json -Depth 8)
    }
    Case 'Contradictory index count cannot pass' {
        $index.entries[0].passed=2
        Write-Fixture 'docs/evidence/index.json' ($index | ConvertTo-Json -Depth 8)
        $r=Invoke-Context $fixture
        Assert ($r.code -eq 1 -and $r.data.evidence.status -eq 'invalid_result') 'Contradictory count accepted'
        $index.entries[0].passed=1
        Write-Fixture 'docs/evidence/index.json' ($index | ConvertTo-Json -Depth 8)
    }
    Case 'Duplicate current evidence ID cannot pass' {
        $index.entries += $index.entries[0]
        Write-Fixture 'docs/evidence/index.json' ($index | ConvertTo-Json -Depth 8)
        $r=Invoke-Context $fixture
        Assert ($r.code -eq 1 -and $r.data.evidence.status -eq 'invalid_or_missing_evidence') 'Duplicate ID accepted'
        $index.entries=@($index.entries[0])
        Write-Fixture 'docs/evidence/index.json' ($index | ConvertTo-Json -Depth 8)
    }
    Case 'Remote credentials redacted without network' {
        & git -C $fixture remote add origin 'https://fixture-secret@example.invalid/test/repo.git?token=fixture-secret'
        if ($LASTEXITCODE -ne 0) { throw 'Cannot create local remote fixture' }
        $r=Invoke-Context $fixture
        $json=$r.data | ConvertTo-Json -Depth 12
        Assert (-not $json.Contains('fixture-secret')) 'Remote credentials leaked'
        Assert ($r.data.git.remoteVerified -eq $false) 'False remote verification claim'
    }
    Case 'Read-only real project snapshot and original test hashes' {
        $before = (& git -C $project status --porcelain=v1 --untracked-files=all) -join "`n"
        $r=Invoke-Context $project
        $after = (& git -C $project status --porcelain=v1 --untracked-files=all) -join "`n"
        Assert ($before -eq $after) 'Context check changed worktree'
        Assert ($r.code -eq 0 -and $r.data.evidence.status -eq 'verified_recorded_scope') 'Real project original evidence no longer matches'
        [IO.File]::WriteAllText((Join-Path $folder 'PROJECT-SNAPSHOT.json'),($r.data | ConvertTo-Json -Depth 12),$utf8)
    }
    $exitCode = 0
    if (@($rows | Where-Object result -eq 'failed').Count) { $exitCode=1 }
} catch {
    $rows.Add([pscustomobject]@{name='Harness';result='failed';error=$_.Exception.Message})
} finally {
    $rows | Format-Table -AutoSize | Out-Host
    $summary = [ordered]@{capturedAt=[DateTimeOffset]::Now.ToString('o');scope='Isolated developer utility checks; no addon tests/build/install/upload';utilitySHA256=(Get-FileHash $tool).Hash;harnessSHA256=(Get-FileHash $PSCommandPath).Hash;passed=@($rows | Where-Object result -eq 'passed').Count;failed=@($rows | Where-Object result -eq 'failed').Count;checks=@($rows.ToArray())}
    [IO.File]::WriteAllText((Join-Path $folder 'RESULTS.json'),($summary | ConvertTo-Json -Depth 8),$utf8)
    Stop-Transcript | Out-Null
    # Share only results/log/snapshot, never fixture .git or unrelated files.
    $items=@((Join-Path $folder 'PROTOKOLL.txt'),(Join-Path $folder 'RESULTS.json'))
    if (Test-Path (Join-Path $folder 'PROJECT-SNAPSHOT.json')) { $items += (Join-Path $folder 'PROJECT-SNAPSHOT.json') }
    Compress-Archive -LiteralPath $items -DestinationPath ($folder+'.zip')
    Write-Host ('Developer report: '+$folder+'.zip')
}
exit $exitCode
