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
