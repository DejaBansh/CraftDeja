# CraftDeja — hier fortsetzen / resume here

Stand: 15.11.2026, beta.15 automatisiert geprüft; im Spiel weiterhin beta.14, Mot-Live-Test offen.

## Beta.15 — bestätigter API-Unterschied und Korrektur, 15.11.2026

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
