# CraftDeja — verbindlicher Projektstand

Stand: 14.11.2026. Dies ist ein Arbeitsstand aus Dateien und sichtbarem Gespräch, kein vollständiges Chat-Transkript.
Vor Änderungen aktuellen Code und diese Notizen prüfen. Kein Gedächtnis ersetzt Versionskontrolle.

## Ziel und Produktentscheidungen

- Tim entwickelt CraftDeja für WoW Forever 1.60.1 / Interface 16001; DE und EN.
- Hauptziel: möglichst geringe Goldkosten beim Berufsleveln. Kleine Anzeige mit genau einer klaren nächsten Aktion.
- Große grüne primäre CTA; kurze konkrete Texte. Auftrag ändern klein und grau. Weitere Details in Tooltips/Ansichten.
- Arbeitsstätten konkret nennen: Kochstelle, Amboss, Schmiede, Schmelzofen, Alchemielabor usw., anhand der tatsächlichen Rezeptanforderung.
- Werkzeuge, Voraussetzungen und Ruten als Arbeitsschritte berücksichtigen; ein vorhandener Schritt bedeutet nicht, dass seine Erwerbskosten bereits in der Rezeptbewertung stecken.
- Automatische Planmenge unter 300. Eigene Stückzahlen für Gifte und Produktion ab 300 erhalten.
- Größere fachliche Testsuiten statt ständig einzelner Kleinsttests. Qualität vor Tempo.
- Goblinstil bewahren. Beschreibung und Patchnotes DE/EN. Goblinbild zuerst, nicht riesig. Demo-Einblendungen EN, Originalspielaufnahme DE.

## Aktueller Stand

- Entwicklungsversion app.release und wowlua.json: 3.9.0-beta.10. Öffentlich veröffentlichte Addon-ZIP weiterhin beta.9.
- Öffentliches Quellrepository: https://github.com/DejaBansh/CraftDeja ; im aktuellen Arbeitsdurchlauf frisch geklont.
- Aktuelles Nutzerprojekt auf dem Gaming-PC: C:\Users\Tim\Projects\CraftDeja. Anderer PC historisch: C:\Users\gv_co\Projects\CraftDeja-Aktuell\CraftDeja.
- Spielordner: C:\Program Files (x86)\World of Warcraft\_forever_\Interface\AddOns\CraftDeja.
- Gaming-PC aktuell: Branch feature/net-vendor-costs, Basis 711d463, beta.10-Aenderungen noch nicht committed. origin https://github.com/DejaBansh/CraftDeja.git ; erster veröffentlichter Commit 19d881608c377e26c74415ed1b3f12ae7f2d5b52. setup/wowlua und dc914c0 gehören zum älteren PC-Verlauf.
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

## Nächste technische Priorität

Beta.10-Netto-Kosten vollständig auf dem Gaming-PC prüfen, anschließend einmalige Lern-/Voraussetzungskosten.
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
