param([Parameter(Mandatory=$true)][string]$ReferenceZip)
$ErrorActionPreference='Stop'
# Explicit developer action; never runs in the addon or downloads anything.
$expected='909CB41720CF6BF6920F1C25C644F89B39AD63087F589C07737E7DA943C52379'
if((Get-FileHash -LiteralPath $ReferenceZip -Algorithm SHA256).Hash -ne $expected){throw 'Expected the documented ProfessionDB 1.9.1 archive'}
Add-Type -AssemblyName System.IO.Compression.FileSystem
$zip=[IO.Compression.ZipFile]::OpenRead((Resolve-Path -LiteralPath $ReferenceZip).Path)
try{
    $entry=$zip.GetEntry('ProfessionDB/Data/Forever/_core/Sources.lua')
    if(-not $entry){throw 'Forever Sources.lua missing'}
    $reader=[IO.StreamReader]::new($entry.Open())
    try{$source=$reader.ReadToEnd()}finally{$reader.Dispose()}
}finally{$zip.Dispose()}
$lines=[Collections.Generic.List[string]]::new()
foreach($line in @('-- SPDX-License-Identifier: MIT','-- Generated from ProfessionDB 1.9.1 Forever Sources.lua (MIT).','-- Explicit recipe memberships only; upstream lists are capped at 12, not complete.','-- Reference data, including upstream borrowed Classic metadata; not live verification.','local _,app=...','app.trainerRecipeMembers={')){$lines.Add($line)}
foreach($m in [regex]::Matches($source,'(?m)^\[(\d+)\]=\{t=\{([\d,]+)\}')){$lines.Add(' ['+$m.Groups[1].Value+']={'+$m.Groups[2].Value+'},')}
if($lines.Count -ne 441){throw 'Unexpected recipe membership count'}
$lines.Add('}')
$target=Join-Path (Split-Path -Parent $PSScriptRoot) 'src/Data/TrainerRecipeMembers.lua'
[IO.File]::WriteAllText($target,($lines -join "`n")+"`n",(New-Object Text.UTF8Encoding($false)))
Write-Host 'Generated 435 explicit reference membership lists. Coordinates still require independent recorded facts; no completeness guarantee.'
