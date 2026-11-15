# CraftDeja — verbindlicher Projektstand

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


Stand: 15.11.2026. Dies ist ein Arbeitsstand aus Dateien und sichtbarem Gespräch, kein vollständiges Chat-Transkript.
Vor Änderungen aktuellen Code und diese Notizen prüfen. Kein Gedächtnis ersetzt Versionskontrolle.

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

## Fortsetzungspunkt vor der Installation — beta.14, 15.11.2026

- feature/acquisition-costs, Ausgangscommit 3ca5bbcc2aee639f91575f4b58a2eaf666a004ee; Arbeitsbaum zu Beginn sauber. app.release und wowlua.json: 3.9.0-beta.14. Aktuellen Sicherungscommit mit Git bestimmen.
- Ursache Mot-Fall: beta.13 benötigt Spell-/Enchant-Link zur Rezept-ID und verwirft Gebühr bei nil. Gemeldet: NPC 11071, Rezept 7771, Rezeptgegenstand 6345, 200 Kupfer.
- Implementiert: enger, belegter NPC/Rezept/Gegenstand-Fallback mit exaktem Clientnamen/Rang und Ambiguitätssperren (doppelte Angebote/Spellidentitäten, fehlende Daten). Aktuelle Gebühr statt Festwert, exakte Links vorrangig; andere unbelegte Nil-Link-Fälle unbekannt. Siehe docs/ACQUISITION_COSTS.md.
- Finaler Windows/Camelot-Gesamtlauf mit Blizzard-UI und wowlua 0.13.14: Build bestanden, 485/0/0, 308 Dateien, 204.91s. Bericht reports/tests/20261115-140332-96c718.zip; alle 18 aufgezeichneten Quellhashes stimmen exakt mit finalem Code überein. 24 neue Regressionen. W1034 bleibt bekannt.
- Noch offen: tatsächliche erfolgreiche Gebührenzuordnung im Mot-Trainerfenster nach separat beauftragter Installation bestätigen. Automatisierte Fixtures beweisen keine Live-Erfassung. Keine Spielinstallation, kein Addon-Release und kein Merge nach main in dieser Runde.
- Nächster Schritt: gezielter Live-Retest dieses Angebots; weitere Nil-Link-Angebote nur anhand eigener Belege ergänzen. CONTINUE.md enthält die aktuelle Übergabe; darunter sind frühere Stände als Historie erhalten.

## Vorheriger Fortsetzungspunkt — beta.13 (historisch), 15.11.2026

- Tatsächlicher Arbeitsordner C:\Users\Tim\Projects\CraftDeja; Branch feature/acquisition-costs, Ausgangscommit f26799d1a383d3c4e6280bc9c36aa3fb32c34001. Version in Start.lua und wowlua.json: 3.9.0-beta.13. Aktuellen Sicherungscommit immer mit Git bestimmen.
- Vorhandener Windowsbericht reports/tests/20261115-010908-b537ed.zip geprüft: Build bestanden, 461/0/0, 307 Dateien, 212.88s, wowlua 0.13.14 mit Blizzard-UI. Alle 18 aufgezeichneten Quellprüfsummen stimmen exakt überein. Kein neuer Lauf für diese Dokumentations-/Sicherungsrunde erforderlich.
- Acquisition.lua und Integration implementieren begrenzte einmalige Rezeptkosten; vollständige Werkzeug-/Reise-/Rangkosten und globales Routenoptimum bleiben offen.
- Offener Nutzer-Livebericht: Mot Dawnstrider, Rezept 7771, Rezeptgegenstand 6345, Trainerlink nil, Lerngebühr 200 Kupfer. Exakte Linkbeobachtung in beta.13 kann diese Gebühr nicht zuordnen. Keine Trainerkorrektur in dieser Runde.
- Beta.14 wurde noch nicht ausgeliefert oder installiert. Main und Spielinstallation bleiben in dieser Runde unverändert; kein Release.
- wowlua 0.13.14 liegt unter C:\Users\Tim\.wowlua\bin\wowlua.exe. Testskript ergänzt den Sitzungs-PATH. W1034 bleibt bekannt.
- Lokales Backup: reports/backups/beta13-before-handoff-20261115-134230/ (Arbeitsbaum, geprüftes Git-Bundle, Windowsbericht, Ausgangsstatus).
- Nächste fachliche Aufgabe: sichere Trainerzuordnung für diesen konkreten nil-Link-Fall untersuchen, separat korrigieren und breit testen. CONTINUE.md ist die aktuelle Übergabe; darunter folgen historische Entwicklungsstände.

## Ziel und Produktentscheidungen

- Tim entwickelt CraftDeja für WoW Forever 1.60.1 / Interface 16001; DE und EN.
- Hauptziel: möglichst geringe Goldkosten beim Berufsleveln. Kleine Anzeige mit genau einer klaren nächsten Aktion.
- Große grüne primäre CTA; kurze konkrete Texte. Auftrag ändern klein und grau. Weitere Details in Tooltips/Ansichten.
- Arbeitsstätten konkret nennen: Kochstelle, Amboss, Schmiede, Schmelzofen, Alchemielabor usw., anhand der tatsächlichen Rezeptanforderung.
- Werkzeuge, Voraussetzungen und Ruten als Arbeitsschritte berücksichtigen; ein vorhandener Schritt bedeutet nicht, dass seine Erwerbskosten bereits in der Rezeptbewertung stecken.
- Automatische Planmenge unter 300. Eigene Stückzahlen für Gifte und Produktion ab 300 erhalten.
- Größere fachliche Testsuiten statt ständig einzelner Kleinsttests. Qualität vor Tempo.
- Goblinstil bewahren. Beschreibung und Patchnotes DE/EN. Goblinbild zuerst, nicht riesig. Demo-Einblendungen EN, Originalspielaufnahme DE.

## Historischer Stand bis beta.12 (aktueller Fortsetzungspunkt siehe oben)

- Entwicklungsversion app.release und wowlua.json: 3.9.0-beta.12. Öffentlich veröffentlichte Addon-ZIP weiterhin beta.9.
- Öffentliches Quellrepository: https://github.com/DejaBansh/CraftDeja ; im aktuellen Arbeitsdurchlauf frisch geklont.
- Aktuelles Nutzerprojekt auf dem Gaming-PC: C:\Users\Tim\Projects\CraftDeja. Anderer PC historisch: C:\Users\gv_co\Projects\CraftDeja-Aktuell\CraftDeja.
- Spielordner: C:\Program Files (x86)\World of Warcraft\_forever_\Interface\AddOns\CraftDeja.
- Gaming-PC aktuell: Branch fix/local-recipe-trainers, Basis f744a01; beta.12 angewandt, vollständig auf Windows getestet und im Spiel bestätigt; Sicherungscommit/Push jetzt auszuführen. origin https://github.com/DejaBansh/CraftDeja.git ; erster veröffentlichter Commit 19d881608c377e26c74415ed1b3f12ae7f2d5b52. setup/wowlua und dc914c0 gehören zum älteren PC-Verlauf.
- Nicht zum alten Projekt C:\Users\gv_co\Projects\CraftDeja mit 3.8.0 zurückwechseln.
- Gaming-PC: Git 2.56.0.windows.4, wowlua 0.13.14; Build und 302 Tests erfolgreich. Früherer PC: wowlua 0.13.12. UTF-8 ohne BOM für JSON/Tests beachten.
- Addon-ZIP CraftDeja_3.9.0-beta.9_Logo_CurseForge.zip: einzelner CraftDeja/-Hauptordner, geprüfter Logo-Pfad Art/Logo.tga, CRC bestanden.
- Die Release-TOC trägt generierten Versionssuffix -alpha; app.release ist 3.9.0-beta.9. Das vor der nächsten Veröffentlichung bewusst vereinheitlichen.
- Logo in der generierten TOC geprüft. Manifestfeld addon.icon-texture verwenden; IconTexture unter toc-extra verursacht E4002. Im veröffentlichten wowlua.json korrigiert.
- Die alte Root-TOC im Quellbaum ist ein Adoptierungsrest. Installierbare TOC aus wowlua erzeugen; nicht die Quellstruktur direkt als Release hochladen.

## Implementiert, anhand aktueller Quelldateien geprüft

- Economy.lua: quote.netCost / (p × erreichbare Punkte); quote.cost bleibt brutto. Mindest-Händlerwert aus bestätigten Clientdaten unter Verkaufsannahme.
- Vorhersage wirtschaftlicher Rezeptwechsel. Erwartete Versuche getrennt von sicher vorbereiteter Serienmenge.
- Grün standardmäßig aktiviert; gespeicherte Einstellungen können abweichen.
- Run.lua: Skill-/Inventarereignisse; während laufender Serie leichte Fortschrittsaktualisierung, schwere Vergleiche verschoben.
- Inventory-/Einkaufs-/Posthilfe, Arbeitsstätten-/Werkzeughinweise, Kartenquellen, Ruten-Zwischenaufträge, Giftplanung.
- Alle diese Funktionen weiterhin datenabhängig; keine vollständige Abdeckung aller Spielrezepte behaupten.

## Noch NICHT implementiert / nicht bewiesen

- AH-Verkaufserlöse sind nicht Teil der wirtschaftlichen Auswahl. Händler-Mindestwert ist im beta.10-Entwicklungspatch implementiert; vollständiger Windows-Lauf: 372/372 bestanden.
- Rezeptkauf, Trainergebühren und Werkzeugerwerb vollständig in die Routenkosten einrechnen.
- Global optimale 1–300-Route mit Zwischenprodukten, einmaligen Kosten und späterem Materialverbrauch nachweisen.
- Empirisch validiertes Forever-Modell aller Skillwahrscheinlichkeiten. Aktuell lineares Schätzmodell/Fallbacks.
- Gemessene generelle Überlegenheit gegenüber Wettbewerbern oder garantiert ein bestimmter Empfehlungsrang.
- Vollständige sofortige Marktneuberechnung nach jedem einzelnen Skillpunkt WÄHREND nativer Serien; dies wäre mit der Performance-Entscheidung widersprüchlich.
- Vollständige Live-Spielprüfung aller Abläufe und weiterer Clientupdates steht weiterhin aus. Git-Upload 19d8816 wurde vom Nutzer bestätigt und durch frischen Clone nachgeprüft.

## Testbelege und Grenzen

- Aus vorherigem Gespräch gemeldet: 302 Tests bestanden; danach 45 Craft-/Performance-Fälle nach letzten Guard-Anpassungen bestanden.
- Zusätzlich am Gaming-PC tatsächlich ausgeführt: 302 passed, 0 failed, 0 skipped in 198.23s mit wowlua 0.13.14 / Blizzard UI 1.60.1.70938. Nutzerausgabe geprüft; im veröffentlichten TEST_RESULTS.md dokumentiert.
- Ältere TEST_RESULTS.md enthält andere Versionsstände/Assertion-Zahlen. Immer zugeordnet zitieren.
- Nutzer lieferte echten Forever-Mitschnitt und Screenshots; damit sind einzelne gezeigte Abläufe belegt, keine vollständige Live-Validierung.
- Frühere Dokumentationsrunde ohne Lua-Änderung ist abgeschlossen. Die aktuelle beta.10-Runde ändert Client-Ausgabedaten und die wirtschaftliche Bewertung; passende Regressionen erforderlich.

## Dauerhafte Sicherung und Weiterarbeit

1. Diesen Quellstand und Projektdateien zusätzlich im tatsächlichen Nutzer-Git-Repository versionieren; kein fremdes .git überschreiben.
2. Gitstatus/Diff prüfen und bewusst committen. Ein lokaler Commit ist kein externes Backup; Remote oder zweite Sicherung verifizieren.
3. Bei neuem Chat PROJECT_STATE.md, DECISIONS.md, ROADMAP.md und aktuelle Quelldateien bereitstellen.
4. Zu Beginn Stand/Versionsnummer prüfen; vor jeder Veröffentlichung dokumentierte Aussagen gegen Code und Testergebnis abgleichen.
5. Nach einer Runde Änderungen, Testergebnisse, offene Punkte und nächste Aktion in diesen Dateien aktualisieren.
6. Nur installierbare ZIP mit CraftDeja/-Hauptordner zu CurseForge; dieses Arbeits-/Sicherungspaket gehört NICHT in den Addon-Upload.

## Frühere technische Priorität (historisch)

Beta.12-AH-/Performancekorrektur vollständig prüfen, dann kurzen Live-Profilercheck; anschließend einmalige Lern-/Voraussetzungskosten.
Vorher Tests für Orange-vs-Grün mit Verkaufswert, Ausgabemenge, unbekannten Preisen, nicht verkäuflichen Ergebnissen und Skillcap definieren.

## Sichtbarkeit — GitHub-Startseite vorbereitet am 14.11.2026

README DE/EN mit echtem Goblinbild/GIF, Installation und aktuellen Grenzen neu aufgebaut.
docs/DEVELOPMENT.md und Bug-/Feature-Vorlagen ergänzt; docs/ALGORITHM.md aktualisiert.
Keine Lua-, Artwork-, Manifest- oder Versionsänderungen in dieser Runde. Dokumentlinks und Patch-Anwendung prüfen;
kein erneuter 302-Testlauf für reine Dokumentation behaupten.
CurseForge Source/Issues wurden laut Nutzer gespeichert; deren öffentliche Anzeige konnte hier nicht unabhängig abgerufen werden.
Der neue Dokumentationscommit ist erst nach Anwendung und Push auf dem Nutzer-PC veröffentlicht.

Nächster Schritt: GitHub-Patch anwenden/committen/pushen, About-Text und Topics setzen, dann Netto-Kostenentwicklung.


## Wirtschaftliche Belegfälle — 14.11.2026

- Aktuelle Arbeitsbasis von GitHub frisch geklont: d3b02173457ecc691a3b77e0641a0ffd8fd73d47.
- README/Entwicklungsdokumentation bereits auf GitHub; About und Topics laut Nutzer gesetzt.
- GitHub-Vorabveröffentlichung v3.9.0-beta.9 samt installierbarer Logo-ZIP öffentlich per API geprüft.
- 20 neue kontrollierte Wirtschaftsfälle in tests/EconomyEvidenceSuite/economy.test.wowlua.
- Tatsächliches Economy.lua unverändert; nur Preislieferant/Zugangsgrenze als Fixtures.
- 20/20 im isolierten Lua-5.1-Lauf mit lupa 2.8 bestanden; vier fehlerhafte temporäre Varianten erkannt.
- docs/ECONOMY_EVIDENCE.md enthält DE/EN-Erklärung, feste Eingaben, Erwartungswerte und Grenzen.
- Windows/wowlua-Ausführung der 20 neuen Fälle mit konfigurierter Blizzard-UI laut geprüfter Nutzerausgabe bestanden: 20 passed, 0 failed, 0 skipped in 4.99s, Testdatei 3.50s. Frühere 302 Tests sind ein separater Lauf.
- Kein behaupteter Liveserver-, Eventloop- oder Wettbewerbsnachweis; keine Änderung der Spielmechanik/Version.
- Nächster Schritt: Erfolgreichen Windows-Lauf dokumentieren, die Tests/Dokumentation committen/pushen. Danach Netto-Kostenentwicklung.

Additional isolated wowlua 0.13.12 validation: same 20-case file, unchanged Economy.lua,
minimal namespace bootstrap, camelot/Windows emulation, no Blizzard UI: 20 passed,
0 failed, 0 skipped in 1.15s. The same economic suite also passed within the full addon with configured Blizzard UI on the Gaming PC: 20 passed, 0 failed, 0 skipped in 4.99s. This remains an automated test, not live-server validation.


## Netto-Kostenentwicklung — beta.10, 14.11.2026

- Basis frisch von GitHub: 711d463; 20 Belegfälle und Windows-Nachweis sind dort veröffentlicht.
- Client.lua liest Ausgabe-ID/Mindestmenge für alle Herstellungsberufe und Händler-VERKAUFSwerte getrennt von Einkaufspreisen.
- Economy.lua wertet (Material - bestätigten Mindest-Händlerwert) / erwarteten Skillgewinn. Verkauf ist eine Annahme, keine Automatik.
- Fehlende/ungültige Ausgabe- oder Preisdaten: kein Abzug; Verzauberungen auf Ausrüstung ausgeschlossen. Gebundene verkäufliche Produkte nicht pauschal ausgeschlossen.
- Null/negative Werte bleiben erhalten; Einkaufsmengen und Einkaufsbudget bleiben brutto.
- Details DE/EN erklären die Berechnung. Run.lua und CraftActions.lua unverändert; keine neuen Timer/Ladeanforderungen.
- 50 neue NetCostSuite-Fälle + 20 EconomyEvidence + 17 bisherige AutoSkill-Wirtschaftsfälle: 87 bestanden im minimalen wowlua-0.13.12-Projekt OHNE Blizzard-UI.
- Sechs fehlerhafte temporäre Varianten erkannt; reproduzierbarer Runner tools/verify_net_costs.py.
- Vollständiger Build und alle 372 Tests mit Blizzard-UI auf dem Gaming-PC bestanden; Nachweis docs/evidence/net-costs-windows-2026-11-14.txt. Beta.10 noch nicht im Spiel installiert oder veröffentlicht.
- Nächster Schritt: Geprüften Testnachweis dokumentieren, beta.10 auf dem Feature-Branch committen/pushen und anschließend einen gezielten Live-Test vorbereiten.


## Gifte-Wrapper und automatische Berichte — 14.11.2026

- Erster kompletter beta.10-Lauf auf dem Gaming-PC: Build bestanden, 369 passed / 3 failed / 0 skipped in 216.40s. Noch keine Freigabe.
- Fehler in NetCostSuite 26/27/46 durch Poisons.lua-Wrapper: neuer sellPrices-Parameter wurde verworfen.
- Parameter jetzt weitergereicht; unveraendertes Gift-Mengenmodell. Lokaler Runner laedt Poisons.lua mit: vorher 84/87, nachher 87/87.
- Nutzerwunsch verbindlich: alle kuenftigen Windows-Testlaeufe mit tools/Test-CraftDeja.ps1 und automatischem ZIP-Bericht, auch bei Fehlern.
- Bericht enthaelt Zusammenfassung, komplettes Protokoll und Metadaten; Ablage reports/tests/, durch Gitignore ausgeschlossen.
- Datei im Chat anhaengen oder echten freigegebenen Downloadlink teilen; lokaler Dateipfad allein ist nicht abrufbar.
- Branch auf dem Nutzer-PC: feature/net-vendor-costs, bisherige beta.10-Aenderungen uncommitted.
- Inkrementeller Fix/Berichtsbefehl angewandt; korrigierter kompletter Lauf und ZIP-Bericht geprüft: 372 passed / 0 failed / 0 skipped in 195.46s.


## Bestaetigter beta.10-Windowsstand — 14.11.2026

372/372 Tests mit konfigurierter Blizzard-UI bestanden (304 Dateien, 195.46s); Build bestanden.
Report 20261114-220354-b7fccb.zip, wowlua 0.13.14, 22:03–22:07 Europe/Berlin.
Quellhashes Start/Client/Economy/Poisons/Run abgeglichen (Git-LF/CRLF beruecksichtigt).
W1034 bleibt; exakter Clientbuild nicht im Bericht ausgegeben. Kein Liveservernachweis.
Naechster Schritt: Dokumentationsabschluss anwenden, alle beta.10-Aenderungen auf
feature/net-vendor-costs committen/pushen. Main/CF-Release bleiben beta.9, bis gezielter Live-Test erfolgt.


## Beta.11 — lokale Rezeptlehrer, 14.11.2026

- Öffentlicher Ausgangsstand f744a01 auf feature/net-vendor-costs bestätigt. Beta.10 installiert; Nutzer zeigte korrekte Netto-Zeilen im Spiel.
- Kochrezept: 8c Material - 1c Händlerwert = 7c netto. Verzauberungen: 233c bei Modellchance 72,5% und 128c bei 35%.
- Großer Magiezauberstab: 294c Material - 200c Händlerwert = 94c netto; Lerngebühren weiterhin nicht eingerechnet.
- Live-Fehler: Trainerquelle Orgrimmar trotz Aufenthalt Donnerfels. Gespeichert waren nur sechs Beispiele ohne Donnerfels.
- Neu: rezeptbezogene Quellenkorrektur für 14807, Teg/Mot Dawnstrider, Referenzkoordinaten auf Karte 1456.
- Quellenliste bevorzugt aktuelle Karte und lokale Entfernung unter Beibehaltung von Fraktionsregeln und Rezeptbezug.
- Keine pauschale Vererbung von Rang-Lehrern auf Rezepte; Quelldatenbank bleibt unvollständig.
- Version beta.11; geplanter Nutzer-Branch fix/local-recipe-trainers ab f744a01.
- 42 fokussierte Routingfälle (30 neu + 12 bestehende) bestanden OHNE Blizzard-UI; drei fehlerhafte Varianten erkannt.
- Gaming-PC: 402/402 mit Blizzard-UI bestanden (188.39s, wowlua 0.13.14); beta.11 mit Backup installiert.
- Nächster Schritt: Korrekturpaket anwenden, Bericht prüfen und Donnerfels-Quelle im Spiel kontrollieren.


## Beta.12 — AH-Mengen und Performance, 15.11.2026

- Beta.10 f744a01 auf feature/net-vendor-costs veröffentlicht; beta.11 im Nutzerprojekt fix/local-recipe-trainers angewandt, noch kein Push belegt.
- Geprüfter Nutzerbericht CraftDeja-beta11-20261114-234149.zip: 402/402, 305 Dateien; zehn Quellhashes passen.
- Live beta.11: Mot in Donnerfels markiert, bietet Großer Magiezauberstab für 2s; gelernt und ein Craft 116 -> 117. Nutzer meldet flüssige Herstellung.
- Händlerwert/Brutto/Netto korrekt in gezeigten Beispielen; aktueller Essenzpreis 125c ergibt 288c - 200c = 88c netto.
- Neuer Nutzerfehler: manuelle AH-Menge wird auf 101 zurückgesetzt; Freeloader zeigt in einer Aufnahme 12.89 ms/frame für CraftDeja.
- Beta.12 korrigiert wiederholtes Setzen nativer Mengen, unnötige Ereignis-/Leerlauf-Vollprüfungen und wiederholte Zugangsabfragen pro Wirtschaftssnapshot.
- 25 neue Regressionen; alter Code 7 bestanden / 18 fehlgeschlagen, korrigierter Code 25/25. Camelot mit Blizzard-UI auf Linux, nicht Windows-Host oder Live-FPS-Test.
- Noch kein allgemeiner FPS-Erfolg im Spiel behauptet. Vollständige Regression und kurzer Mengen-/Profilercheck erforderlich; öffentliche Version bleibt beta.9.

- Abschließender beta.12-Gesamtlauf: 427/427, 306 Dateien, 141.38s; Build erfolgreich. Wowlua 0.13.12 auf Linux, Windows-Emulation mit Blizzard-UI. 15 Quellhashes geprüft.
- Der erste Gesamtlauf fand den Craft-Abbruch-Grenzfall (426/427); nach Korrektur AH+CraftPerformance 50/50 und vollständiger Lauf 427/427.
- Windows-Host-Lauf und echter AH-Profilervergleich stehen weiterhin aus. Updatepaket führt vor Spielinstallation automatisch den vollständigen Windows-Lauf aus.


## Verbindlicher Fortsetzungspunkt — 15.11.2026, nach beta.12-Live-Test

- Aktueller nutzerseitiger Stand: 3.9.0-beta.12 auf fix/local-recipe-trainers, Basis f744a01.
- Windowsbericht CraftDeja-beta12-20261115-003747.zip geprüft: 427/427, 306 Dateien, 197.37s, wowlua 0.13.14 mit Blizzard-UI; 15 Quellhashes passend; Installation mit Backup erfolgreich.
- Nutzer bestätigt: scheint alles zu laufen. Live-Bild zeigt Menge 5, Preis 124c, Gesamt 620c und passenden CTA. Profiler zeigt wesentlich kleinere momentane Last; kein kontrollierter allgemeiner Benchmark.
- Kein erneuter Testlauf für diese reine Sicherungs-/Dokumentationsrunde erforderlich.
- Jetzt Projektdateien, Belege und Fortsetzungsnotiz committen und auf denselben Feature-Branch pushen. Kein Merge nach main und kein CurseForge-Release in dieser Sicherungsrunde.
- Für neuen Chat zuerst CONTINUE.md, dann PROJECT_STATE.md, DECISIONS.md, ROADMAP.md, TEST_RESULTS.md und aktuellen Code lesen. Nicht alte Installations-/Patchpakete erneut anwenden.
- Nächste fachliche Priorität: einmalige Lern-/Rezept-/Voraussetzungskosten in der wirtschaftlichen Auswahl berücksichtigen; vorher konkreten Vergleichsfall definieren. Globales 1–300-Optimum, exakte Serverskillchancen, volle Rezeptabdeckung und AH-Verkaufserlöse bleiben unbewiesen/nicht implementiert.


## Beta.13 — einmalige Rezeptkosten, Entwicklungsstand 15.11.2026

- Nutzer-Sicherung extern bestätigt: f26799d auf fix/local-recipe-trainers frisch von GitHub gelesen. Neuer Arbeitsbranch feature/acquisition-costs.
- Version beta.13; neues Acquisition.lua. Bestätigte Trainergebühr über exakten Spell-/Enchant-Link, beobachtete Gebühr maximal 7 Tage, aktueller Rezeptgegenstandspreis bzw. vorhandenes Rezeptitem. Keine Namenszuordnung.
- Gebühr einmalig gegen Route aus bekannten Rezepten plus einem Kandidaten vergleichen; endlicher Horizont bis Grau/Skillcap, bei deaktiviertem Grün bis Grün. Kein globales Mehrrezeptoptimum.
- Unbekannte Gebühren bleiben unbekannt und führen zu CTA Lernkosten prüfen statt einer belegten Billiger-Aussage. Begrenzte Craft-/Cooldown-Kandidaten bleiben unbewertet. Werkzeug-, Reise-, Rangkosten fehlen weiterhin.
- 34 neue Fälle lokal mit Camelot und Blizzard-UI bestanden. Vollständiger finaler Lauf, Windows-Lauf und echte Trainergebührenbeobachtung noch prüfen.
- Beta.12-Craft-/AH-Performancegrenzen und manuelle Kaufmengen bleiben erhalten. Keine neuen regelmäßigen Trainer-/Marktscans.


Final beta.13 automated validation: build passed; 461 passed, 0 failed,
0 skipped (307 files), 143.22s. wowlua 0.13.12, camelot Windows emulation
on Linux with Blizzard UI. Report 20261114-235923-cabb11.zip checked; all
18 runtime source hashes match. At that Linux checkpoint Windows-host and real
trainer-link/fee observation were pending; see the verified Windows checkpoint
in CONTINUE.md / TEST_RESULTS.md. W1034 remains.

## Beta.14 — Abschlussprüfung am 15.11.2026

- Trainerfix-Commit: 014381f3cc8c5197e3e268b1a35c7418a371cc8f, Branch feature/acquisition-costs; Ausgangsarbeitsbaum sauber.
- Vorhandenen Windowsbericht 20261115-140332-96c718.zip erneut geprüft: Build erfolgreich, 485 bestanden, 0 fehlgeschlagen, 0 übersprungen, 204.91s. Alle 18 aufgezeichneten Quellprüfsummen exakt identisch.
- Code, Tests, Manifest/Lockfile und Testskript unverändert; diese Abschlussrunde aktualisiert nur Dokumentation. Kein neuer Testlauf erforderlich oder behauptet.
- Automatisierte Prüfung bestanden, Live-Prüfung der Lerngebühr bei Mot Dawnstrider noch offen.
- Nächste Installation mit Backup und festem _forever_-Ziel in docs/LIVE_TEST_BETA14.md vorbereitet; wowlua install-Optionen lesend geprüft. Kein eigenes Installationsskript vorhanden. Installation nicht ausgeführt, kein Merge nach main.
- Aktuellen Abschlusscommit mit git log -1 bestimmen; Remote-Gleichheit nach Push über git ls-remote origin refs/heads/feature/acquisition-costs prüfen.

## Mot-Live-Rückmeldung — 15.11.2026, Screenshots 18:27–18:30

- Nutzerprotokoll bestätigt beta.14-Sessionstart um 18:26:05, Client 1.60.1 / 70938 / 16001, deDE.
- Screenshot 182757 zeigt `7771 fee/source/at/now nil nil nil 1794763659`: zu diesem Zeitpunkt kein gespeicherter Gebührenbeleg für 7771. Spätere Rezeptdetails (183028/183032) melden weiterhin unbekannte Lern-/Rezeptkosten.
- Damit ist erfolgreiche Live-Erfassung nicht bestätigt. Kein neuer Erfolg aus automatisierten Tests ableiten. Die Screenshots zeigen außerdem keine Mot-Quelle unter den sechs Referenzquellen; Quellenliste und Gebührenbeobachtung sind getrennte Datenwege.
- Im gelieferten Log fehlt acquisition.trainer_observed; rohe Trainerereignisse und konkrete Ablehnungsgründe werden im aktuellen Code nicht protokolliert. Das Fehlen von TRAINER-Zeilen beweist deshalb nicht, dass kein Trainerfenster geöffnet wurde. Welche Identitäts-/Ambiguitätsprüfung ablehnt, ist noch unbekannt.
- Nächster Schritt: bei offenem Mot-Trainerfenster NPC-GUID, GetSpellInfo(7771)-Name/Rang sowie die echte Servicezeile (Name/Rang/Status/Kosten/Link) lesend erfassen. Danach den Unterschied als Regression nachstellen; keine Aufweichung der Zuordnung auf Verdacht.
- In dieser Auswertungsrunde nur Übergaben ergänzt, keine Codeänderung, kein erneuter Testlauf und keine Installation. Bestehende lokale Änderungen bleiben erhalten.
