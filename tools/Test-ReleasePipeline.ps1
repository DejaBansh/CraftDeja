$ErrorActionPreference='Stop'
. "$PSScriptRoot/Release.Common.ps1"
$root=(Resolve-Path (Split-Path $PSScriptRoot -Parent)).Path
$dir=Join-Path $root ('reports/release-pipeline-'+[guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory "$dir/source/Art","$dir/source/Licenses","$dir/build/Art","$dir/build/Licenses","$dir/artifact" -Force|Out-Null
$results=[Collections.Generic.List[object]]::new()
function Check([string]$Name,[scriptblock]$Body) {
    try { & $Body; $results.Add(@{name=$Name;passed=$true});Write-Host "PASS $Name" }
    catch { $results.Add(@{name=$Name;passed=$false;error=$_.Exception.Message});Write-Host "FAIL $Name : $_" }
}
function Reject([scriptblock]$Body) { $rejected=$false;try{& $Body|Out-Null}catch{$rejected=$true};if(-not $rejected){throw 'Expected rejection'} }
Check 'beta tag maps to beta' {if((Get-ReleaseChannel 'v3.9.0-beta.19') -ne 'beta'){throw 'channel'}}
Check 'stable tag maps to release' {if((Get-ReleaseChannel 'v3.9.0') -ne 'release'){throw 'channel'}}
foreach($bad in 'v3.9.0-alpha.1','3.9.0','v3.9','v03.9.0','v3.9.0-beta.0','v3.9.0-beta.19+abc','v3.9.0/evil') {
    $value=$bad;Check "reject tag $bad" {Reject {Get-ReleaseChannel $value}}
}
$spec=Read-Json "$root/releases/3.9.0-beta.23/release.json"
Check 'unreviewed history blocks real upload' {Reject {Assert-ReleaseApproved $spec}}
Check 'tag and manifest mismatch rejected' {Reject {Get-ReleaseSpec $root 'v3.9.0-beta.22'}}
Check 'exact Forever version selected from multiple flavors' {
    $v=@(@{id=10;name='1.60.1';gameVersionTypeID=1},@{id=20;name='1.60.1';gameVersionTypeID=88568})
    if((Resolve-ForeverVersion $v $spec) -ne 20){throw 'wrong flavor'}
}
Check 'unknown Forever mapping rejected' {Reject {Resolve-ForeverVersion @() $spec}}
Check 'ambiguous Forever mapping rejected' {Reject {Resolve-ForeverVersion @(@{id=20;name='1.60.1';gameVersionTypeID=88568},@{id=21;name='1.60.1';gameVersionTypeID=88568}) $spec}}
'asset'|Set-Content "$dir/source/Art/Logo.tga";Copy-Item "$dir/source/Art/Logo.tga" "$dir/build/Art/Logo.tga"
'MIT sample'|Set-Content "$dir/source/LICENSE";'Third-party sample'|Set-Content "$dir/source/Licenses/Third.txt"
'Provenance'|Set-Content "$dir/source/DATA_SOURCES.md"
Copy-Item "$dir/source/LICENSE","$dir/source/DATA_SOURCES.md" "$dir/build"
Copy-Item "$dir/source/Licenses/Third.txt" "$dir/build/Licenses"
"MIT sample`nThird-party sample"|Set-Content "$dir/build/LICENSES.txt"
'return {}'|Set-Content "$dir/build/CraftDeja.lua"
$toc="## Interface: 16001`n## Version: 3.9.0-beta.23`n## X-Wowlua-Build: release test`nCraftDeja.lua`n"
$toc|Set-Content "$dir/build/CraftDeja.toc"
Check 'complete tagged player payload accepted' {Assert-ReleasePackage "$dir/build" "$dir/source" '3.9.0-beta.23'}
Check 'dirty/alpha TOC version rejected' {
    try {$toc.Replace('beta.23','beta.23-alpha+1234567')|Set-Content "$dir/build/CraftDeja.toc";Reject {Assert-ReleasePackage "$dir/build" "$dir/source" '3.9.0-beta.23'}}finally{$toc|Set-Content "$dir/build/CraftDeja.toc"}
}
Check 'wrong interface rejected' {
    try {$toc.Replace('16001','120000')|Set-Content "$dir/build/CraftDeja.toc";Reject {Assert-ReleasePackage "$dir/build" "$dir/source" '3.9.0-beta.23'}}finally{$toc|Set-Content "$dir/build/CraftDeja.toc"}
}
Check 'instrumentation rejected' {
    try {'__wl.prof()'|Set-Content "$dir/build/CraftDeja.lua";Reject {Assert-ReleasePackage "$dir/build" "$dir/source" '3.9.0-beta.23'}}finally{'return {}'|Set-Content "$dir/build/CraftDeja.lua"}
}
Check 'changed texture rejected' {
    try {'wrong'|Set-Content "$dir/build/Art/Logo.tga";Reject {Assert-ReleasePackage "$dir/build" "$dir/source" '3.9.0-beta.23'}}finally{Copy-Item "$dir/source/Art/Logo.tga" "$dir/build/Art/Logo.tga" -Force}
}
Check 'missing license rejected' {
    try {'wrong license'|Set-Content "$dir/build/Licenses/Third.txt";Reject {Assert-ReleasePackage "$dir/build" "$dir/source" '3.9.0-beta.23'}}finally{Copy-Item "$dir/source/Licenses/Third.txt" "$dir/build/Licenses/Third.txt" -Force}
}
Check 'unknown runtime in TOC rejected' {
    try {($toc+'Missing.lua')|Set-Content "$dir/build/CraftDeja.toc";Reject {Assert-ReleasePackage "$dir/build" "$dir/source" '3.9.0-beta.23'}}finally{$toc|Set-Content "$dir/build/CraftDeja.toc"}
}
# Mock only the external API, exercise the production uploader and real receipt.
$a="$dir/artifact";'zip fixture'|Set-Content "$a/player.zip";'Deutsch English notes'|Set-Content "$a/patchnotes.md";'Deutsch English description'|Set-Content "$a/description.md"
$spec.approved=$true;$spec.historyReviewComplete=$true;$spec.baseline.fileId=123;$spec.baseline.gitCommit='a'*40
Write-Json $spec "$a/release.json"
$e=@{commit=$env:GITHUB_SHA;projectId=1796977;version=$spec.version;tag='v3.9.0-beta.23';channel='beta';dryRun=$false;fileId=$null;uploadStatus='not_requested';descriptionStatus='manual_author_console_required';zip='player.zip';zipSHA256=(Get-FileHash "$a/player.zip").Hash;descriptionSHA256=(Get-FileHash "$a/description.md").Hash;patchnotesSHA256=(Get-FileHash "$a/patchnotes.md").Hash;gameVersionId=$null;gameVersionStatus='unresolved'}
Write-Json @{releaseType='beta';changelogType='markdown';changelog=(Get-Content "$a/patchnotes.md" -Raw);gameVersionNames=@('1.60.1')} "$a/upload-metadata.preview.json"
$oldToken=$env:CF_API_TOKEN;$oldAttempt=$env:GITHUB_RUN_ATTEMPT;$oldSummary=$env:GITHUB_STEP_SUMMARY;$oldOutput=$env:GITHUB_OUTPUT
$env:CF_API_TOKEN='synthetic-test-token';$env:GITHUB_RUN_ATTEMPT='1';$env:GITHUB_STEP_SUMMARY='';$env:GITHUB_OUTPUT=''
$global:craftDejaApiMock=@{posts=0;postFails=$false}
function Invoke-RestMethod {
    param($Method,$Uri,$Headers,$TimeoutSec,$Form)
    if($Method -eq 'Post') {
        if($Uri -cne 'https://wow.curseforge.com/api/projects/1796977/upload-file'){throw 'wrong destination'}
        $m=$Form.metadata|ConvertFrom-Json
        if($m.gameVersions[0] -ne 1234 -or $m.releaseType -ne 'beta' -or $m.changelogType -ne 'markdown'){throw 'wrong metadata'}
        $global:craftDejaApiMock.posts++;if($global:craftDejaApiMock.postFails){throw 'Synthetic lost response'};return @{id=4567}
    }
    if($Uri -cne 'https://wow.curseforge.com/api/game/versions'){throw 'unexpected API endpoint'}
    return @(@{id=1234;name='1.60.1';gameVersionTypeID=88568})
}
try {
    Check 'successful upload returns file ID separately from manual description' {
        Write-Json $e "$a/release-evidence.json";& "$PSScriptRoot/Publish-CurseForgeRelease.ps1" -ArtifactPath $a
        $r=Read-Json "$a/release-evidence.json";if($r.fileId -ne 4567 -or $r.descriptionStatus -ne 'manual_author_console_required' -or $global:craftDejaApiMock.posts -ne 1){throw 'receipt'}
    }
    Check 'repeat upload rejected without another POST' {Reject {& "$PSScriptRoot/Publish-CurseForgeRelease.ps1" -ArtifactPath $a};if($global:craftDejaApiMock.posts -ne 1){throw 'duplicate'}}
    Check 'dry-run evidence never uploads' {$e.dryRun=$true;Write-Json $e "$a/release-evidence.json";Reject {& "$PSScriptRoot/Publish-CurseForgeRelease.ps1" -ArtifactPath $a};$e.dryRun=$false;if($global:craftDejaApiMock.posts -ne 1){throw 'dry run posted'}}
    Check 're-run job blocked before POST' {Write-Json $e "$a/release-evidence.json";$env:GITHUB_RUN_ATTEMPT='2';Reject {& "$PSScriptRoot/Publish-CurseForgeRelease.ps1" -ArtifactPath $a};$env:GITHUB_RUN_ATTEMPT='1';if($global:craftDejaApiMock.posts -ne 1){throw 'rerun posted'}}
    Check 'lost upload response retains uncertain state without retry' {
        Write-Json $e "$a/release-evidence.json";$global:craftDejaApiMock.postFails=$true;Reject {& "$PSScriptRoot/Publish-CurseForgeRelease.ps1" -ArtifactPath $a}
        if((Read-Json "$a/release-evidence.json").uploadStatus -ne 'attempt_started_result_uncertain' -or $global:craftDejaApiMock.posts -ne 2){throw 'uncertain receipt'}
        Reject {& "$PSScriptRoot/Publish-CurseForgeRelease.ps1" -ArtifactPath $a};if($global:craftDejaApiMock.posts -ne 2){throw 'retried'}
    }
}finally{$env:CF_API_TOKEN=$oldToken;$env:GITHUB_RUN_ATTEMPT=$oldAttempt;$env:GITHUB_STEP_SUMMARY=$oldSummary;$env:GITHUB_OUTPUT=$oldOutput}
Write-Json @($results) "$root/reports/release-pipeline-tests.json"
Write-Host "Release pipeline checks: $(@($results|Where-Object passed).Count) passed, $(@($results|Where-Object {-not $_.passed}).Count) failed. External API calls were mocked; no upload."
if(@($results|Where-Object {-not $_.passed}).Count){throw 'Release pipeline regression failed'}
