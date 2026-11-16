$ErrorActionPreference = 'Stop'
function Read-Json([string]$Path) { Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json }
function Write-Json($Value,[string]$Path) { $Value | ConvertTo-Json -Depth 30 | Set-Content -LiteralPath $Path -Encoding utf8 }
function Get-ReleaseChannel([string]$Tag) {
    if ($Tag -cmatch '^v(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)-beta\.([1-9]\d*)$') { return 'beta' }
    if ($Tag -cmatch '^v(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)$') { return 'release' }
    throw "Unsupported release tag: $Tag"
}
function Get-ReleaseSpec([string]$Root,[string]$Tag) {
    $channel=Get-ReleaseChannel $Tag
    $version=$Tag.Substring(1)
    $config=Read-Json (Join-Path $Root 'wowlua.json')
    if ($config.package.version -cne $version) { throw 'Tag differs from wowlua package.version' }
    $start=Get-Content -LiteralPath (Join-Path $Root 'src/Start.lua') -Raw
    if($start -notmatch ('app\.release="'+[regex]::Escape($version)+'"')) { throw 'Addon runtime version differs from tag' }
    $dir=Join-Path $Root "releases/$version"
    $spec=Read-Json (Join-Path $dir 'release.json')
    if ($spec.version -cne $version -or $spec.channel -cne $channel -or $spec.projectId -ne 1796977) { throw 'Release approval metadata mismatch' }
    foreach($name in 'description.md','patchnotes.md','REVIEW.md') {
        $text=Get-Content -LiteralPath (Join-Path $dir $name) -Raw
        if ([string]::IsNullOrWhiteSpace($text)) { throw "Missing release text: $name" }
        if ($name -ne 'REVIEW.md' -and ($text -notmatch 'Deutsch' -or $text -notmatch 'English')) { throw "DE/EN required: $name" }
    }
    return $spec
}
function Assert-ReleaseApproved($Spec) {
    if ($Spec.approved -ne $true -or $Spec.historyReviewComplete -ne $true) { throw 'Release history/approval incomplete. Review releases/<version>/REVIEW.md before tagging.' }
    $baseline=$Spec.baseline
    if ($baseline.channel -cne $Spec.channel -or $baseline.fileId -le 0 -or $baseline.gitCommit -notmatch '^[a-f0-9]{40}$') { throw 'Verified same-channel CurseForge baseline (file ID and source commit) required' }
}
function Resolve-ForeverVersion($Versions,$Spec) {
    $found=@($Versions | Where-Object { $_.name -ceq $Spec.gameVersion -and $_.gameVersionTypeID -eq $Spec.gameVersionTypeId })
    if($found.Count -ne 1 -or $found[0].id -le 0) { throw 'Forever game version must resolve uniquely; refusing another WoW flavor' }
    return [int]$found[0].id
}
function Assert-ReleasePackage([string]$Build,[string]$Source,[string]$Version) {
    $toc=Get-Content -LiteralPath (Join-Path $Build 'CraftDeja.toc') -Raw
    if($toc -notmatch ('(?m)^## Version: '+[regex]::Escape($Version)+'\r?$')) { throw 'Built TOC version differs from tag (alpha/dev/dirty builds cannot publish)' }
    if($toc -notmatch '(?m)^## Interface: 16001\r?$' -or $toc -notmatch '(?m)^## X-Wowlua-Build: release ') { throw 'Expected Forever 16001 release profile' }
    $lua=Get-Content -LiteralPath (Join-Path $Build 'CraftDeja.lua') -Raw
    if($lua -match '__wl\.(prof|mon|perf)' -or $lua -match 'wowlua[_/-]runtime') { throw 'Development runtime/instrumentation in player payload' }
    $expected=@('CraftDeja.toc','CraftDeja.lua','LICENSES.txt')
    foreach($asset in Get-ChildItem -LiteralPath (Join-Path $Source 'Art') -File -Recurse) {
        $rel=$asset.FullName.Substring($Source.Length+1).Replace('\','/')
        $expected+=$rel
        if((Get-FileHash -LiteralPath $asset.FullName).Hash -ne (Get-FileHash -LiteralPath (Join-Path $Build $rel)).Hash) { throw "Missing/changed asset: $rel" }
    }
    foreach($line in ($toc -split '\r?\n')) {
        if($line.Trim() -and -not $line.StartsWith('#') -and -not (Test-Path -LiteralPath (Join-Path $Build $line.Trim()))) { throw "Missing TOC runtime: $line" }
    }
    if([string]::IsNullOrWhiteSpace((Get-Content -LiteralPath (Join-Path $Build 'LICENSES.txt') -Raw))) { throw 'Generated component licenses missing' }
    foreach($license in @((Join-Path $Source 'LICENSE'),(Join-Path $Source 'DATA_SOURCES.md'))+@(Get-ChildItem (Join-Path $Source 'Licenses') -File | ForEach-Object FullName)) {
        $rel=$license.Substring($Source.Length+1).Replace('\','/')
        $expected+=$rel
        if((Get-FileHash -LiteralPath $license).Hash -ne (Get-FileHash -LiteralPath (Join-Path $Build $rel)).Hash) { throw "License/provenance missing from payload: $license" }
    }
    $actual=@(Get-ChildItem -LiteralPath $Build -File -Recurse | ForEach-Object { $_.FullName.Substring($Build.Length+1).Replace('\','/') })
    if(@(Compare-Object ($expected|Sort-Object) ($actual|Sort-Object)).Count) { throw 'Unexpected or missing files in release payload' }
}
function Assert-RecordedInputs($Report,[string]$Root) {
    if($Report.result -ne 'passed' -or $Report.build -ne 'passed' -or $Report.passed -le 0 -or $Report.failed -ne 0 -or $Report.skipped -ne 0 -or @($Report.filters).Count -ne 0 -or $Report.buildProfile -ne 'release') { throw 'Full release test suite must pass without skips' }
    foreach($p in $Report.sourceHashes.PSObject.Properties) {
        if((Get-FileHash -LiteralPath (Join-Path $Root ('src/'+$p.Name+'.lua'))).Hash -ne $p.Value) { throw "Source changed after tests: $($p.Name)" }
    }
    foreach($set in 'testHashes','inputHashes') { foreach($p in $Report.$set.PSObject.Properties) {
        if((Get-FileHash -LiteralPath (Join-Path $Root $p.Name)).Hash -ne $p.Value) { throw "Input changed after tests: $($p.Name)" }
    }}
}
