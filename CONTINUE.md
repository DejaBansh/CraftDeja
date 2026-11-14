# CraftDeja — hier fortsetzen / resume here

Stand: 15.11.2026, nach bestätigtem beta.12-Spieltest.

## Ausgangspunkt

- Besitzer: Tim / DejaBansh. Repository: https://github.com/DejaBansh/CraftDeja
- Gaming-PC: C:\Users\Tim\Projects\CraftDeja
- Branch: fix/local-recipe-trainers, bisherige Basis f744a01; aktueller Sicherungscommit ist nach Ausführung über git log -1 festzustellen.
- Version: 3.9.0-beta.12. main und öffentliches Addon-Release weiterhin beta.9. Nicht allein wegen einer Sicherung veröffentlichen/mergen.
- Installiert: C:\Program Files (x86)\World of Warcraft\_forever_\Interface\AddOns\CraftDeja
- Vor jeder Änderung aktuelle Dateien/Gitstatus lesen. Frühere Pakete nicht erneut anwenden.

## Fertig und belegt

- Beta.10: Netto-Ranking (Material minus bestätigter Mindest-Händlerwert) je erwartetem Skillpunkt; Einkauf bleibt brutto, vorhandene Materialien werden für Einkauf abgezogen.
- Beta.11: rezeptbezogene Mot/Teg-Quellen für Großer Magiezauberstab (14807); lokale passende Quellen zuerst. Kein pauschales Trainerwissen für alle Rezepte.
- Beta.12: manuelle kleinere AH-Mengen bleiben stehen; unveränderte native Ansicht wird nicht ständig neu beschrieben. Unpassende Ereignisse ignoriert, relevante coalesziert; Leerlaufpoll prüft Berufskopf. Craft-Abbruch setzt Prüfung fort.
- Windows wowlua 0.13.14 + Blizzard-UI: 427 passed, 0 failed, 0 skipped, 306 Dateien, 197.37s. Build und Installation erfolgreich, 15 Quellhashes geprüft.
- Nutzerbericht: CraftDeja-beta12-20261115-003747.zip. Live: Nutzer bestätigt funktionierenden Ablauf; Menge 5 und CTA 6s20c stimmen bei 124c/Essenz. Deutlich geringere beobachtete Profilerlast, kein kontrollierter Benchmark.
- W1034 in UnifiedUI.lua:37 bleibt als bekannte Buildwarnung.

## Regeln

AGENTS.md und DECISIONS.md beachten. Alle zukünftigen Tests über tools/Test-CraftDeja.ps1: automatisch ZIP mit Bericht, Protokoll, Metadaten, auch bei Fehlern. Breite passende Regressionen; während nativer Craftserien keine schweren Scans. DE/EN, Goblinstil, große grüne nächste Aktion und kleiner grauer Auftrag-ändern-Button bewahren. Automatische Levelmengen unter 300; Gift- und Produktionssonderfälle erhalten.

## Grenzen / nichts erfinden

Skillchancen Gelb/Grün sind Modellschätzungen. Keine global bewiesene 1–300-Optimalroute. AH-Verkaufserlöse nicht eingerechnet. Lern-/Rezept-/Werkzeugerwerbskosten bislang nicht in der wirtschaftlichen Auswahl. Vollständige Rezept-/Quellenabdeckung nicht belegt. Während laufender nativer Serie wird der schwere Marktvergleich verschoben. Spielaktionen benötigen weiterhin Nutzerklick.

## Nächster fachlicher Schritt

Einmalige Lern-, Rezept- und Voraussetzungskosten wirtschaftlich berücksichtigen. Mit klaren Vergleichsfällen beginnen: günstigeres unbekanntes Rezept lohnt sich nach wie vielen erwarteten Skillpunkten? Gebühren nicht je Craft mehrfach zählen; verfügbare Rezept-/Werkzeug-/Trainerbelege nutzen. Vorher AGENTS.md, PROJECT_STATE.md, DECISIONS.md, ROADMAP.md und TEST_RESULTS.md lesen.

## Neuer Chat

Diesem Chat Repository-Link und Branch geben und bitten:
„Lies CONTINUE.md und die dort genannten Projektdateien auf dem Branch fix/local-recipe-trainers. Prüfe den aktuellen Gitstand und arbeite von diesem Stand weiter. Keine alten Patches erneut anwenden.“

## Sicherung prüfen

Ein lokaler Commit ist noch kein externer Nachweis. Erst wenn git push erfolgreich war und git ls-remote denselben Commit für refs/heads/fix/local-recipe-trainers meldet, ist der Stand auf GitHub bestätigt. Das Sicherungsskript erstellt zusätzlich eine lokale Quell-ZIP, ein Git-Bundle und einen ZIP-Bericht. Keine Testergebnisse automatisch als Rohdaten hochladen.
