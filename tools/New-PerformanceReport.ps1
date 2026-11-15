param(
    [Parameter(Mandatory=$true)][string]$FullTests,
    [string]$BeforeBenchmark='reports/performance/beta16-baseline/reports/tests/20261115-193312-5cd6f8',
    [string]$AfterBenchmark='reports/tests/20261115-194731-d38e6c',
    [string]$BeforeTests='reports/performance/beta16-baseline/reports/tests/20261115-193208-aad261',
    [string]$AfterTests='reports/tests/20261115-194709-a850e5',
    [ValidatePattern('^beta16-[0-9]{8}-[0-9]{6}$')][string]$ReportId=('beta16-'+[DateTime]::Now.ToString('yyyyMMdd-HHmmss'))
)
$ErrorActionPreference='Stop'
$project=Split-Path -Parent $PSScriptRoot
$out=Join-Path $project ('reports/performance/'+$ReportId)
New-Item -ItemType Directory -Path $out -Force | Out-Null
$utf8=[Text.UTF8Encoding]::new($false)
$state=[ordered]@{result='started';error=$null;created=[DateTimeOffset]::Now.ToString('o')}
function Read-Json([string]$dir,[string]$name){return Get-Content -LiteralPath (Join-Path (Join-Path $project $dir) $name) -Raw | ConvertFrom-Json}
$code=1
Start-Transcript -LiteralPath (Join-Path $out 'PROTOKOLL.txt') | Out-Null
try {
    $before=Read-Json $BeforeBenchmark 'BENCHMARK.json';$after=Read-Json $AfterBenchmark 'BENCHMARK.json'
    $bm=Read-Json $BeforeBenchmark 'METADATEN.json';$am=Read-Json $AfterBenchmark 'METADATEN.json'
    $full=Read-Json $FullTests 'METADATEN.json';$focused=Read-Json $AfterTests 'METADATEN.json'
    if($full.result -ne 'passed' -or $full.failed -ne 0 -or $full.skipped -ne 0 -or $focused.result -ne 'passed'){throw 'Final regression incomplete'}
    if($bm.result -ne 'benchmark_completed' -or $am.result -ne 'benchmark_completed'){throw 'Benchmarks incomplete'}
    if($before.profile -ne $after.profile -or $before.samples -ne $after.samples -or $before.batch_ms -ne $after.batch_ms){throw 'Benchmark settings differ'}
    foreach($name in @('os','architecture','processor','cpuCount')){if($bm.environment.$name -ne $am.environment.$name){throw "Environment differs: $name"}}
    $fixture='tests/RefreshCostSuite/refresh-cost.test.wowlua'
    if($bm.testHashes.$fixture -ne $am.testHashes.$fixture -or $am.testHashes.$fixture -ne $full.testHashes.$fixture){throw 'Benchmark fixture changed'}
    foreach($hash in $full.sourceHashes.PSObject.Properties){
        $path=Join-Path $project ('src/'+$hash.Name+'.lua')
        if((Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash -ne $hash.Value){throw ('Current source mismatch: '+$hash.Name)}
        if($am.sourceHashes.PSObject.Properties[$hash.Name].Value -ne $hash.Value){throw ('Final benchmark/source mismatch: '+$hash.Name)}
    }
    foreach($hash in $full.testHashes.PSObject.Properties){if((Get-FileHash -LiteralPath (Join-Path $project $hash.Name) -Algorithm SHA256).Hash -ne $hash.Value){throw ('Current test mismatch: '+$hash.Name)}}
    $beforeLog=Get-Content -LiteralPath (Join-Path (Join-Path $project $BeforeTests) 'PROTOKOLL.txt') -Raw
    $oldCounts=[regex]::Match($beforeLog,'PERF acquisition probability=(\d+) expected=(\d+)')
    $oldBurst=[regex]::Match($beforeLog,'PERF burst events=24 markets=(\d+) renders=(\d+)')
    if(-not $oldCounts.Success -or -not $oldBurst.Success){throw 'Missing baseline counter evidence'}
    $b=$before.files[0].benches[0];$a=$after.files[0].benches[0]
    $state.result='verified';$state.version=$full.addonVersion;$state.branch=(git -C $project branch --show-current | Out-String).Trim()
    $state.baseCommit=$full.gitCommit;$state.environment=$full.environment
    $state.fixtureSHA256=$bm.testHashes.$fixture
    $state.settings=[ordered]@{profile=$after.profile;samples=$after.samples;batchMs=$after.batch_ms;callsPerBatchBefore=$b.calls;callsPerBatchAfter=$a.calls}
    $state.timings=[ordered]@{beforeOptimizedMs=$b.optimized.nanos/1000000;afterOptimizedMs=$a.optimized.nanos/1000000;beforeUnoptimizedMs=$b.unoptimized.nanos/1000000;afterUnoptimizedMs=$a.unoptimized.nanos/1000000;beforeSpread=$b.optimized.spread;afterSpread=$a.optimized.spread}
    $state.counters=[ordered]@{snapshots=3;recipes=262;known=200;unknownWithFee=62;beforeProbability=[int]$oldCounts.Groups[1].Value;afterProbability=[int]$oldCounts.Groups[2].Value;quoteCallsBefore=786;quoteCallsAfter=786;priceEvents=24;beforeMarkets=[int]$oldBurst.Groups[1].Value;afterMarkets=1;beforeUI=[int]$oldBurst.Groups[2].Value;afterUI=1;counterEvidence='Identical fixture, baseline failures and final exact counter assertions passed'}
    $state.tests=[ordered]@{passed=$full.passed;failed=$full.failed;skipped=$full.skipped;focusedPassed=$focused.passed;fullReport=$FullTests;beforeExpectedFailures=2}
    $fullLog=Get-Content -LiteralPath (Join-Path (Join-Path $project $FullTests) 'PROTOKOLL.txt') -Raw
    $duration=[regex]::Match($fullLog,'517 passed, 0 failed, 0 skipped \(311 files\) in ([0-9.]+)s')
    if(-not $duration.Success){throw 'Final full test duration missing'}
    $state.tests.durationSeconds=[double]::Parse($duration.Groups[1].Value,[Globalization.CultureInfo]::InvariantCulture)
    $state.sourceHashes=$full.sourceHashes;$state.testHashes=$full.testHashes;$state.inputHashes=$full.inputHashes
    $state.generatorSHA256=(Get-FileHash -LiteralPath $PSCommandPath -Algorithm SHA256).Hash
    $auctionator='C:\Program Files (x86)\World of Warcraft\_forever_\Interface\AddOns\Auctionator\Source_ModernAH\Tabs\Buying\Commodity\Mixins\Main.lua'
    $state.inspectedAuctionator=[ordered]@{version='346';commodityMainSHA256=(Get-FileHash -LiteralPath $auctionator -Algorithm SHA256).Hash;scope='Read-only source inspection; tests use counted contract fixtures, not the full Auctionator addon'}
    Copy-Item -LiteralPath (Join-Path $project 'docs/PERFORMANCE_BETA16.md') -Destination (Join-Path $out 'URSACHEN_UND_LIVEPLAN.md')
    $runs=[ordered]@{BEFORE_BENCHMARK=$BeforeBenchmark;AFTER_BENCHMARK=$AfterBenchmark;BEFORE_COUNTERS=$BeforeTests;AFTER_FOCUSED_TESTS=$AfterTests;FINAL_TESTS=$FullTests}
    foreach($entry in $runs.GetEnumerator()){
        Copy-Item -LiteralPath ((Join-Path $project $entry.Value)+'.zip') -Destination (Join-Path $out ($entry.Key+'.zip'))
    }
    $text=@"
# CraftDeja beta.16 Performancebericht

Ergebnis: verified. Keine Installation ins Spiel, kein Merge nach main.
Ursachen/Änderungen/Grenzen und Live-Testplan: URSACHEN_UND_LIVEPLAN.md.

Identische 262-Rezept-Fixture, gleicher Windows-Host und Camelot/wowlua 0.13.14,
Dev-Profil, $($after.samples) Messbatches, $($after.batch_ms) ms Zielzeit je Batch.
Native Zeit je Entscheidung (Dev/optimiert): $($state.timings.beforeOptimizedMs) ms vorher -> $($state.timings.afterOptimizedMs) ms nachher.
Native Zeit je Entscheidung (unoptimiert): $($state.timings.beforeUnoptimizedMs) ms -> $($state.timings.afterUnoptimizedMs) ms.
Die Zahl der Aufrufe je Batch wird adaptiv kalibriert; Zeiten sind je Aufruf normiert.
Reiner Emulator-Stresstest: keine gemessene Spiel-Framezeit/FPS-Verbesserung!

Wahrscheinlichkeitsauswertungen bei 3 Snapshots: $($state.counters.beforeProbability) -> $($state.counters.afterProbability).
Quote-Aufrufe unverändert 786; kein Weglassen der Preisauswertung.
24 Preisereignisse vor einem Frame: $($state.counters.beforeMarkets) -> 1 Marktberechnung / UI-Refresh; letzter Preis erhalten; 0 Rezept-Neueinlesungen.
100 unveränderte Preisereignisse: 0 Marktberechnungen in beiden Versionen.
Baseline: zwei erwartete neue Performance-Grenzen verletzt; final bestehen sie.
Finale Gesamtsuite: $($full.passed) bestanden, $($full.failed) fehlgeschlagen, $($full.skipped) übersprungen.
311 Dateien; $($state.tests.durationSeconds) Sekunden. Bekannte Buildwarnung W1034 bleibt.
Enthalten: vollständige Vorher-/Nachher-Benchmark- und Testberichte mit Protokollen,
Umgebung und SHA256-Prüfsummen. VERGLEICH.json enthält die geprüften Rohwerte/Hashes.

Offen: tatsächlicher Anteil dieser Pfade an den gemeldeten Live-Spitzen. Diagnose
standardmäßig aus; nach separat beauftragter Installation 30s /cdj perf start,
AH-Angebot öffnen und Menge kleiner stellen, anschließend /cdj perf show kopieren.
Nicht kaufen. Aktive Diagnose verursacht selbst Overhead. Details siehe Liveplan.
"@
    [IO.File]::WriteAllText((Join-Path $out 'BERICHT.md'),$text,$utf8)
    $code=0
} catch {$state.result='failed';$state.error=($_|Out-String);Write-Host $state.error}
finally {
    [IO.File]::WriteAllText((Join-Path $out 'VERGLEICH.json'),($state|ConvertTo-Json -Depth 14),$utf8)
    Stop-Transcript | Out-Null
    $archive=$out+'.zip'
    Compress-Archive -Path (Join-Path $out '*') -DestinationPath $archive -Force
    Write-Output "PERFORMANCE-ZIP: $archive"
}
exit $code
