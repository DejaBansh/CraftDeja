# Roadmap — Stand 15.11.2026

## Sichtbarkeit: erste Runde

- [x] Öffentliche CurseForge-Seite geprüft.
- [x] Beschreibung DE/EN mit frühem Kosten-pro-Skillpunkt-Nutzen überarbeitet.
- [x] Bereits veröffentlichte Goblinbild-/GIF-Adressen eingebunden.
- [x] Formel, Voraussetzungen und tatsächliche Grenzen ergänzt.
- [x] Dokumentierten Kostenabschnitt mit aktuellem Economy.lua/Run.lua abgeglichen.
- [x] Projektstand, Entscheidungen, Arbeitsregeln und Quellsicherung vorbereitet.
- [x] Beschreibung auf CurseForge laut Nutzer übernommen.
- [ ] Kurzbeschreibung und finale öffentliche Vorschau gesondert prüfen.
- [x] Öffentliches Repository mit Code, Lizenz/Attribution und Tests veröffentlicht (19d8816).
- [x] CurseForge Source-/Issues-Links laut Nutzer gesetzt.
- [x] GitHub-Vorabveröffentlichung v3.9.0-beta.9 mit installierbarer ZIP öffentlich geprüft.
- [x] Technische Tests sind im öffentlichen Repository enthalten.
- [x] README, Entwicklerdokumentation und Bug-/Feature-Vorlagen auf GitHub veröffentlicht (d3b0217).
- [ ] Community-Beitrag mit echter Aufnahme veröffentlichen, sobald passender Kanal und Regeln geprüft sind.
- [ ] Rückmeldungen zu Beruf, Skill, Empfehlung, Preisdatum und Clientbuild erfassen.

## Wirtschaftlichkeit: nächste Entwicklungsrunde

- [x] Händler-Verkaufswert und bestätigte Mindestmenge im beta.10-Entwicklungspatch aufgenommen; voller Windows-Lauf: 372/372 bestanden.
- [x] Unknown/BoP/Verzauberungen/Mehrfachausgabe/negative Nettokosten implementiert und gezielt geprüft; volle Windows-Regression bestanden.
- [ ] Lern-, Rezept- und Voraussetzungskosten einmalig verrechnen; keine Doppelzählung.
- [ ] Optionalen AH-Erlös separat und als unsicher kennzeichnen, inklusive Gebühren/Verkaufsrisiken.
- [ ] Materialbesitz: zusätzlicher Goldbedarf vs wirtschaftlicher Marktwert ausdrücklich unterscheiden.
- [ ] Komplette Route einschließlich Zwischenprodukten gegen unabhängige Referenzfälle prüfen.
- [ ] Forever-Skillwahrscheinlichkeiten mit tatsächlichen Versuchen/Skillanstiegen und Unsicherheit validieren.

## Prüfmaßstab

Keine festen Einsparungsprozente oder beste-Route-Aussagen ohne gleiche Startbedingungen,
Preise, Rezepte, Skillchancen und reproduzierbaren Ergebnisvergleich.
Sichtbarkeit messen an echten Rückmeldungen und Nutzung, nicht nur einer KI-Rangfolge.


## Reproduzierbare Belegfälle — 14.11.2026

- [x] 20 synthetische Wirtschaftsfälle mit realem Economy.lua geprüft (isoliert, Lua 5.1).
- [x] Vier absichtlich fehlerhafte temporäre Varianten durch Tests erkannt.
- [x] Zweisprachige Belegseite mit Inputs, Resultaten und Prüfgrenzen vorbereitet.
- [x] Neue Fälle auf dem Gaming-PC mit wowlua/Blizzard-UI ausgeführt: 20/20 bestanden, 4.99s (14.11.2026).
- [x] Beta.9-Belegfälle und Windows-Ergebnis auf GitHub veröffentlicht (711d463).
- [ ] Automatische Eventverarbeitung und native Serien weiterhin getrennt von Modulbelegen validieren.


## Beta.10-Freigabe

- [x] 50 Netto-Kostenfälle und 37 bestehende Wirtschaftsfälle im minimalen Testprojekt bestanden.
- [x] Sechs absichtlich defekte Varianten erkannt.
- [x] Vollständiger wowlua-Build und alle 372 Tests mit Blizzard-UI auf dem Gaming-PC bestanden (195.46s).
- [ ] Händlerwerte und wechselnde Ausgabemengen im Livespiel stichprobenartig prüfen.
- [ ] Beta.10 nach geprüften Ergebnissen committen, installierbar bauen und veröffentlichen.


## Integrationsfix und Berichtswunsch

- [x] Ersten kompletten Windows-Lauf ausgewertet: 369/372, drei Fehlschlaege.
- [x] Gifte-Wrapper-Fehler lokal reproduziert und korrigiert; fokussiert 87/87 mit Wrapper bestanden.
- [x] Automatische ZIP-Berichte fuer kuenftige Windows-Laeufe implementiert und fuer Erfolg, Testfehler und Startfehler geprueft.
- [x] Korrigierten kompletten Windows-Lauf anhand des ZIP-Berichts verifiziert: 372/372, Quellhashes abgeglichen.


## Beta.11 — Rezeptlehrer-Routing

- [x] Fehlende Donnerfels-Quellen für Zauberstab 14807 identifiziert und belegt ergänzt.
- [x] Quellenliste priorisiert aktuelle Karte / vergleichbare lokale Entfernung, ohne Fraktionsschutz zu lockern.
- [x] 30 neue + 12 vorhandene Routingfälle lokal bestanden; drei fehlerhafte Varianten erkannt.
- [x] Vollständige 402 Tests mit Blizzard-UI auf Gaming-PC prüfen.
- [x] Quelle/Marker und tatsächliches Zauberstab-Angebot bei Mot in Donnerfels im Spiel bestätigt.
- [ ] Quellenabdeckung weiterer Rezepte anhand konkreter Belege erweitern; keine pauschale Trainerzuweisung.


## Beta.12 — AH-Mengen und Performance

- [x] Live-Fehler aus Screenshot und Diagnose eingegrenzt; keine weiteren Materialkäufe für die Fehlersuche erforderlich.
- [x] Manuelle kleinere Kaufmenge und leeres Eingabefeld erhalten; native Statusabfrage ohne wiederholte UpdateView-Aufrufe.
- [x] Unpassende Ereignisse herausfiltern, Debounce vor Aushungern schützen, Leerlauf nur Berufskopf prüfen.
- [x] 25 Regressionen mit tatsächlichen Modulen; 18 Fehler am alten Code nachgestellt.
- [x] Vollständiger beta.12-Camelot-Lauf: 427/427, 306 Dateien, 141.38s; Bericht geprüft.
- [x] Windows-Gesamtlauf 427/427 (197.37s) und Installation mit Backup bestätigt.
- [x] Nutzer bestätigt funktionierenden Live-Check; Screenshot Menge 5, CTA 6s20c, geringe momentane Profilerlast. Kein kontrollierter Benchmark.
- [ ] Änderungen nach erfolgreichem Abschluss committen/pushen.


## Sicherung und Fortsetzung

- [x] CONTINUE.md mit exaktem Stand, Grenzen und nächstem Arbeitsschritt erstellt.
- [ ] Sicherungscommit und Push auf fix/local-recipe-trainers durch Nutzer-PC-Skript; erst nach Remote-Prüfung als extern gesichert melden.
- [ ] Danach Lern-/Rezept-/Voraussetzungskosten anhand definierter Belegfälle entwickeln.


## Beta.13 — einmalige Rezeptkosten

- [x] Sicherungscommit f26799d öffentlich verifiziert, isolierter Entwicklungsbranch.
- [x] Exakte beobachtete Trainergebühr, Rezeptgegenstandspreis/Bestand und unbekannten Status trennen.
- [x] Einmalzahlung gegen begrenzte Route mit bekannten Alternativen prüfen, nicht je Craft addieren.
- [x] 34 fokussierte Fälle mit realen Modulen/vertraglichen Trainerfixtures bestanden.
- [x] Finaler Gesamtlauf mit aktueller Quelle: 461/461, 307 Dateien, 143.22s; 18 Quellhashes geprüft.
- [x] Windows-Gesamtlauf anhand 20261115-010908-b537ed.zip geprüft: 461/0/0, 212.88s; alle 18 Quellprüfsummen identisch.
- [ ] Beta.13-Installation mit Backup gesondert belegen; diese Übergaberunde verändert die Spielinstallation nicht.
- [x] Nutzer-Livefall dokumentiert: Mot Dawnstrider, Rezept 7771, Rezeptgegenstand 6345, Trainerlink nil, Lerngebühr 200 Kupfer.
- [x] Mot-Nil-Link-Fehler in beta.14 abgesichert korrigiert; finaler Windows/Camelot-Lauf 485/485, siehe unten.
- [ ] Reale erfolgreiche Zuordnung bei Mot nach separat beauftragter Installation bestätigen.
- [ ] Werkzeug-/Reise-/Ranggebühren und mehrere unbekannte Rezepte gemeinsam modellieren.

## Übergabe beta.13 (historisch)

- [x] Vorhandenen Windowsbericht und alle 18 aufgezeichneten Quellhashes geprüft; lokales Backup mit geprüftem Git-Bundle erstellt.
- [x] CONTINUE.md und AGENTS.md für gemeinsame Weiterarbeit aktualisiert.
- Beta.14 wurde noch nicht ausgeliefert oder installiert. Main und Spielinstallation bleiben unverändert. Frühere Sicherungsaufgaben oben sind historische Einträge; aktueller Branch feature/acquisition-costs.
- Commit/Push und Remote-Gleichheit erst anhand der tatsächlichen Git-Ausgabe bestätigen; aktueller Sicherungscommit über git log -1.

## Beta.14 — abgesicherte Mot-Nil-Link-Zuordnung

- [x] Link-only-Ursache im aktuellen Acquisition.lua bestätigt; belegte Beziehung NPC 11071 / Rezept 7771 / Gegenstand 6345 abgesichert ergänzt.
- [x] Exakte Clientnamen/Ränge, NPC-GUID und Katalogbeziehung prüfen; doppelte Angebote und Spellidentitäten ablehnen. Keine Namensähnlichkeit oder festgeschriebene Gebühr.
- [x] 24 neue Regressionen für Erfolg, Mehrdeutigkeit, fehlende Daten, DE/EN und native Craft-Sperre.
- [x] Finaler Build und Windows/Camelot-Gesamtlauf mit Blizzard-UI: 485/0/0, 308 Dateien, 204.91s. ZIP 20261115-140332-96c718; alle 18 aufgezeichneten Quellhashes exakt geprüft.
- [x] CONTINUE.md, PROJECT_STATE.md, DECISIONS.md und TEST_RESULTS.md aktualisiert.
- [ ] Live-Erfassung der gemeldeten 200 Kupfer bei Mot bestätigen; keine Installation in dieser Runde.
- Weitere Trainer erst nach eigenen Belegen; main und Spielinstallation bleiben unverändert, kein Addon-Release. Commit/Remote-Gleichheit anhand Git prüfen.

## Beta.14 — Abschlussprüfung am 15.11.2026

- Trainerfix-Commit: 014381f3cc8c5197e3e268b1a35c7418a371cc8f, Branch feature/acquisition-costs; Ausgangsarbeitsbaum sauber.
- Vorhandenen Windowsbericht 20261115-140332-96c718.zip erneut geprüft: Build erfolgreich, 485 bestanden, 0 fehlgeschlagen, 0 übersprungen, 204.91s. Alle 18 aufgezeichneten Quellprüfsummen exakt identisch.
- Code, Tests, Manifest/Lockfile und Testskript unverändert; diese Abschlussrunde aktualisiert nur Dokumentation. Kein neuer Testlauf erforderlich oder behauptet.
- Automatisierte Prüfung bestanden, Live-Prüfung der Lerngebühr bei Mot Dawnstrider noch offen.
- Nächste Installation mit Backup und festem _forever_-Ziel in docs/LIVE_TEST_BETA14.md vorbereitet; wowlua install-Optionen lesend geprüft. Kein eigenes Installationsskript vorhanden. Installation nicht ausgeführt, kein Merge nach main.
- Aktuellen Abschlusscommit mit git log -1 bestimmen; Remote-Gleichheit nach Push über git ls-remote origin refs/heads/feature/acquisition-costs prüfen.
