param([Parameter(Mandatory)][string]$Tag,[Parameter(Mandatory)][string]$OutputPath)
$ErrorActionPreference='Stop'
. "$PSScriptRoot/Release.Common.ps1"
$root=(Resolve-Path (Split-Path $PSScriptRoot -Parent)).Path
$spec=Get-ReleaseSpec $root $Tag
$tagCommit=git -C $root rev-parse --verify "$Tag^{commit}" 2>$null
if($LASTEXITCODE -or $tagCommit -ne (git -C $root rev-parse HEAD)) { throw 'Description-only mode must check out the original release tag' }
New-Item -ItemType Directory -Path $OutputPath -Force|Out-Null
Copy-Item "$root/releases/$($spec.version)/description.md" $OutputPath
$status=@{projectId=1796977;tag=$Tag;commit=$tagCommit;status='manual_author_console_required';uploadAttempted=$false;descriptionSHA256=(Get-FileHash "$OutputPath/description.md").Hash}
Write-Json $status "$OutputPath/description-status.json"
@'
# Project description — official completion step

No documented official CurseForge API updates the main project description.
CF_API_TOKEN grants upload operations according to project membership; it does
not add an undocumented description permission. No public-site session cookies
or internal endpoints are used by this workflow.

Open https://authors.curseforge.com/ → CraftDeja (1796977) → Description → Edit.
Paste the exact contents of description.md using the Markdown editor and save.
Verify the public description afterward. Record completion and the original file
ID in the next release's history review. This mode never uploads an addon file
and needs no CF_API_TOKEN. It can be repeated independently after a file upload.
'@|Set-Content "$OutputPath/AUTHOR-CONSOLE.md" -Encoding utf8
Write-Host 'Description status: manual_author_console_required; file upload not attempted.'
if($env:GITHUB_STEP_SUMMARY) { "## Project description`nStatus: manual_author_console_required. Use description.md in this run's artifact in the Author Console. No file uploaded." >> $env:GITHUB_STEP_SUMMARY }
