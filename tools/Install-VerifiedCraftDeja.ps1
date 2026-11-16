param(
    [Parameter(Mandatory=$true)][string]$TestReport,
    [Parameter(Mandatory=$true)][string]$ExpectedCommit
)
$ErrorActionPreference='Stop'
$project=(Resolve-Path -LiteralPath (Split-Path -Parent $PSScriptRoot)).Path
$wowRoot='C:\Program Files (x86)\World of Warcraft'
$target=Join-Path $wowRoot '_forever_\Interface\AddOns\CraftDeja'
$build=Join-Path $project 'dist\release\CraftDeja'
$report=Join-Path $project ('reports/install/verified-'+(Get-Date -Format 'yyyyMMdd-HHmmss'))
New-Item -ItemType Directory -Path $report | Out-Null
$utf8=New-Object Text.UTF8Encoding($false)
Add-Type -AssemblyName System.IO.Compression.FileSystem
$meta=@{result='not_started';testReport=$TestReport;target=$target;started=[DateTimeOffset]::Now.ToString('o')}
function Assert-WowClosed {
    $games=@(Get-CimInstance Win32_Process | Where-Object {$_.Name -match '^(wow|warcraft)' -and $_.Name -notin @('WowUp-CF.exe','wowlua.exe')})
    if($games.Count){throw ('WoW is running: '+(($games | ForEach-Object {$_.Name+':'+$_.ProcessId}) -join ', '))}
    Write-Host 'Full process check: WoW closed.'
}
function Invoke-Wowlua([string]$Arguments) {
    $info=New-Object Diagnostics.ProcessStartInfo
    $info.FileName=$exe;$info.Arguments=$Arguments;$info.WorkingDirectory=$project
    $info.UseShellExecute=$false;$info.CreateNoWindow=$true
    $info.RedirectStandardOutput=$true;$info.RedirectStandardError=$true
    $info.StandardOutputEncoding=[Text.Encoding]::UTF8;$info.StandardErrorEncoding=[Text.Encoding]::UTF8
    $process=New-Object Diagnostics.Process;$process.StartInfo=$info
    Write-Host ('Command: wowlua '+$Arguments)
    try{
        if(-not $process.Start()){throw 'wowlua failed to start'}
        $stdout=$process.StandardOutput.ReadToEndAsync();$stderr=$process.StandardError.ReadToEndAsync()
        $process.WaitForExit();Write-Host ('STDOUT: '+$stdout.Result);Write-Host ('STDERR: '+$stderr.Result)
        return $process.ExitCode
    }finally{$process.Dispose()}
}
function File-Map([string]$root) {
    $map=@{}
    foreach($file in Get-ChildItem -LiteralPath $root -Recurse -File -Force){$key=$file.FullName.Substring($root.Length+1).Replace('\','/');$map[$key]=(Get-FileHash -LiteralPath $file.FullName -Algorithm SHA256).Hash}
    return $map
}
function Assert-Map($expected,$actual,[string]$label) {
    if($expected.Count -ne $actual.Count){throw "$label count differs"}
    foreach($name in $expected.Keys){if($expected[$name] -ne $actual[$name]){throw "$label differs: $name"}}
    Write-Host "$label verified: $($expected.Count) SHA256 hashes."
}
function Zip-Map([string]$path) {
    $map=@{};$zip=[IO.Compression.ZipFile]::OpenRead($path)
    try{foreach($entry in $zip.Entries){
        $entryName=$entry.FullName.Replace('\','/')
        if($entryName.EndsWith('/')){continue}
        if(-not $entryName.StartsWith('CraftDeja/')){throw 'Unexpected backup root'}
        $stream=$entry.Open();$sha=[Security.Cryptography.SHA256]::Create()
        try{$map[$entryName.Substring(10)]=[BitConverter]::ToString($sha.ComputeHash($stream)).Replace('-','')}finally{$stream.Dispose();$sha.Dispose()}
    }}finally{$zip.Dispose()}
    return $map
}
function Assert-Sources($test) {
    foreach($p in $test.sourceHashes.PSObject.Properties){
        if((Get-FileHash -LiteralPath (Join-Path $project ('src/'+$p.Name+'.lua')) -Algorithm SHA256).Hash -ne $p.Value){throw ('Test source changed: '+$p.Name)}
    }
    foreach($p in $test.inputHashes.PSObject.Properties){
        if((Get-FileHash -LiteralPath (Join-Path $project $p.Name) -Algorithm SHA256).Hash -ne $p.Value){throw ('Test input changed: '+$p.Name)}
    }
    foreach($p in $test.testHashes.PSObject.Properties){
        if((Get-FileHash -LiteralPath (Join-Path $project $p.Name) -Algorithm SHA256).Hash -ne $p.Value){throw ('Test changed: '+$p.Name)}
    }
    Write-Host 'All recorded runtime, test and manifest hashes match.'
}
$exitCode=1
Start-Transcript -LiteralPath (Join-Path $report 'PROTOKOLL.txt') | Out-Null
try {
    Set-Location -LiteralPath $project
    Assert-WowClosed
    if((git rev-parse HEAD).Trim() -ne $ExpectedCommit){throw 'Unexpected source commit'}
    if(git status --porcelain=v1 --untracked-files=all){throw 'Working tree is not clean'}
    $meta.commit=$ExpectedCommit;$meta.branch=(git branch --show-current).Trim();$meta.main=(git rev-parse refs/heads/main).Trim()
    $zip=[IO.Compression.ZipFile]::OpenRead((Resolve-Path -LiteralPath $TestReport).Path)
    try{$entry=$zip.GetEntry('METADATEN.json');if(-not $entry){throw 'Missing test metadata'};$reader=[IO.StreamReader]::new($entry.Open());try{$test=$reader.ReadToEnd() | ConvertFrom-Json}finally{$reader.Dispose()}}finally{$zip.Dispose()}
    if($test.result -ne 'passed' -or $test.failed -ne 0 -or $test.skipped -ne 0 -or $test.passed -lt 529 -or $test.filters.Count -ne 0 -or $test.buildProfile -ne 'release' -or $test.build -ne 'passed'){throw 'A successful complete release/source test report is required'}
    Assert-Sources $test
    $meta.version=$test.addonVersion;$meta.tests=@{passed=$test.passed;failed=$test.failed;skipped=$test.skipped;mode=$test.testMode}
    $meta.testSourceHashes=$test.sourceHashes;$meta.testInputHashes=$test.inputHashes;$meta.testHashes=$test.testHashes
    $exe=Join-Path $env:USERPROFILE '.wowlua/bin/wowlua.exe'
    if((Invoke-Wowlua 'build --profile release --locked --color never') -ne 0){throw 'Release build failed'}
    $toc=Get-Content -LiteralPath (Join-Path $build 'CraftDeja.toc') -Raw
    $bundle=Get-Content -LiteralPath (Join-Path $build 'CraftDeja.lua') -Raw
    if($toc -match 'wowlua/runtime|WowluaDevDB' -or $bundle -match '__wl\.(prof|mon|perf)' -or (Test-Path -LiteralPath (Join-Path $build 'wowlua/runtime.lua'))){throw 'Development runtime/instrumentation in release build'}
    $meta.buildVersion=[regex]::Match($toc,'## Version: ([^\r\n]+)').Groups[1].Value
    if(-not $meta.buildVersion.StartsWith($test.addonVersion)){throw 'Build version differs from tests'}
    $meta.buildHashes=File-Map $build
    $candidate=Join-Path $report 'tested-release-build.zip'
    [IO.Compression.ZipFile]::CreateFromDirectory($build,$candidate,[IO.Compression.CompressionLevel]::Optimal,$true)
    Assert-Map $meta.buildHashes (Zip-Map $candidate) 'Release snapshot'
    if((Resolve-Path -LiteralPath $target).Path -ne $target -or (Get-Item -LiteralPath $target -Force).Attributes -band [IO.FileAttributes]::ReparsePoint){throw 'Unexpected or redirected installation target'}
    $meta.backupHashes=File-Map $target;$meta.backup=Join-Path $report 'CraftDeja-before-install.zip'
    [IO.Compression.ZipFile]::CreateFromDirectory($target,$meta.backup,[IO.Compression.CompressionLevel]::Optimal,$true)
    Assert-Map $meta.backupHashes (Zip-Map $meta.backup) 'Full addon backup'
    Assert-Map $meta.backupHashes (File-Map $target) 'Unchanged old installation'
    $meta.backupVerified=$true
    Assert-WowClosed;Assert-Sources $test
    $meta.installExitCode=Invoke-Wowlua 'install --profile release --locked --flavor camelot --client _forever_ --wow "C:\Program Files (x86)\World of Warcraft" --force --color never'
    if($meta.installExitCode -ne 0){throw 'Installer failed'}
    Assert-WowClosed
    Assert-Map $meta.buildHashes (File-Map $build) 'Installer build versus verified candidate'
    $installed=File-Map $target;$payload=@{}
    foreach($key in $installed.Keys){if($key -ne '.wowlua-install'){$payload[$key]=$installed[$key]}}
    Assert-Map $meta.buildHashes $payload 'Installed payload'
    Assert-Map $meta.backupHashes (Zip-Map $meta.backup) 'Final backup recheck'
    Assert-Sources $test
    if((git rev-parse refs/heads/main).Trim() -ne $meta.main){throw 'Main moved'}
    $meta.installedHashes=$installed;$meta.result='installed_verified';$exitCode=0
} catch {$meta.result='failed';$meta.error=($_ | Out-String);Write-Host $meta.error}
finally {
    $meta.ended=[DateTimeOffset]::Now.ToString('o')
    [IO.File]::WriteAllText((Join-Path $report 'METADATEN.json'),($meta | ConvertTo-Json -Depth 12),$utf8)
    $summary="# CraftDeja verified release installation`n`nResult: $($meta.result)`nVersion: $($meta.buildVersion)`nCommit: $($meta.commit)`nBranch: $($meta.branch)`nBackup verified: $($meta.backupVerified)`nTest report: $TestReport`nTarget: $target`nError: $($meta.error)`n`nSHA256 evidence in metadata. No WTF/SavedVariables changes, merge or upload. Source emulation is not a live-client acceptance test.`n"
    [IO.File]::WriteAllText((Join-Path $report 'BERICHT.md'),$summary,$utf8)
    Stop-Transcript | Out-Null
    Compress-Archive -LiteralPath @((Join-Path $report 'BERICHT.md'),(Join-Path $report 'METADATEN.json'),(Join-Path $report 'PROTOKOLL.txt')) -DestinationPath ($report+'-bericht.zip')
    Write-Host ('INSTALLATIONSBERICHT: '+$report+'-bericht.zip')
}
exit $exitCode
