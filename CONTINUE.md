# CraftDeja — hier fortsetzen / resume here

## Peak >100 / Speicherhypothese: Dev-Release-Vergleich vorbereitet — 15.11.2026

- Neue Beobachtung: mehr aktive Addons scheinen Ruckeln zu verstärken. Paar CraftDeja+Kela und anschließend kumulativ Companion/Loot Sparkles/Quest Tint, ForeverQuestMark/GearQuest, LFG Bulletin Board, RogueEnergyCombo, ForeverDungeonJournal jeweils flüssig. Weitere Addons dann ohne vollständige Liste aktiviert, Freeze wieder vorhanden. Kein einzelner Partner isoliert.
- Lokalen Freeloader-Code verifiziert: Peak >100 = vom Client CraftDeja zugeordnete Framezeit über 100ms, keine RAM-Prozentanzeige. Spitzenwert ca. 10s gehalten; daraus keinen zehnsekündigen Freezezyklus ableiten. Screenshot 9.4%, 3.34ms/f, 28FPS und KB/s-Striche enthält keine Speichertrendmessung. GC/Heapdruck plausibel, Speicher voll/Leak unbelegt.
- Installierter beta.17-dev+59bee85 sammelt zusätzlich zur optionalen /cdj-perf-Aufnahme ständig automatische wowlua-Funktions-/Handler-/Zeit-/Speicherstatistiken. Dieser gemeinsame Kostenfaktor wurde bisher nicht im kontrollierten Livevergleich entfernt. Keine weiteren Addons einzeln als Verursacher behaupten.
- Gleicher Quellcode als Release-Vergleich gebaut: dist/release/CraftDeja, automatische Compilerkennung 3.9.0-beta.17-alpha+a1362f0. Kein automatisches __wl.prof/__wl.mon/__wl.perf gefunden; TOC ohne Dev-Runtime/Dev-SavedVariable. 73 Dateien, 2757338 Lua-Bytes gegen 117/3005234 im Dev-Artefakt; Dateigrößen sind keine gemessenen Heap-/CPU-Werte.
- tools/Test-CraftDeja.ps1 unterstützt jetzt -Profile dev|release für Build/Benchmark (Default dev). Native test hat KEINEN Profilselektor; Metadaten trennen buildProfile und source-emulator testMode. Erster Versuch 213806-e02211 scheiterte nach Build am falschen test --profile, keine Tests als bestanden ausgegeben; nach Hilfeprüfung korrigiert.
- Release-Build erfolgreich und komplette Quellsuite 520/0/0, 312 Dateien, 221.77s: reports/tests/20261115-213837-0c6669.zip. Dies ist keine Ausführung des gebündelten Release-Artefakts und kein Live-FPS-/GC-Beleg. W1034 bleibt bekannt. Laufzeitquellen unverändert gegen beta.17; keine neue Fachkorrektur.
- Bericht/gesicherter Kandidat unter reports/performance/dev-release-ab-20261115-213935; teilbare ZIP gleichnamig. Details docs/PERFORMANCE_RUNTIME_AB.md. Spielinstallation bleibt beta.17-dev+59bee85; Release-Kandidat in dieser Untersuchungsrunde nicht installiert. Nächster gezielter Vergleich: abgesicherter Dev->Release-Wechsel bei gleichem Addonset/Ort/Fenster, dann 60–90s Leerlauf; keine gleichzeitige Änderung von Grafik, scriptProfile oder Addongruppen. Kein Merge/Releasepublish.


## Weitere Gruppenvergleiche / KelaGraphics noch nicht eindeutig isoliert — 15.11.2026

- Nutzer stellt klar: Screenshots vor Reload, alle Funktionsprüfungen danach. Frühere Interpretation von Erfordert-Neuladen als ungültiger Test war falsch; diese Meldung entwertet die später erfolgten Tests nicht.
- Freeze bleibt bei deaktiviertem Freeloader, später auch bei deaktiviertem Plater/Auctionator/TSM. Aus einer flüssigen Gruppe: Forever Companion/Loot Sparkles/Quest Tint hinzu -> kein Ruckeln; ForeverQuestMark/GearQuest hinzu -> kein Ruckeln; KelaGraphics hinzu -> Nutzer bestätigt Ruckeln.
- Anschließend angekündigt alle Addons außer KelaGraphics zu aktivieren; neueste Meldung alles an, Ruckler wieder da. Kela-aus für diesen letzten Stand ist aus dem angekündigten Ablauf angenommen, nicht aus Screenshot/Runtime-Liste verifiziert. Kela ist damit nicht als alleiniger Partner bewiesen; mehrere Kombinationen oder ein gemeinsamer Zustand bleiben möglich.
- KelaGraphics 0.53.3 lesend geprüft: Telemetrie-Ticker standardmäßig 0.25s nur bei benötigter Aktivität, adaptive Grafik/CVars. Keine direkte CraftDeja-Referenz oder globale UpdateAddOnMemoryUsage/UpdateAddOnCPUUsage/collectgarbage-Aufrufe in dessen Lua gefunden. Das ist kein Freispruch; aktive Features/Settings im Client sind unbekannt. Andere lokale Addons enthalten globale Memory-/CPU-Abfragen, teils nur Slash/Tooltip/Click; daraus keinen periodischen Verursacher ableiten.
- Nächster kontrollierter Paarvergleich: ausschließlich CraftDeja + KelaGraphics, alle übrigen Addons aus, nach Reload gleicher Ort 60–90s. So lässt sich prüfen, ob Kela mit CraftDeja allein hinreichend ist oder die frühere Gruppe einen weiteren Partner benötigt. Falls Paar flüssig bleibt, weitere Partner/Mehrfachinteraktion offen. beta.17-Code/Installation und 520/0/0 unverändert; kein neuer Fix ohne reproduzierten Auslöser.


## Drei-Wege-Test: Freeze nur mit CraftDeja plus übrigen Addons — 15.11.2026

- Nutzer bestätigt: alle übrigen Addons ohne CraftDeja kein Freeze; nur CraftDeja kein Freeze; alle einschließlich CraftDeja Freeze. Damit ist ein zusammensetzungsabhängiger Effekt unter diesen Bedingungen belegt, kein einzelner Verursacher und keine generelle Entlastung von CraftDeja.
- Lokales Freeloader/Core.lua und UI.lua lesend geprüft: sichtbares Hauptfenster ruft Tick per OnUpdate; CPU-Neuattribution bei aktivem Scriptprofiling, optionaler Speicherscan jede dritte Messung (bei 3s Rate ca. 9s). Schließen des Hauptfensters stoppt dessen Sampling-OnUpdate. Tatsächliche Speichermessung nicht als aktiv behaupten; Screenshots zeigen KB/s-Striche. Ein messbedingter Effekt mit dem instrumentierten CraftDeja-Dev-Build bleibt Hypothese, kein bewiesener Fix.
- Nächster einzelner Vergleich: alle bisherigen Addons einschließlich CraftDeja aktiv lassen, Freeloader-Hauptfenster vollständig schließen, 60s am selben Ort/Fensterzustand beobachten. Bei Verschwinden erneut öffnen und Wiederkehr prüfen. Andernfalls Freeloader als Addon deaktivieren und neu laden; danach gezielte Gruppenhalbierung mit CraftDeja dauerhaft aktiv. Keine unnötigen Spielkäufe oder Codeänderungen.
- beta.17-Code/Installation und 520/0/0 unverändert; nur Übergabe aktualisiert. Partner und technische Ursache weiterhin offen.


## beta.17 A/B-Leerlauf: CraftDeja allein ohne Ruckeln — 15.11.2026

- Nutzervergleich: erster beigefügter Log nur CraftDeja aktiv, kein Ruckeln; zweiter mit allen Addons. Gleiche beta.17/dev-Version, jeweils etwa 30s. Ein anderes Addon oder Zusammenspiel ist damit plausibel, einzelner Verursacher noch nicht isoliert.
- Nur CraftDeja: 2598 gemessene OnUpdate, insgesamt 69.104ms, Maximum 0.266ms; 4 Events, insgesamt 0.198ms. Alle Addons: 2622 OnUpdate, insgesamt 76.625ms, Maximum 0.305ms; 420 Gegenstandsinfos, OnEvent insgesamt 11.313ms, Maximum 0.057ms. Keine Refresh-/Entscheidungs-/Rezeptlesungszeilen in beiden CPU-Abschnitten, keine gemeldeten Fehler. Messbereich sind ausgewählte App-Funktionen/Eventframe; keine globale FPS-/Freeze-Erfassung.
- Zusätzlich gepostete /wl-mon-Werte sind kumulativ (u.a. 7478 Iteminfos, 154 ADDON_LOADED). Die zwei OnUpdate-Einträge SystemCheck/Run sind verschachtelte Wrapper desselben Eventframes; gleiche 35.5ms-Maxima nicht addieren und nicht als zwei unabhängige Freeze-Ursachen ausgeben. Weniger/mehr Events allein beweist keinen problematischen Event-Loop.
- Nächster Vergleich: alle bisherigen übrigen Addons aktiv, CraftDeja deaktiviert, gleicher Ort/Fensterzustand, etwa 60s nach Laden beobachten. Bleibt der Freeze, tritt er auch ohne CraftDeja auf. Falls er verschwindet, Zusammenspiel weiter prüfen. Danach Addons gruppenweise halbieren, Abhängigkeiten zusammen halten, je Runde gleiche Bedingungen und neu laden; bestätigen durch gezieltes Aus/Ein des letzten Kandidaten.
- Kein neuer Laufzeitfix aus diesen Daten nötig/belegt. Installierte beta.17 und automatisierter 520/0/0-Nachweis unverändert; Untersuchung des fremden Addons/Zusammenspiels offen.


## beta.17 Live-Rückmeldung: AH unauffällig, Freeze im Leerlauf — 15.11.2026

- Nutzer meldet im AH-Ablauf keine Auffälligkeit; kurzer Freeze im Leerlauf zunächst etwa alle 6s, danach 10s. Als beobachteten Bereich 6–10s behandeln, keine exakte periodische Ursache behaupten.
- Neue 30.001s-Aufnahme beta.17/dev: 2222 OnUpdate-Callbacks, längster gemessener OnUpdate 12.769ms; 5 Refreshs (max 10.400ms), 2 Entscheide (max 0.164ms), 10 probability-Aufrufe. 40 renderNextStep, insgesamt 95.527ms, maximal 6.419ms. Aufzeichnungsaufwand eingeschlossen.
- Diese Aufnahme enthält AUCTION_HOUSE_SHOW, TRADE_SKILL_SHOW, vier Listenupdates, 421 Iteminfos sowie 10/11 Zauberstart/-erfolg-Ereignisse. Sie ist kein kontrollierter reiner Leerlauf und nicht mit dem 262-Rezept-Fall der vorherigen Aufnahme gleichzusetzen. Screenshot 35.7%, 4.20ms/f belegt CPU-Anteil, keinen bestimmten Freeze-Auslöser.
- Keine der alten 171ms-Refreshspitzen in dieser Aufnahme. Die standardmäßige CraftDeja-Aufnahme erfasst ausgewählte Funktionen und den App-Eventframe, nicht sämtliche Addon-/Dev-Runtime-Callbacks und keine globale Framepause. Kein Beweis gegen andere CraftDeja-Pfade oder für ein anderes Addon.
- Codeprüfung: App-Perioden 1s/3s, SystemCheck 0.25s; Inventory nur dirty/eventgetrieben. Generierte wowlua-Dev-Runtime profiliert zusätzlich und führt Frame-/Trend-/optionale sichtbare Konsolenarbeit aus. Dev-Overhead ist eine offene Hypothese, keine bewiesene Ursache des 6–10s-Freezes; Runtime nicht verändern oder ausschalten ohne Vergleich.
- Nächster Schritt: eine 30s-Aufnahme ausschließlich dort im Leerlauf, wo der Freeze vorkommt; Fensterzustand unverändert lassen, nichts öffnen/kaufen/craften. /cdj perf start, auf Freeze warten, nach 30s /cdj perf show. Ergänzend /wl prof CraftDeja top 10 sort max und /wl mon CraftDeja sind aus der tatsächlich installierten Runtime verifizierte Befehle für weitere Funktions-/Callbackdaten. Bis dahin kein neuer Laufzeitfix aus Vermutung.
- Nur Befund/Übergabe aktualisiert; beta.17-Code und Installation bleiben am geprüften Stand 59bee85403f8de8dbfaec7a7d0b9f43522ce9050. Bestehende 520/0/0 gelten für diesen unveränderten Code. Kein neuer Testlauf erforderlich.


## Beta.17 installiert und geprüft — 15.11.2026, 20:32

- Installiert für den fortgesetzten CPU-/Lag-Live-Test: 3.9.0-beta.17-dev+59bee85, Quellcommit 59bee85403f8de8dbfaec7a7d0b9f43522ce9050, codex/performance-refresh. Nutzerhinweis zum Beenden erfolgt; vollständige CIM-Prozesssicht vor Backup, unmittelbar vor und nach Installation ohne laufenden WoW-Client. WowUp-CF und wowlua als Werkzeuge ausgeschlossen.
- Backup reports/install/beta17-20261115-203201/CraftDeja-before-beta17.zip: alle 118 beta.16-Dateien per SHA256 im Archiv und unmittelbar vor Ersatz gegen das unveränderte Ziel geprüft. Alle 117 beta.17-Payload-Dateien SHA256-identisch mit neuem Build; .wowlua-install zusätzlich geprüft. Gegen gesicherten Testbuild nur generierte TOC/runtime-Buildkennungen verändert, normalisierte Inhalte identisch.
- Automatischer Bericht reports/install/beta17-20261115-203201-bericht.zip, Ergebnis installed_verified. 38 Quellhashes passen weiterhin zum finalen 520/0/0-Testnachweis 20261115-202609-aaf84c. Kein erneuter Test nötig: ausschließlich Installation/Übergabe nach geprüftem Code. Main und WTF/SavedVariables unverändert.
- Live-Stand: Nutzer meldet beta.16 besser, aber noch Ruckler; die 30s-Aufnahme belegt verbleibende teure Auswahlen, keine allgemeine Auctionator-Endlosschleife. beta.17-Livewirkung ausdrücklich OFFEN. Nächster Schritt: gleicher AH-Ablauf und kleinere manuelle Menge zunächst ohne Diagnose; danach 30s /cdj perf start und /cdj perf show. Zeitpunkt der Spitze nach Berufsöffnung, Scan, Angebot oder Leerlauf unterscheiden. Kein Kauf erforderlich.


## Beta.17 — Folgeprüfung nach Live-Aufnahme, 15.11.2026

- Nutzer meldet beta.16 besser, verbleibendes Ruckeln. Screenshot: CraftDeja 10.9%, 3.89ms/f; kein kontrollierter Vergleich. 30s-CPU-Aufnahme: 9 Refreshs, max. 171.212ms; 216 selectionAt, 63984 probability; 363 Gegenstandsereignisse. Messoverhead enthalten, keine konkrete Auctionator-Endlosschleife bewiesen.
- Weitere nachgewiesene Arbeit korrigiert: unmögliche Skill-/Zugangs-/Statuskandidaten vor Wahrscheinlichkeit ausschließen, ungeprüfte Quellen gesondert erhalten; Gegenstandsinteresse per Rezepttabelle indizieren statt vollständiger Suche je Metadatenereignis. Index nach Rezeptlesung invalidiert. Keine neue Drossel oder Mengenänderung.
- Identische synthetische gemischte 262-Rezept-Fixture: 8908 -> 1088 Wahrscheinlichkeitsauswertungen; native Windows/Camelot/wowlua 0.13.14-Zeit 35.421267 -> 9.928720ms je Entscheidung (unoptimiert 34.950167 -> 9.915473ms), sieben Samples. Nicht die echte Katalogzusammensetzung, kein Spiel-FPS-Beleg. 480 differenzielle Auswahlvergleiche bestehen.
- Finale suite beta.17: Build bestanden, 520/0/0, 312 Dateien, 207.86s. reports/tests/20261115-202609-aaf84c.zip. Gesamtbericht reports/performance/beta17-20261115-202609.zip mit Live-CPU-Auszug, Roh-ZIPs, Vergleich und 38 Quellprüfsummen. W1034 bleibt bekannt.
- Branch codex/performance-refresh, Basiscommit 243cf9803e7b783161bd33d8565de7c2b7481fc1; Quellsicherungscommit mit git log bestimmen. Vorhandene drei lokale Installationsübergaben beta.16 vollständig erhalten und mitgeführt. Details, verworfener Versuch und Grenzen: docs/PERFORMANCE_BETA17.md.
- Aktuell zur Installation vorbereitet; bestätigten Installationsbericht separat beachten. Offen bleibt die tatsächliche Wirkung von beta.17 im Client. Nächster Schritt: gleicher AH-Ablauf, kleine manuelle Menge; zunächst ohne Diagnose, dann 30s /cdj perf start und /cdj perf show. Kein Kauf nötig, Spitzen nach Phase unterscheiden. Kein Merge nach main.


## Beta.16 installiert für CPU-/Lag-Live-Test — 15.11.2026, 20:12

- Neuer ausdrücklicher Nutzerauftrag hebt die vorherige installationsfreie Performance-Runde auf: geprüfte beta.16 jetzt lokal installieren und AH/Lagspikes im Spiel testen. Kein Merge nach main.
- Installiert: 3.9.0-beta.16-dev+243cf98, Quellcommit 243cf9803e7b783161bd33d8565de7c2b7481fc1, Branch codex/performance-refresh. Ausschließlich Forever/Interface/AddOns/CraftDeja; SavedVariables/WTF nicht verändert.
- Vollständige CIM-Prozesssicht vor Backup, unmittelbar vor und nach Installation: kein WoW-Spielprozess; nur WowUp-CF. Spiel nicht selbst beendet oder gestartet.
- Backup reports/install/beta16-20261115-201216/CraftDeja-before-beta16.zip: alle 117 alten Dateien im ZIP per SHA256 verifiziert und unmittelbar vor Installation erneut mit dem unveränderten Ziel verglichen.
- Alle 38 Quellhashes passen zum automatisierten Freigabenachweis reports/tests/20261115-195119-54e166.zip (517/0/0, 183.59s). Kein neuer Testlauf, Laufzeitcode unverändert.
- Alle 117 installierten Payload-Dateien SHA256-identisch zum neuen Build; zusätzliche .wowlua-install-Verwaltungsdatei geprüft. Gegen gesicherten Testbuild nur generierte Commit-/Buildmetadaten in TOC/runtime.lua verändert, normalisierte Inhalte identisch. Bekannte W1034 bleibt.
- Teilbarer automatischer Installationsbericht: reports/install/beta16-20261115-201216-bericht.zip; Ergebnis installed_verified. Backup und getesteter Buildsnapshot separat im selben lokalen Verzeichnis. Main unverändert.
- Offen: tatsächliche CPU-/Lagwirkung im Client. Erst ohne Diagnose normalen AH-Ablauf/kleinere manuelle Kaufmenge prüfen; für eine gezielte 30s-Aufnahme /cdj perf start, nachher /cdj perf show, CPU-Abschnitt kopieren. Diagnose selbst verursacht Overhead. Kein Kauf nötig. Detaillierter Vergleichsplan: docs/PERFORMANCE_BETA16.md. Mot-Gebühr ist unter beta.15 bereits live bestätigt.


Stand: 15.11.2026, beta.17 installiert und automatisiert geprüft; Live-Ergebnis beta.17 offen. beta.16 subjektiv besser, Restspitzen belegt.

## Aktueller Stand — beta.16 Performance, 15.11.2026

- Nutzerauftrag: hohe CPU/Ruckler anhand Code und identischer Camelot-Messfälle untersuchen und beheben; ausdrücklich KEINE Installation und kein Merge nach main. Diese auftragsspezifische Ausnahme geht der allgemeinen Auto-Installregel vor. Im Spiel bleibt beta.15 mit bestätigter Mot-Gebühr.
- Ausgang: sauberer Branch feature/acquisition-costs, Commit 9cf3669700b55ba6bc2603ad60624021004d8ffc. Neuer Feature-Branch codex/performance-refresh, Entwicklungsversion 3.9.0-beta.16. Aktuellen Sicherungscommit mit git log -1 bestimmen und nach Push mit Remote vergleichen.
- Nachgewiesen: bekannte Erwerbskosten-Kanten wurden seit beta.13 für jeden Kandidaten/Skill erneut ausgewertet; jetzt einmal pro Snapshot/Skill und billigste Kante je gleichem Punktgewinn. Neue Snapshots invalidieren korrekt. Unabhängige vollständige kleine Routenenumerationen prüfen gleiche Lernentscheidung/Kosten auch mit negativen Nettokosten und mehreren Punkten.
- Beide Commodity-Ereigniskanäle speicherten Preise und lösten sofort volle Marktvergleiche aus. Preise bleiben synchron gespeichert; mehrere Meldungen vor einem Frame werden einmal auf dem nächsten OnUpdate verarbeitet. Explizite Kauf-/Quote-/Suchaktionen rechnen synchron neu; native Craft-Sperren erhalten. Kein zusätzlicher Zeit-Throttle/Timer.
- Versteckte Rezeptkataloge werden aus allgemeinem UI-Refresh ausgeschlossen; Öffnen und sichtbare Kataloge aktualisieren weiter. Alte manuelle Mengenregeln unverändert; vorhandene 25 AHPerformance-Fälle bestanden. Kein aktueller 101-Rücksetzfehler behauptet.
- Identische Stress-Fixture (262 Rezepte, 200 bekannt, 62 synthetische Erwerbsgebühren, Skill 117 bis Cap 150): drei Snapshots 1,235,310 -> 27,510 Wahrscheinlichkeitsauswertungen, Quotes unverändert 786. 24 Preisereignisse vor einem Frame: Markt-/UI-Berechnungen 24 -> 1, letzter Preis erhalten; 0 Rezept-Neueinlesungen. 100 gleiche Preise: 0 -> 0 Marktberechnungen.
- Nativer wowlua bench, gleicher Windows-Host/Camelot/Dev-Profil, 7 Batches à 100ms Zielgröße, identische Fixture SHA256: 2141.9962 -> 53.16255 ms je Entscheidung (unoptimiert 2162.1248 -> 54.56185 ms). Adaptive Aufrufzahl je Batch normiert. Reine Emulatorlaufzeiten, KEINE gemessene FPS-/Spiel-Framezeitverbesserung!
- Finale breite Windows/Blizzard-UI-Regressionssuite: 517 bestanden, 0 fehlgeschlagen, 0 übersprungen, 311 Dateien, 183.59s, wowlua 0.13.14. Report reports/tests/20261115-195119-54e166.zip. 12 neue Tests plus unabhängige Referenzfälle; 38 Lua-Quellhashes und sämtliche Testeingabehashes geprüft. W1034 bleibt bekannt.
- Teilbare Gesamt-ZIP: reports/performance/beta16-20261115-195714.zip. Enthält Ursachen, Änderungen, Audit, Vergleichs-JSON, Umgebung, Hashes, Vorher-/Nachher-Benchmark-ZIPs, negative Baseline-Grenzen und finale Testberichte, Grenzen und Liveplan. Rohberichte bleiben lokal. Details/Reproduktion in docs/PERFORMANCE_BETA16.md; automatische Erstellung über tools/New-PerformanceReport.ps1.
- Standardmäßig AUS: /cdj perf start aktiviert höchstens 30s feste Funktions-/Eventzählungen, inklusive/exklusive/max Zeiten; /cdj perf stop stellt Originalfunktionen/Handler wieder her, /cdj perf show zeigt kopierbaren Bericht. Keine Argumente/Chat-/Charakter-/Kontodaten, kein dauerhaft laufender Diagnose-Timer. Generierten Dev-Code gegen gestapelte Monitor-Wrapper geprüft.
- Noch offen: Zuordnung der konkreten Live-Spitzen (historisch 12.89 ms/f, neu gezeigt 2.66 ms/f) und tatsächliche Spielverbesserung. Lokales Auctionator 346 lesend geprüft; Vertragstests laden nicht das vollständige Addon. Nach später separat beauftragter Installation exakt 30s AH-Angebot öffnen, kleinere manuelle Menge eingeben, warten, /cdj perf show kopieren; kein Kauf nötig. Bis dahin keine Live-CPU-Besserung behaupten.

## Mot-Livebeleg bestätigt — 15.11.2026, Screenshot 19:10

- Nutzerbild zeigt `CraftDeja 3.9.0-beta.15` und `7771: 200 trainer 1794766159 1794766291`.
- Damit ist die gespeicherte Lerngebühr für Rezept 7771 (Umhang - Schwacher Schutz, Rezeptgegenstand 6345) mit 200 Kupfer und Herkunft trainer im echten Client belegt. Sie passt zum zuvor ausgegebenen Mot-Angebot `available 135913 200 nil`.
- Beobachtungszeitpunkt 1794766159, Diagnosezeit 1794766291: der Beleg war bei der Abfrage 132 Sekunden alt. Es wird kein neuer Schreibvorgang exakt im Moment der Chatabfrage behauptet.
- Der konkrete Nil-Link-/API-Layout-Fall ist damit live bestätigt. Dies belegt weder alle Trainer/Rezepte noch eine vollständige wirtschaftliche Route oder die Anzeige aller Detailansichten. Das Fehlen von Mot in der separaten Referenzquellenliste wurde hier nicht korrigiert.
- Automatisierter beta.15-Testnachweis bleibt 505/0/0 (213.08s), reports/tests/20261115-184607-d24132.zip; geprüfte Installation: reports/install/beta15-20261115-185829-bericht.zip. Nur Dokumentation/Übergabe geändert, kein neuer Testlauf oder erneute Installation nötig.
- Trainerfix-Quellcommit: 106c61fa7b838096449dec6b18570d82e08a1ee7. Kein Merge nach main und kein Addon-Release. Nächster Schritt: normale Nutzung; weitere konkrete Abweichungen getrennt mit Belegen untersuchen. Für diesen Gebührenbeleg ist kein weiterer Diagnosebefehl nötig.

## Beta.15 installiert — 15.11.2026 (Installationsrunde vor der Live-Rückmeldung)

- Nutzer hat direkte Installation neuer geprüfter CraftDeja-Versionen freigegeben: vorher Hinweis zum vollständigen Beenden von WoW, tatsächlichen Prozessstatus prüfen, keine zusätzliche Bestätigung. Dauerhafte Regel in AGENTS.md gespeichert.
- WoW vor und nach Installation vollständig beendet; WowUp-CF nicht als Spielclient behandelt. Quellcommit 106c61fa7b838096449dec6b18570d82e08a1ee7, feature/acquisition-costs.
- Backup: reports/install/beta15-20261115-185829/CraftDeja-before-beta15.zip. Alle 117 bisherigen Dateien einschließlich wowlua-Verwaltungsdatei im Archiv per SHA256 verifiziert; Installation vor dem Ersetzen erneut unverändert geprüft.
- Installiert: 3.9.0-beta.15-dev+106c61f (app.release 3.9.0-beta.15), ausschließlich Forever/CraftDeja. Alle 116 Payload-Dateien SHA256-identisch mit neuem Build; zusätzliche .wowlua-install als Installer-Verwaltungsdatei geprüft.
- Gegen den gesicherten automatisiert geprüften Build nur generierte Commit-/Buildkennungen in CraftDeja.toc und wowlua/runtime.lua verändert; normalisierte Inhalte identisch. Alle 18 Quellhashes des Windows-Testberichts 20261115-184607-d24132.zip passen weiterhin. Teststand 505/0/0, 213.08s; W1034 bleibt bekannt.
- Automatischer teilbarer Installationsbericht: reports/install/beta15-20261115-185829-bericht.zip; Ergebnis installed_verified. Berichte/Backup bleiben lokal. Kein Merge nach main und kein Upload/Release.
- Nächster Schritt: WoW starten, /cdj version zeigt beta.15; Mot-Trainerfenster mit Angebot 7771 öffnen und frischen learningCosts[7771]-Beleg auf 200 Kupfer / trainer / aktuellen Zeitstempel prüfen. Live-Erfassung bleibt bis zur tatsächlichen Rückmeldung offen.

## Beta.15 — Korrekturrunde vor der Installation, 15.11.2026

- Neue Nutzer-Chatdiagnose: `1 Umhang - Schwacher Schutz available 135913 200 nil`. Bei der verwendeten Ausgabe bedeutet dies Serviceindex, Name, Status, Icon-ID, 200 Kupfer, nil-Link. Der aktuelle Client liefert kein Rangfeld zwischen Name und Status.
- Konkrete beta.14-Ursache: Acquisition.lua interpretierte available als Rang und 135913 als Status; der Fallback lehnte deshalb ab. Die bisherigen Tests benutzten nur die ältere name/rank/status-Form. Ausbleibende Ausgabe des alten GetSpellInfo-Befehls deutet zusätzlich auf fehlende globale API; das ist nicht separat live bewiesen.
- Beta.15 erkennt beide Layouts anhand bekannter Statuswerte und Typen. Bei ranglosen Angeboten wird C_Spell.GetSpellInfo mit name/spellID bevorzugt, Legacy bleibt abgesichert verfügbar. Keine erfundenen Ränge; gleiche Namen sind ohne Rangfeld mehrdeutig, auch bei verschiedenen Legacy-Rängen. Abweichende Spell-IDs/Overrides, doppelte Angebote und unklare Daten werden abgelehnt.
- NPC/Rezept/Gegenstand-Beziehung, aktuelle Gebühr, exakte Namen, vorrangige Links und native Craft-Sperre bleiben unverändert. Keine zusätzlichen Timer, Käufe oder Quellenlistenänderungen.
- 20 neue Forever-API-Regressionen. Mit beta.14-Code 70 bestanden / 8 fehlgeschlagen / 0 übersprungen (3 Dateien, 7.14s): reports/tests/20261115-184454-006099.zip. Mit Korrektur fokussiert 78/0/0 (6.77s): 20261115-184533-2afad6.zip.
- Finaler beta.15-Windows/Camelot-Lauf mit Blizzard-UI, wowlua 0.13.14: Build erfolgreich, 505 bestanden, 0 fehlgeschlagen, 0 übersprungen (309 Dateien), 213.08s. ZIP: reports/tests/20261115-184607-d24132.zip. ZIP-Protokoll geprüft; alle 18 aufgezeichneten Quellprüfsummen stimmen exakt. W1034 bleibt bekannt.
- Entwicklungsversion src/Start.lua und wowlua.json: 3.9.0-beta.15. Ausgangscommit 1186209b0f3caa66265d627a1aee4aa9db6b5f78 auf feature/acquisition-costs; vorhandene vier lokale Übergabeänderungen aus der Installations-/Live-Runde vollständig erhalten und mitgeführt.
- Im Spiel bleibt beta.14 installiert. Beta.15 wurde in dieser Runde NICHT installiert; kein Merge nach main, kein Addon-Release. Live-Erfassung bei Mot weiterhin offen. Nächster Schritt: beta.15 separat bei geschlossenem WoW mit Backup installieren und den frischen Beleg für Rezept 7771 prüfen. Keine weiteren alten GetSpellInfo-Diagnosen nötig.

## Installierter Stand beta.14 — 15.11.2026

- Auf ausdrücklichen Nutzerauftrag installiert; WoW vor und nach der Installation beendet. WowUp-CF als Addonmanager von Spielprozessen unterschieden; kein Spiel gestartet oder beendet.
- Quellstand: 1186209b0f3caa66265d627a1aee4aa9db6b5f78 auf feature/acquisition-costs. Installierte TOC: 3.9.0-beta.14-dev+1186209; app.release: 3.9.0-beta.14.
- Backup reports/install/beta14-20261115-150654/CraftDeja-before-beta14.zip: alle 116 ursprünglichen Dateien per SHA256 im Archiv geprüft. Ursprünglicher Testbuild zusätzlich separat gesichert.
- Dokumentierter wowlua-install-Befehl erfolgreich (Exit 0), ausschließlich _forever_/Interface/AddOns/CraftDeja. Alle 116 Payload-Dateien bytegenau identisch mit neuem Build; zusätzliche .wowlua-install ist die geprüfte wowlua-Verwaltungsdatei.
- Gegen den gesicherten Testbuild unterscheiden sich nur generierte Commit-/Buildkennungen in CraftDeja.toc und wowlua/runtime.lua. Nach Entfernen genau dieser Metadatenzeilen ebenfalls identisch. Code und Assets unverändert; alle 18 Quellprüfsummen aus dem 485/0/0-Windowsbericht stimmen weiterhin.
- Automatischer teilbarer Installationsbericht: reports/install/beta14-20261115-150654-bericht.zip (Bericht, vollständiges Protokoll, Metadaten und Dateiprüfsummen). Ergebnis installed_verified. Backup und Berichte bleiben lokal.
- Main unverändert. Kein Merge, kein Release/Upload. Kein neuer Testlauf: unveränderter getesteter Laufzeitcode. Bekannte W1034 bleibt.
- Automatisierte Prüfung und Installation bestanden; Live-Prüfung der Lerngebühr bei Mot Dawnstrider noch offen. Nächster Schritt: im Spiel beta.14 bestätigen, bei Mot das ungelernte Angebot 7771 öffnen und einen frischen learningCosts[7771]-Beleg (200 Kupfer / trainer / aktueller Zeitstempel) prüfen. Nichts kaufen oder lernen erforderlich.

## Arbeitsbasis (Stand vor der Installation; Installation oben bestätigt)

- Projekt: C:\Users\Tim\Projects\CraftDeja
- Repository: https://github.com/DejaBansh/CraftDeja
- Branch: feature/acquisition-costs. Trainerfix: 014381f3cc8c5197e3e268b1a35c7418a371cc8f. Ausgang der Abschlussrunde ist dieser Commit; Arbeitsbaum war sauber. Der folgende Abschlusscommit ändert nur Dokumentation.
- Aktuellen Sicherungscommit mit git log -1 feststellen und mit git ls-remote origin refs/heads/feature/acquisition-costs vergleichen. Nicht aus älteren Notizen ableiten.
- Entwicklungsversion: 3.9.0-beta.14 in src/Start.lua und wowlua.json. Root-TOC beta.4 bleibt historischer Altbestand; installierbare TOC wird generiert.
- Kein Merge nach main, keine Installation ins Spiel, kein Addon-Release in dieser Runde. Beta.14 ist ein geprüfter Quellstand auf dem Feature-Branch; keine installierte/live bestätigte Version behaupten.
- Bei Arbeitsbeginn AGENTS.md, diese Datei, PROJECT_STATE.md, DECISIONS.md, ROADMAP.md, TEST_RESULTS.md und aktuellen Gitstatus lesen. Keine alten Pakete erneut anwenden.

## Änderung und Ursache

- Nutzerfall: Mot Dawnstrider (NPC 11071), Rezept 7771, Rezeptgegenstand 6345, Trainerlink nil, Lerngebühr 200 Kupfer.
- Beta.13 las die Gebühr, leitete die Rezept-ID aber ausschließlich aus Spell-/Enchant-Links ab und verwarf deshalb diesen Fall.
- Beta.14 ergänzt einen bewusst begrenzten Fallback für die konkret belegte NPC/Rezept/Gegenstand-Beziehung. Zusätzlich nötig: Creature-NPC-GUID, unveränderte Katalogbeziehung, available/unavailable-Angebot, exakter Clientname und Rang via GetSpellInfo, keine doppelten Angebotszeilen oder kollidierenden Katalog-Spellidentitäten.
- Mehrdeutige/fehlende Daten werden abgelehnt, andere unbelegte Nil-Link-Angebote bleiben unbekannt. Keine Namensähnlichkeit, kein Indexraten und keine festgeschriebenen 200 Kupfer: gespeichert wird die aktuelle gültige Angebotsgebühr. Exakte Links bleiben vorrangig.
- Keine neuen Timer, keine Käufe/Trainerfilteränderungen. Native Craft-Busy-Sperre bleibt vor sämtlichen Trainer-/Spellabfragen erhalten.

## Testnachweise

- Finaler Windows/Camelot-Lauf über tools/Test-CraftDeja.ps1, wowlua 0.13.14, konfigurierte Blizzard-UI, Build bestanden: 485 bestanden, 0 fehlgeschlagen, 0 übersprungen, 308 Dateien, 204.91 Sekunden.
- Teilbare ZIP: reports/tests/20261115-140332-96c718.zip. Enthält Bericht, vollständiges Protokoll und Metadaten. Alle 18 aufgezeichneten SHA256-Quellprüfsummen gegen den finalen Code geprüft: exakt gleich.
- 24 neue Nil-Link-Regressionen; zusammen mit bisherigen Erwerbskostenfällen 58 Tests. Fokussierter Zwischenstand 58/58 (6.15s); erster Gesamtzwischenstand 485/485 (201.24s). Finaler Lauf oben erfolgte nach Vereinheitlichung des gespeicherten Herkunftswerts auf trainer und ersetzt die Zwischenstände als Freigabenachweis.
- Erster fokussierter Versuch hatte zwei Typfehler in den neuen Testfixtures (Datei kompilierte nicht); korrigiert. Dieser Bericht ist keine erfolgreiche Suite: 20261115-135846-dc5d9d.zip. Sämtliche Rohberichte bleiben lokal unter reports/tests/.
- W1034 in UnifiedUI.lua:37 bleibt bekannt. Automatisierte API-Fixtures sind kein erfolgreicher Liveserver-/Trainerfenster-Nachweis.

## Offen und nächster Schritt

- Offener Live-Retest: Nach gesondert beauftragter Installation bei Mot tatsächlichen Namen/Rang, NPC-GUID und erfolgreiche Erfassung der 200-Kupfer-Gebühr für Rezept 7771 prüfen. In dieser Runde wurde nichts installiert. Fehlende/abweichende Clientdaten bleiben sicher unbekannt.
- Weitere Trainer/Rezepte nur mit konkreten Belegen ergänzen. Kein allgemeiner Nil-Link-Resolver und keine vollständige Quellenabdeckung behaupten.
- Beta.13-Routenvergleich bleibt begrenzt auf einen unbekannten Kandidaten plus bekannte Rezepte; Werkzeug-/Reise-/Rangkosten, AH-Verkaufserlöse und globales Optimum bleiben offen. Skillwahrscheinlichkeiten sind Modellschätzungen.

## Dauerhafte Übergabe

DE/EN, konkrete grüne CTA, kleiner grauer Auftrag-ändern-Button, automatische Levelmengen unter 300 und Gift-/Produktionssonderfälle erhalten. Keine schweren Vollscans während nativer Serien. Spielaktionen benötigen Nutzerklick.

wowlua: C:\Users\Tim\.wowlua\bin\wowlua.exe (0.13.14); tools/Test-CraftDeja.ps1 ergänzt den Sitzungs-PATH. Frühere lokale Sicherung: reports/backups/beta13-before-handoff-20261115-134230/.
Bei Abschluss diese Datei mit Änderungen, Testnachweisen, offenen Fehlern und nächstem Schritt aktualisieren. Commit/Push mit Remote-Ref vergleichen; Berichte/Backups nicht automatisch veröffentlichen.

## Abschlussprüfung — 15.11.2026

Automatisierte Prüfung bestanden, Live-Prüfung der Lerngebühr bei Mot Dawnstrider noch offen.
Alle 18 Quellprüfsummen aus 20261115-140332-96c718.zip erneut gegen die aktuellen Dateien geprüft: exakt identisch. Code, Tests, Manifest/Lockfile und Testskript sind gegenüber 014381f unverändert; deshalb kein neuer Testlauf in dieser reinen Dokumentationsrunde.
Der konkrete nächste Schritt samt Backup und festem Forever-Ziel ist in docs/LIVE_TEST_BETA14.md vorbereitet. Vorhandenes Testskript tools/Test-CraftDeja.ps1; Installation über das per --help geprüfte wowlua install. Nicht ausgeführt. Main und Spielinstallation bleiben unverändert.

## Mot-Live-Rückmeldung — 15.11.2026, Screenshots 18:27–18:30

- Nutzerprotokoll bestätigt beta.14-Sessionstart um 18:26:05, Client 1.60.1 / 70938 / 16001, deDE.
- Screenshot 182757 zeigt `7771 fee/source/at/now nil nil nil 1794763659`: zu diesem Zeitpunkt kein gespeicherter Gebührenbeleg für 7771. Spätere Rezeptdetails (183028/183032) melden weiterhin unbekannte Lern-/Rezeptkosten.
- Damit ist erfolgreiche Live-Erfassung nicht bestätigt. Kein neuer Erfolg aus automatisierten Tests ableiten. Die Screenshots zeigen außerdem keine Mot-Quelle unter den sechs Referenzquellen; Quellenliste und Gebührenbeobachtung sind getrennte Datenwege.
- Im gelieferten Log fehlt acquisition.trainer_observed; rohe Trainerereignisse und konkrete Ablehnungsgründe werden im aktuellen Code nicht protokolliert. Das Fehlen von TRAINER-Zeilen beweist deshalb nicht, dass kein Trainerfenster geöffnet wurde. Welche Identitäts-/Ambiguitätsprüfung ablehnt, ist noch unbekannt.
- Nächster Schritt: bei offenem Mot-Trainerfenster NPC-GUID, GetSpellInfo(7771)-Name/Rang sowie die echte Servicezeile (Name/Rang/Status/Kosten/Link) lesend erfassen. Danach den Unterschied als Regression nachstellen; keine Aufweichung der Zuordnung auf Verdacht.
- In dieser Auswertungsrunde nur Übergaben ergänzt, keine Codeänderung, kein erneuter Testlauf und keine Installation. Bestehende lokale Änderungen bleiben erhalten.
