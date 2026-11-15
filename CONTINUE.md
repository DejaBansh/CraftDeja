# CraftDeja — hier fortsetzen / resume here

Stand: 15.11.2026, beta.13-Quellstand und vorhandenen Windowsbericht geprüft.

## Arbeitsbasis

- Projekt: C:\Users\Tim\Projects\CraftDeja
- Repository: https://github.com/DejaBansh/CraftDeja
- Branch: feature/acquisition-costs; Ausgangscommit f26799d1a383d3c4e6280bc9c36aa3fb32c34001 (beta.12).
- Aktuellen Sicherungscommit mit git log -1 feststellen; Remote-Nachweis mit git ls-remote origin refs/heads/feature/acquisition-costs vergleichen. Nicht aus älteren Notizen ableiten.
- Lokale Entwicklungsversion: 3.9.0-beta.13 in src/Start.lua und wowlua.json. Root-TOC beta.4 ist ein Altbestand; installierbare TOC wird generiert.
- Main und Spielinstallation werden in dieser Übergaberunde nicht verändert. Kein Addon-Release. Beta.14 wurde noch nicht ausgeliefert oder installiert.
- Vor Arbeitsbeginn AGENTS.md, diese Datei, PROJECT_STATE.md, DECISIONS.md, ROADMAP.md, TEST_RESULTS.md und aktuellen Gitstatus lesen. Frühere Pakete nicht erneut anwenden.

## Änderungen und Belege

- Beta.13: Acquisition.lua beobachtet exakte Spell-/Enchant-Trainerlinks und einmalige Gebühren; berücksichtigt Rezeptgegenstandspreis bzw. Bestand. Begrenzter Vergleich eines unbekannten Kandidaten mit bekannten Rezepten, keine vollständige 1–300-Optimierung.
- Unbekannte Gebühren bleiben unbekannt; CTA Lernkosten prüfen. Werkzeug-, Reise- und Rangkosten fehlen weiterhin. Keine Namenszuordnung als Rezeptbeweis.
- Windowsbericht reports/tests/20261115-010908-b537ed.zip gelesen: beta.13, wowlua 0.13.14, Blizzard-UI, Build bestanden; 461 bestanden, 0 fehlgeschlagen, 0 übersprungen, 307 Dateien, 212.88 Sekunden. Alle 18 aufgezeichneten SHA256-Quellprüfsummen stimmen exakt mit dem aktuellen Code überein.
- Bericht entstand auf Basis f26799d mit damals uncommittierten beta.13-Dateien. Er belegt den geprüften Quellstand, nicht einen bereits bestehenden beta.13-Commit.
- Kein neuer Testlauf in der Übergaberunde: Laufzeitcode unverändert, vorhandener Windowsnachweis passt. W1034 in UnifiedUI.lua:37 bleibt bekannt.
- Git 2.56.0.windows.4; wowlua 0.13.14 unter C:\Users\Tim\.wowlua\bin\wowlua.exe vorhanden. Bei Bedarf .wowlua\bin zum PATH der aktuellen Shell hinzufügen; tools/Test-CraftDeja.ps1 erledigt dies selbst. Keine dauerhafte PATH-Änderung nötig.
- Lokales Backup vor Übergabeänderungen: reports/backups/beta13-before-handoff-20261115-134230/ mit Arbeitsbaum-ZIP, geprüftem Git-Bundle, Windowsbericht und Ausgangsstatus. Berichte/Backups bleiben lokal und ignoriert.

## Offener Trainerfehler — nächste separate Aufgabe

Vom Nutzer berichteter Live-Fall: Mot Dawnstrider, Rezept 7771, Rezeptgegenstand 6345, Trainerlink nil, Lerngebühr 200 Kupfer.
Beta.13 erkennt Gebühren nur über exakte Spell-/Enchant-Links. Bei nil kann die beobachtete Gebühr dem Rezept nicht zugeordnet werden. Die gemeldeten 200 Kupfer sind kein erfolgreich gespeicherter Erwerbskostenbeleg. Dieser Fehler ist offen; hier keine Korrektur vorgenommen. Beta.14 wurde noch nicht ausgeliefert oder installiert.

Nächster Schritt: Trainerfall gezielt reproduzieren und sichere Rezept-/Gebührenzuordnung prüfen; erst als separate Aufgabe korrigieren und über tools/Test-CraftDeja.ps1 breit testen. Keine bloße Namensähnlichkeit als Beweis verwenden.

## Dauerhafte Grenzen und Übergabe

Beta.12-AH-Mengen-/Craft-Performancegrenzen, DE/EN, konkrete grüne CTA, kleiner grauer Auftrag-ändern-Button, automatische Levelmengen unter 300 sowie Gift-/Produktionssonderfälle erhalten. Keine schweren Vollscans während nativer Serien. Spielaktionen benötigen Nutzerklick. Skillwahrscheinlichkeiten sind Modellschätzungen; AH-Verkaufserlöse und vollständige Quellenabdeckung sind nicht belegt.

Bei Abschluss diese Datei mit Änderungen, Testnachweisen, offenen Fehlern und nächstem Schritt aktualisieren. Commit/Push allein ist kein Remote-Nachweis; vollständige Commit-ID und Remote-Ref vergleichen. Rohberichte nicht automatisch veröffentlichen.
