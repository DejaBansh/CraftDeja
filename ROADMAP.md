# Roadmap — Stand 14.11.2026

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
