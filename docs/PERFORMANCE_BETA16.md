# Beta.16 — Performance-Untersuchung und begrenzter Nachweis

## Ausgangslage und Beobachtungen

Basis: beta.15, Commit 9cf3669700b55ba6bc2603ad60624021004d8ffc,
sauberer Arbeitsbaum auf feature/acquisition-costs; eigener Branch
codex/performance-refresh. Spielinstallation bleibt auf beta.15 unverändert.
Die ausdrückliche Anweisung dieser Runde untersagt Installation und Merge nach main.

Gemeldet wurden früher etwa 63 % Addon-CPU und 12.89 ms/Frame; der neue Screenshot
191942 zeigt CraftDeja 19.2 % und 2.66 ms/Frame, alle Addons 38.7 % / 5.36 ms/Frame.
Das sind verschiedene, nicht kontrollierte Spielaufnahmen. Sie belegen Last,
aber keine bestimmte Ursache, Regression oder Verbesserung unter gleichen Bedingungen.

## Nachgewiesene Rechenpfade und Änderungen

1. Seit beta.13 berechnet die Erwerbskostenbewertung für jeden unbekannten
   Kandidaten an jedem Skillknoten erneut sämtliche bekannten Rezepte. Der
   Kandidatenvergleich hat damit vermeidbare Faktoren Kandidaten × bekannte
   Rezepte × Skillhorizont. Beta.16 berechnet die bekannten Kanten pro Snapshot
   und Skill nur einmal. Bei gleichem Punktgewinn dominiert die billigste
   bekannte Kante; ihr Folgeknoten ist identisch. Unterschiedliche Punktgewinne
   bleiben getrennt, Cap-Clipping, Modellchancen und negative Nettokosten erhalten.
   Neue Preis-/Skill-/Gebühren-Snapshots erhalten neue Caches. Unabhängige kleine
   vollständige Routenenumerationen prüfen Kosten und Lernentscheidung.
2. Sowohl CraftDejas COMMODITY_SEARCH_RESULTS_UPDATED als auch Auctionators
   Commodity-Hook konnten unmittelbar einen vollständigen Marktvergleich auslösen.
   Ein Burst mit wechselnden Preisen verursachte mehrfach denselben Arbeitsblock
   und vollständige UI-Aktualisierung. Preise werden weiterhin sofort gespeichert;
   die Markt-Neuberechnung wird auf dem nächsten OnUpdate einmal für alle bis dahin
   eingegangenen Meldungen ausgeführt. Keine zusätzliche Zeitdrossel/Timer.
   Explizite Kauf-, Quote- und Suchaktionen rechnen weiterhin synchron neu und
   verbrauchen anstehende Arbeit. Native Craft-Sperren verschieben schwere Arbeit.
3. Allgemeines refreshUI baute einen schon erstellten, aber versteckten
   Rezeptkatalog inklusive Filtern/Sortieren erneut auf. Jetzt nur bei Sichtbarkeit;
   explizites Öffnen berechnet den aktuellen Inhalt weiterhin vollständig.

Diese Pfade sind im Code und in simulierten Abläufen nachgewiesen. Ihr Anteil
an den konkreten Live-Spitzen von 12.89 bzw. 2.66 ms/Frame ist NICHT gemessen.

## Kontrollierter Vergleich

Unveränderte Fixture tests/RefreshCostSuite/refresh-cost.test.wowlua, SHA256
6F6D01991146663B27F81561E78CDEE86F40D993F57C1F0D94E3749C586F14BC.
262 Rezepte: 200 bekannte, 62 unbekannte mit jeweils bestätigter synthetischer
200-Kupfer-Erwerbsgebühr, Skill 117, Cap 150, ein erwarteter Punkt pro Craft.
Die Zahl 262 orientiert sich am gelieferten Rezeptprotokoll; Verteilung und Gebühren
sind eine Stress-Fixture, keine Behauptung über Tims tatsächliches Rezeptwissen.

| Messgröße | beta.15 | beta.16 |
|---|---:|---:|
| Wahrscheinlichkeitsauswertungen, drei frische Snapshots | 1,235,310 | 27,510 |
| Quote-Aufrufe, dieselben drei Snapshots | 786 | 786 |
| Marktberechnungen bei 24 wechselnden Preisereignissen vor einem Frame | 24 | 1 |
| UI-Refreshes im selben Burst | 24 | 1 |
| Rezept-Neueinlesungen im Burst | 0 | 0 |
| Marktberechnungen bei 100 unveränderten Preisereignissen | 0 | 0 |

Der Vorher-Test scheitert erwartungsgemäß an genau zwei neuen Performance-Grenzen
(1 bestanden / 2 fehlgeschlagen). Nachher bestehen die Grenzen, einschließlich der
exakten 27,510-Zählung und der Übernahme des letzten Preises. Kein stilles Test-Skip.

Echte Laufzeiten kommen vom nativen wowlua bench, nicht von debugprofilestop in
der Simulation: letzteres bleibt in diesen rein synchronen Fixtures bei 0 und wird
ausdrücklich NICHT als Laufzeitmessung gewertet. Native Benchmarks verwenden
dieselbe Fixture, wowlua 0.13.14, Camelot, Dev-Profil, 7 Batches à Zielgröße 100 ms.
Der Runner kalibriert die Aufrufe pro Batch adaptiv und gibt Zeit pro Entscheidung
aus. Optimiert/unoptimiert werden für BEIDE Quellstände gemessen; kein Wechsel von
Dev zu Release als vermeintliche Verbesserung. Die exakten finalen Zeiten, Streuung und Umgebungsdaten stehen in VERGLEICH.json der zusammengesetzten ZIP.
Der initiale Vergleich lag bei 2142 ms gegenüber ungefähr 53 ms pro Entscheidung.
Das sind Emulator-/Interpreter-Laufzeiten, keine Game-Framezeiten oder FPS-Prognose.

Vorher-Projekt bleibt lokal unter reports/performance/beta16-baseline erhalten.
Der Standardreporter tools/Test-CraftDeja.ps1 unterstützt jetzt -Benchmark und
sichert auch Benchmark-JSON, Umgebung, sämtliche Lua-Quellhashes, Testhashes und
Manifest/Lockfile/Reporter-Hash; stderr wird getrennt vom JSON-stdout geparst.
tools/New-PerformanceReport.ps1 baut die teilbare ZIP aus den einzelnen Nachweisen.

## Weitere geprüfte Bereiche und Grenzen

- Run hat einen zentralen OnUpdate, SystemCheck legt einmal einen Wrapper darüber.
  Attention/NativeCue animieren nur ihre Sichtbarkeit/Pulse, der Resize-Griff
  beendet sich sofort ohne Drag. Kein C_Timer-Loop im Addon gefunden. Ihre tatsächlichen
  Live-Kosten wurden nicht separat gemessen; keine pauschale Frequenzänderung.
- Inventarsweeps bleiben ereignisgesteuert und während nativer Serien gesperrt.
  Kein neuer globaler Inventarcache mit unsicherer Invalidierung eingeführt.
- Sieben Auctionator-Hooks werden bei 50 Bindungsversuchen weiterhin genau einmal
  registriert. Scan-Listener sind über Bus/Signatur und aktive Bindung geschützt;
  keine normale Poll-Registrierungsschleife nachgewiesen. Sonderwechsel des Busses
  während einer laufenden Sitzung sind damit nicht vollständig live validiert.
- Lokale Auctionator-Version 346 wurde lesend geprüft. Main.lua: OnTextChanged
  ruft UpdateView; dieses setzt das Mengenfeld und baut die Liste neu. GetPrices
  summiert ausschließlich Preisstufen. CraftDejas bereits vorhandener Guard gegen
  unnötiges UpdateView und der Schutz manueller Mengen bleiben erhalten; bestehende
  AHPerformanceSuite und Kauf-/Bestandsregressionen werden vollständig ausgeführt.
- Fenster/Buttons werden überwiegend einmal erstellt und wiederverwendet. Es wurde
  kein allgemein wachsender Fenster-Neuaufbau behauptet. Sichtbare Aufgaben werden
  weiterhin aktualisiert; nur der versteckte Katalog wird aus allgemeinem Refresh
  herausgenommen. Wiederholte relevante Rezept-Events können weiterhin Neueinlesungen
  auslösen; erst Live-Zähler können die nötige von unnötiger Invalidierung trennen.
- Der installierte wowlua-Dev-Build instrumentiert Funktionen und Frame-Skripte
  auch ohne offenes /wl-Fenster. Das ist zusätzliche Mess-/Entwicklungsarbeit und
  wurde beim Vorher-/Nachher-Profil nicht einseitig abgeschaltet. Kein Beleg, dass
  dies allein die gemeldeten Live-Spitzen verursacht.

## Gezielt vorbereitete Live-Diagnose — standardmäßig AUS

src/Performance.lua installiert beim Laden keine Aufnahme-Wrapper, Events oder
Timer. Erst /cdj perf start zählt feste öffentliche Rechen-/UI-Funktionen und
Ereignisnamen für maximal 30 Sekunden. stop stellt Handler/öffentliche Funktionen
wieder her; wiederholtes Starten stapelt nichts. Fehler werden gezählt und erneut
ausgelöst, nil-/Mehrfachrückgaben bleiben erhalten. Im generierten Dev-Build wurde
die Handler-Identität zusätzlich geprüft: indirektes SetScript verhindert neue
wowlua-Monitor-Wrapper bei Start/Stop. Der generierte Code enthält an diesen Stellen
keine zusätzlichen mon.setScript-Aufrufe.

Erfasst werden Aufrufe, inklusive/exklusive Zeit und Maximalzeit je Funktion sowie
Events und OnUpdate-Aufrufe. Inklusive Zeiten nicht aufsummieren. Aktive Diagnose
verursacht selbst Overhead. Es werden keine Funktionsargumente, Chat-, Charakter-
oder Kontodaten aufgezeichnet. Die letzte Aufnahme bleibt nur im Arbeitsspeicher.

Nach einer SPÄTER separat beauftragten Installation (in dieser Runde keine!):

1. /cdj version prüfen, gleichen Charakter/Beruf/Ort und dieselben Addons verwenden.
2. AH öffnen und einen gültigen Scan vollständig beenden. Keine Kaufbestätigung.
3. /cdj perf start. Zehn Sekunden ruhig warten, dann denselben Reagenzieneintrag
   öffnen, Menge beispielsweise 101 auf 5 ändern, weitere zehn Sekunden warten.
   Bei nicht vorhandenem 101-Vorschlag eine kleinere gültige Menge verwenden.
4. Nach spätestens 30 Sekunden ist die Aufnahme beendet. /cdj perf show öffnet
   den vorhandenen kopierbaren Diagnosebericht; den angehängten CPU-Abschnitt
   vollständig teilen. Optional früher /cdj perf stop.
5. Dazu eine Freeloader-Aufnahme vor/nach genau demselben Ablauf mit gleicher
   CPU-Profiling-Einstellung; getrennte ruhige 30s als Kontrolle. Menge muss 5
   bleiben, letzte Preise müssen stimmen. Nichts kaufen, lernen oder craften nötig.

Für die genaue Zuordnung der verbleibenden Spiel-CPU werden besonders OnEvent-
Häufigkeiten, readRecipes, marketView, learningAssessment, inventoryFor,
captureInventory und renderNextStep benötigt. Keine Live-FPS-Verbesserung ist
durch diese simulierten Messungen bewiesen.

## Finale Verifikation und Berichtshistorie

Finaler Lauf 20261115-195119-54e166: Build bestanden, 517/0/0, 311 Dateien,
183.59 Sekunden; 38 Lua-Quellhashes und alle 312 .wowlua-Eingabehashes geprüft.
Die 312 Eingaben umfassen zusätzliche Hilfs-/Profileingaben; es werden 311
native Testdateien als ausgeführt ausgewiesen. Bestehende AH-/Craft-/Gift-/Kauf-
und Wirtschaftstests bleiben im vollständigen Lauf enthalten. Neue Suite: 12 Tests,
davon ein Test mit 54 unabhängig vollständig enumerierten kleinen Routenproblemen.

Finale native Benchmarks: vorher 20261115-193312-5cd6f8 im isolierten Ausgangsprojekt;
nachher 20261115-194731-d38e6c. Dev/optimiert 2141.9962 -> 53.16255 ms je Entscheidung;
unoptimiert 2162.1248 -> 54.56185 ms. Beide sieben Batches, gleiche Hardware/OS und
Fixture; adaptive Aufrufe pro Batch vorher 1, nachher 2, Zeiten je Aufruf normiert.
Streuung steht unverändert im Benchmark-JSON. Exakte Aufrufgrenzen bestehen final.
Gesamt-ZIP: reports/performance/beta16-20261115-195714.zip.

Zwischenläufe bleiben lokal: 192623-cae7f8 und 195054-7ed815 scheiterten vor Tests
am Windows-Schreibzugriff auf dist/.test, keine erfolgreich ausgeführten Fälle.
192850-763f9f lieferte native Benchmarkdaten, aber der erste Reporterentwurf parste
stdout plus stderr als JSON; korrigiert auf getrenntes stdout und erfolgreicher
isolierter Vorher-Benchmark neu ausgeführt. 193932-ef615e fand zwei falsche
Identitätsannahmen über mock.stub-Wrapper in den Diagnose-Testfixtures; korrigiert.
194202-b09f7d bestand 517 Tests, ist aber ein Zwischenstand vor Absicherung der
Dev-Skript-Identität. Finale Nachweise oben ersetzen Zwischenstände; kein Fehler
wird als bestandener Test ausgegeben. Alle Läufe erhielten automatisch Protokoll,
Metadaten und ZIP über den Projekt-Reporter.
