param(
    [Parameter(Mandatory)][string]$Tag,
    [switch]$DryRun,
    [string]$OutputPath='reports/curseforge-dry-run'
)
$ErrorActionPreference='Stop'
. "$PSScriptRoot/Release.Common.ps1"
$root=(Resolve-Path (Split-Path $PSScriptRoot -Parent)).Path
$spec=Get-ReleaseSpec $root $Tag
if(-not $DryRun) { Assert-ReleaseApproved $spec }
if(git -C $root status --porcelain) { throw 'Commit the reviewed source and release texts first; never package a dirty tree' }
$commit=(git -C $root rev-parse HEAD).Trim()
if(-not $DryRun) {
    $tagCommit=git -C $root rev-parse --verify "$Tag^{commit}" 2>$null
    if($LASTEXITCODE -ne 0 -or $tagCommit -ne $commit) { throw 'Release must build the exact approved tag commit' }
    git -C $root merge-base --is-ancestor $spec.baseline.gitCommit $commit
    if($LASTEXITCODE) { throw 'Published baseline source must exist in this release history' }
}
$output=[IO.Path]::GetFullPath((Join-Path $root $OutputPath))
if(Test-Path -LiteralPath $output) { throw 'Use a new output directory for every run' }
New-Item -ItemType Directory -Path $output | Out-Null
$work=Join-Path $output 'source'
# A private clone gives dry runs an exact version without creating a release tag
# in the real repository, modifying source files or exposing a dirty build.
git clone --quiet --no-hardlinks --no-checkout $root $work
if($LASTEXITCODE) { throw 'Local source clone failed' }
git -C $work checkout --quiet --detach $commit
if($LASTEXITCODE) { throw 'Source checkout failed' }
if($DryRun) {
    git -C $work tag -f $Tag $commit | Out-Null
    if($LASTEXITCODE) { throw 'Isolated dry-run tag failed' }
}
$config=Read-Json (Join-Path $work 'wowlua.json')
$lockBefore=(Get-FileHash (Join-Path $work 'wowlua.lock')).Hash
$env:PATH=(Join-Path $env:USERPROFILE '.wowlua/bin')+[IO.Path]::PathSeparator+$env:PATH
$exe=(Get-Command wowlua -ErrorAction Stop).Source
if((& $exe --version | Out-String).Trim() -ne 'wowlua 0.13.14') { throw 'Use pinned wowlua 0.13.14' }
$pwsh=(Get-Command pwsh -ErrorAction Stop).Source
& $pwsh -NoProfile -File (Join-Path $work 'tools/Test-CraftDeja.ps1') -ProjectPath $work -Profile release -Evidence
if($LASTEXITCODE) { throw "Tests failed; automatic reports retained in $work/reports/tests" }
$reportDir=Get-ChildItem (Join-Path $work 'reports/tests') -Directory | Sort-Object Name | Select-Object -Last 1
$report=Read-Json (Join-Path $reportDir.FullName 'METADATEN.json')
Assert-RecordedInputs $report $work
if($lockBefore -ne (Get-FileHash (Join-Path $work 'wowlua.lock')).Hash) { throw 'Lockfile changed' }
$before=Get-Location
try { Set-Location $work; & $exe build --profile release --flavor camelot --locked --reproducible --color never; if($LASTEXITCODE) { throw 'Release build failed' } } finally { Set-Location $before }
Assert-RecordedInputs $report $work
$build=Join-Path $work 'dist/release/CraftDeja'
# WoWLua's LICENSES.txt covers declared dependencies, not imported data/artwork.
Copy-Item (Join-Path $work 'LICENSE'),(Join-Path $work 'DATA_SOURCES.md') $build
Copy-Item (Join-Path $work 'Licenses') $build -Recurse
Assert-ReleasePackage $build $work $spec.version
$artifact=Join-Path $output 'artifacts'
New-Item -ItemType Directory $artifact | Out-Null
$comparison=if($spec.historyReviewComplete){$spec.baseline.gitCommit}else{$spec.additionalComparison.gitCommit}
if($comparison) {
    git -C $work diff "$comparison..$commit" -- src wowlua.json | Set-Content (Join-Path $artifact 'reviewed-source-delta.diff') -Encoding utf8
    if($LASTEXITCODE) { throw 'Cannot produce baseline diff' }
    git -C $work log --format='%H %s' "$comparison..$commit" | Set-Content (Join-Path $artifact 'release-commits.txt') -Encoding utf8
    if($LASTEXITCODE) { throw 'Cannot produce release history' }
}
Add-Type -AssemblyName System.IO.Compression.FileSystem
$zipPath=Join-Path $artifact "CraftDeja-$($spec.version).zip"
$zip=[IO.Compression.ZipFile]::Open($zipPath,[IO.Compression.ZipArchiveMode]::Create)
$hashes=@{}
try { foreach($f in Get-ChildItem $build -Recurse -File) {
    $rel=$f.FullName.Substring($build.Length+1).Replace('\','/')
    [IO.Compression.ZipFileExtensions]::CreateEntryFromFile($zip,$f.FullName,('CraftDeja/'+$rel),[IO.Compression.CompressionLevel]::Optimal) | Out-Null
    $hashes[$rel]=(Get-FileHash $f.FullName).Hash
}} finally { $zip.Dispose() }
# Verify the actual ZIP, not just the directory used to create it.
$zip=[IO.Compression.ZipFile]::OpenRead($zipPath)
try { foreach($entry in $zip.Entries) {
    if(-not $entry.FullName.StartsWith('CraftDeja/') -or $entry.FullName.Contains('\') -or $entry.FullName.Contains('..')) { throw 'Unsafe ZIP layout' }
    $stream=$entry.Open();$sha=[Security.Cryptography.SHA256]::Create()
    try {$h=[BitConverter]::ToString($sha.ComputeHash($stream)).Replace('-','')} finally {$stream.Dispose();$sha.Dispose()}
    if($hashes[$entry.FullName.Substring(10)] -ne $h) { throw 'ZIP integrity mismatch' }
}} finally {$zip.Dispose()}
foreach($name in 'description.md','patchnotes.md','release.json','REVIEW.md') { Copy-Item (Join-Path $work "releases/$($spec.version)/$name") $artifact }
Copy-Item ($reportDir.FullName+'.zip') (Join-Path $artifact 'TEST-REPORT.zip')
$metadata=[ordered]@{
    displayName="CraftDeja $($spec.version)";releaseType=$spec.channel;changelogType='markdown'
    changelog=(Get-Content (Join-Path $artifact 'patchnotes.md') -Raw)
    gameVersionNames=@($spec.gameVersion)
}
Write-Json $metadata (Join-Path $artifact 'upload-metadata.preview.json')
$receipt=[ordered]@{
    projectId=1796977;tag=$Tag;commit=$commit;dryRun=[bool]$DryRun;version=$spec.version
    channel=$spec.channel;zip=[IO.Path]::GetFileName($zipPath);zipSHA256=(Get-FileHash $zipPath).Hash
    payloadHashes=$hashes;descriptionSHA256=(Get-FileHash (Join-Path $artifact 'description.md')).Hash
    patchnotesSHA256=(Get-FileHash (Join-Path $artifact 'patchnotes.md')).Hash
    passed=$report.passed;failed=$report.failed;skipped=$report.skipped
    gameVersion=$spec.gameVersion;gameVersionTypeId=$spec.gameVersionTypeId
    gameVersionId=$null;gameVersionStatus='requires authenticated official versions API lookup before upload'
    historyReviewComplete=$spec.historyReviewComplete;approved=$spec.approved
    fileId=$null;uploadStatus='not_requested';descriptionStatus='manual_author_console_required'
}
Write-Json $receipt (Join-Path $artifact 'release-evidence.json')
if($env:GITHUB_STEP_SUMMARY) {
    "## CraftDeja release preparation`nTag: $Tag`nCommit: $commit`nDry run: $([bool]$DryRun)`nTests: $($report.passed) passed / $($report.failed) failed / $($report.skipped) skipped`nPackage SHA256: $($receipt.zipSHA256)`nApproval: $($spec.approved); same-channel history reviewed: $($spec.historyReviewComplete)`nForever ID lookup: pending authenticated official API. Description: manual_author_console_required. No upload in dry-run mode." >> $env:GITHUB_STEP_SUMMARY
}
Write-Host "DRY RUN / RELEASE ARTIFACTS: $artifact"
if($env:GITHUB_OUTPUT) { "artifact_path=$artifact" >> $env:GITHUB_OUTPUT }
