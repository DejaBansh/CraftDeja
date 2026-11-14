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

- Codeversion app.release und wowlua.json: 3.9.0-beta.9.
- Öffentliches Quellrepository: https://github.com/DejaBansh/CraftDeja ; im aktuellen Arbeitsdurchlauf frisch geklont.
- Aktuelles Nutzerprojekt auf dem Gaming-PC: C:\Users\Tim\Projects\CraftDeja. Anderer PC historisch: C:\Users\gv_co\Projects\CraftDeja-Aktuell\CraftDeja.
- Spielordner: C:\Program Files (x86)\World of Warcraft\_forever_\Interface\AddOns\CraftDeja.
- Gaming-PC: Branch main, origin https://github.com/DejaBansh/CraftDeja.git ; erster veröffentlichter Commit 19d881608c377e26c74415ed1b3f12ae7f2d5b52. setup/wowlua und dc914c0 gehören zum älteren PC-Verlauf.
- Nicht zum alten Projekt C:\Users\gv_co\Projects\CraftDeja mit 3.8.0 zurückwechseln.
- Gaming-PC: Git 2.56.0.windows.4, wowlua 0.13.14; Build und 302 Tests erfolgreich. Früherer PC: wowlua 0.13.12. UTF-8 ohne BOM für JSON/Tests beachten.
- Addon-ZIP CraftDeja_3.9.0-beta.9_Logo_CurseForge.zip: einzelner CraftDeja/-Hauptordner, geprüfter Logo-Pfad Art/Logo.tga, CRC bestanden.
- Die Release-TOC trägt generierten Versionssuffix -alpha; app.release ist 3.9.0-beta.9. Das vor der nächsten Veröffentlichung bewusst vereinheitlichen.
- Logo in der generierten TOC geprüft. Manifestfeld addon.icon-texture verwenden; IconTexture unter toc-extra verursacht E4002. Im veröffentlichten wowlua.json korrigiert.
- Die alte Root-TOC im Quellbaum ist ein Adoptierungsrest. Installierbare TOC aus wowlua erzeugen; nicht die Quellstruktur direkt als Release hochladen.

## Implementiert, anhand aktueller Quelldateien geprüft

- Economy.lua: quote.cost / (p × erwartete Punkte), Vergleich bekannter und verwertbarer unbekannter Rezepte.
- Vorhersage wirtschaftlicher Rezeptwechsel. Erwartete Versuche getrennt von sicher vorbereiteter Serienmenge.
- Grün standardmäßig aktiviert; gespeicherte Einstellungen können abweichen.
- Run.lua: Skill-/Inventarereignisse; während laufender Serie leichte Fortschrittsaktualisierung, schwere Vergleiche verschoben.
- Inventory-/Einkaufs-/Posthilfe, Arbeitsstätten-/Werkzeughinweise, Kartenquellen, Ruten-Zwischenaufträge, Giftplanung.
- Alle diese Funktionen weiterhin datenabhängig; keine vollständige Abdeckung aller Spielrezepte behaupten.

## Noch NICHT implementiert / nicht bewiesen

- Händler- oder AH-Verkaufserlöse in der wirtschaftlichen Rezeptauswahl abziehen.
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
- Heute nur Dokumentation/Verpackung geändert, keine Lua-Spielmechanik. ZIP-Integrität, Quellsnapshot-Hashes und Dokumentkonsistenz prüfen.

## Dauerhafte Sicherung und Weiterarbeit

1. Diesen Quellstand und Projektdateien zusätzlich im tatsächlichen Nutzer-Git-Repository versionieren; kein fremdes .git überschreiben.
2. Gitstatus/Diff prüfen und bewusst committen. Ein lokaler Commit ist kein externes Backup; Remote oder zweite Sicherung verifizieren.
3. Bei neuem Chat PROJECT_STATE.md, DECISIONS.md, ROADMAP.md und aktuelle Quelldateien bereitstellen.
4. Zu Beginn Stand/Versionsnummer prüfen; vor jeder Veröffentlichung dokumentierte Aussagen gegen Code und Testergebnis abgleichen.
5. Nach einer Runde Änderungen, Testergebnisse, offene Punkte und nächste Aktion in diesen Dateien aktualisieren.
6. Nur installierbare ZIP mit CraftDeja/-Hauptordner zu CurseForge; dieses Arbeits-/Sicherungspaket gehört NICHT in den Addon-Upload.

## Nächste technische Priorität

Netto-Kosten mit garantiertem Händlererlös, anschließend einmalige Lern-/Voraussetzungskosten.
Vorher Tests für Orange-vs-Grün mit Verkaufswert, Ausgabemenge, unbekannten Preisen, nicht verkäuflichen Ergebnissen und Skillcap definieren.

## Sichtbarkeit — GitHub-Startseite vorbereitet am 14.11.2026

README DE/EN mit echtem Goblinbild/GIF, Installation und aktuellen Grenzen neu aufgebaut.
docs/DEVELOPMENT.md und Bug-/Feature-Vorlagen ergänzt; docs/ALGORITHM.md aktualisiert.
Keine Lua-, Artwork-, Manifest- oder Versionsänderungen in dieser Runde. Dokumentlinks und Patch-Anwendung prüfen;
kein erneuter 302-Testlauf für reine Dokumentation behaupten.
CurseForge Source/Issues wurden laut Nutzer gespeichert; deren öffentliche Anzeige konnte hier nicht unabhängig abgerufen werden.
Der neue Dokumentationscommit ist erst nach Anwendung und Push auf dem Nutzer-PC veröffentlicht.

Nächster Schritt: GitHub-Patch anwenden/committen/pushen, About-Text und Topics setzen, dann Netto-Kostenentwicklung.
