# CraftDeja — hier fortsetzen / resume here

Stand: 15.11.2026, beta.14-Trainerkorrektur automatisiert geprüft.

## Arbeitsbasis

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
