$ErrorActionPreference='Stop'
$taskProjectRoot=Split-Path -Parent $PSScriptRoot
$taskReporter=Join-Path $taskProjectRoot 'tools/Test-CraftDeja.ps1'
$taskOutput=Join-Path $taskProjectRoot ('reports/workshop-matrix/'+(Get-Date -Format 'yyyyMMdd-HHmmss'))
New-Item -ItemType Directory -Path $taskOutput|Out-Null
$utf8=New-Object Text.UTF8Encoding($false)
$summaries=@()
foreach($case in @(@('1080-ui065',1920,1080,.65),@('1080-ui100',1920,1080,1.0),@('1440-ui065',3440,1440,.65),@('1440-ui100',3440,1440,1.0))){
    $taskVariant=Join-Path $taskOutput $case[0]
    New-Item -ItemType Directory -Path $taskVariant|Out-Null
    foreach($file in @('src','Art','wowlua.json','wowlua.lock')){if(Test-Path -LiteralPath (Join-Path $taskProjectRoot $file)){Copy-Item -LiteralPath (Join-Path $taskProjectRoot $file) -Destination $taskVariant -Recurse}}
    New-Item -ItemType Directory -Path (Join-Path $taskVariant 'tools'),(Join-Path $taskVariant 'tests/WorkshopSuite')|Out-Null
    Copy-Item -LiteralPath $taskReporter -Destination (Join-Path $taskVariant 'tools/Test-CraftDeja.ps1')
    Copy-Item -LiteralPath (Join-Path $taskProjectRoot 'tests/WorkshopSuite/workshop.test.wowlua') -Destination (Join-Path $taskVariant 'tests/WorkshopSuite/workshop.test.wowlua')
    $manifest=Get-Content -LiteralPath (Join-Path $taskVariant 'wowlua.json') -Raw|ConvertFrom-Json
    $screen=@{width=$case[1];height=$case[2];uiScale=$case[3];dpiScale=1}
    $manifest.test|Add-Member -NotePropertyName screen -NotePropertyValue $screen -Force
    [IO.File]::WriteAllText((Join-Path $taskVariant 'wowlua.json'),($manifest|ConvertTo-Json -Depth 16),$utf8)
    & $taskReporter -ProjectPath $taskVariant -Profile release -Filter 'Workshop' -Evidence -ScreenshotTest 'tests/WorkshopSuite/workshop.test.wowlua'
    if($LASTEXITCODE -ne 0){throw ('Workshop screen check failed: '+$case[0])}
    $report=Get-ChildItem -LiteralPath (Join-Path $taskVariant 'reports/tests') -Directory|Sort-Object Name|Select-Object -Last 1
    $metadata=Get-Content -LiteralPath (Join-Path $report.FullName 'METADATEN.json') -Raw|ConvertFrom-Json
    if($metadata.result -ne 'passed'){throw 'Incomplete screen check'}
    $summaries+=@{variant=$case[0];screen=$screen;testReport=$report.FullName+'.zip';result=$metadata.result;sourceHashes=$metadata.sourceHashes}
}
$assets=@{};foreach($file in Get-ChildItem -LiteralPath (Join-Path $taskProjectRoot 'Art') -File){$assets[$file.Name]=(Get-FileHash -LiteralPath $file.FullName).Hash}
[IO.File]::WriteAllText((Join-Path $taskOutput 'MATRIX.json'),(@{views='wowlua source emulation, not live client';cases=$summaries;assetHashes=$assets}|ConvertTo-Json -Depth 12),$utf8)
Write-Host ('WORKSHOP MATRIX: '+$taskOutput)
