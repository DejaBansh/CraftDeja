param([Parameter(Mandatory)][string]$ArtifactPath)
$ErrorActionPreference='Stop'
. "$PSScriptRoot/Release.Common.ps1"
$artifact=(Resolve-Path $ArtifactPath).Path
$e=Read-Json (Join-Path $artifact 'release-evidence.json')
$spec=Read-Json (Join-Path $artifact 'release.json')
Assert-ReleaseApproved $spec
if($e.dryRun -or $e.projectId -ne 1796977 -or $e.version -cne $spec.version -or (Get-ReleaseChannel $e.tag) -cne $spec.channel) { throw 'Cannot upload dry-run or mismatched release evidence' }
if($env:GITHUB_SHA -and $e.commit -cne $env:GITHUB_SHA) { throw 'Artifact is not from this tag commit' }
if($e.fileId -or $e.uploadStatus -ne 'not_requested') { throw 'Previous upload/uncertain result: do not repeat. Use description-only mode or reconcile the file ID in Author Console.' }
if($env:GITHUB_RUN_ATTEMPT -and [int]$env:GITHUB_RUN_ATTEMPT -gt 1) { throw 'Re-running a publish job could duplicate a file. Use description-only mode; reconcile uncertain uploads manually.' }
if(-not $env:CF_API_TOKEN) { throw 'Missing CF_API_TOKEN repository Actions secret' }
foreach($pair in @(@($e.zip,$e.zipSHA256),@('description.md',$e.descriptionSHA256),@('patchnotes.md',$e.patchnotesSHA256))) {
    if((Get-FileHash (Join-Path $artifact $pair[0])).Hash -ne $pair[1]) { throw 'Approved artifact changed' }
}
$headers=@{'X-Api-Token'=$env:CF_API_TOKEN}
# Token remains in a header, never in a URL, command-line argument or artifact.
$versions=Invoke-RestMethod -Uri 'https://wow.curseforge.com/api/game/versions' -Headers $headers -TimeoutSec 60
$id=Resolve-ForeverVersion $versions $spec
$metadata=Read-Json (Join-Path $artifact 'upload-metadata.preview.json')
$metadata.PSObject.Properties.Remove('gameVersionNames')
$metadata|Add-Member -NotePropertyName gameVersions -NotePropertyValue @($id)
if($metadata.releaseType -cne $e.channel -or $metadata.changelog -cne (Get-Content (Join-Path $artifact 'patchnotes.md') -Raw) -or $metadata.changelogType -cne 'markdown') { throw 'Upload metadata changed' }
Write-Json $metadata (Join-Path $artifact 'upload-metadata.resolved.json')
$e.gameVersionId=$id;$e.gameVersionStatus='authenticated official API: unique Forever match'
$e.uploadStatus='attempt_started_result_uncertain'
Write-Json $e (Join-Path $artifact 'release-evidence.json')
# Deliberately no automatic POST retry: a lost response can already have created a file.
try {
    $response=Invoke-RestMethod -Method Post -Uri 'https://wow.curseforge.com/api/projects/1796977/upload-file' -Headers $headers -Form @{
        metadata=($metadata|ConvertTo-Json -Depth 10 -Compress)
        file=(Get-Item (Join-Path $artifact $e.zip))
    } -TimeoutSec 300
    if($response.id -le 0) { throw 'Upload returned no valid CurseForge file ID' }
    $e.fileId=[long]$response.id;$e.uploadStatus='accepted_moderation_pending'
    Write-Host "CurseForge file ID: $($e.fileId)"
    if($env:GITHUB_OUTPUT) { "file_id=$($e.fileId)" >> $env:GITHUB_OUTPUT }
} finally {
    Write-Json $e (Join-Path $artifact 'release-evidence.json')
    if($env:GITHUB_STEP_SUMMARY) {
        "## CurseForge file upload`nFile ID: $($e.fileId)`nStatus: $($e.uploadStatus)`n`n## Project description`nStatus: $($e.descriptionStatus). Official Author Console edit required; no documented description-write API. Do not re-upload the file." >> $env:GITHUB_STEP_SUMMARY
    }
}
