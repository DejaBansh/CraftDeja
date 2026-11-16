# Entscheidungen — Stand 15.11.2026

## beta.24 — 16.11.2026

- Ein aktiver Berufsauftrag hat Vorrang vor Händler-Sonderangeboten. Gifte benötigen Schurkenklasse und aktuelle native Freischaltung; gespeicherte Jobs, Level oder Händlerbestand genügen nicht. Keine erfundenen Quest-Abschluss-IDs.
- Auctionator-Liste nur über öffentliche APIs und nur unveränderte eigene Einträge synchronisieren. Keine automatische erneute Suche, keine Änderung manueller Kaufmengen; bei inkompatibler Liste ausdrücklicher Aktualisierungsklick.
- Letzte noch gültige AH-Preise bleiben nach AH-Schließen erhalten. Ältere Datenbankpreise dürfen keinen aktuellen Händlervergleich umkehren.
- Stationen nur aus nativen Erfüllt-Beobachtungen, exakt passende Anforderung und konservative Karte/Ebene/Instanz-Auswahl. Fehlende Daten sichtbar benennen. Keine fremden Classic-Koordinaten als verifizierte Forever-Standorte darstellen; kein Pathfinding behaupten.
- Wochenpflege von Händlerrezept-Referenzen ist eine externe Datenaufgabe mit Herkunftsprüfung, kein im Leerlauf laufender Komplettscan. Vorhandene 7-Tage-Lernkostengültigkeit ist kein globaler Händlerabgleich.


## CurseForge-Releases — 16.11.2026

- Nur exakte geprüfte Tags, getrennte versionierte DE/EN-Texte, passender tatsächlich veröffentlichter Kanal als Freigabebasis. Bei unklarer Provenienz kein Upload; Dry Run bleibt verfügbar.
- Offizielle Upload API für Datei/Markdown-Changelog. Keine dokumentierte Beschreibungs-Schreib-API: getrennt gemeldeter manueller Author-Console-Schritt mit unabhängigem description-only-Modus. Keine privaten Endpunkte oder vorgetäuschter Erfolg.
- Kein automatischer POST-Retry nach unklarem Upload; Datei-ID/Status unmittelbar separat sichern, GitHub-Re-Runs blockieren. Paket enthält eigene und importierte Lizenzen zusätzlich zur WoWLua-Komponentenliste.

## beta.23 — 16.11.2026

- Routenübersicht als großes Werkstattpult, NextStep als eigenständiger kompakter Guide. Originale Auftrags-/Preis-/Bank-/Lehrer-/Twink-/Gildenskripte beibehalten; zusätzliche Übersichten sind Projektionen, kein zweites Planungsmodell.
- Eigene Smoke-Glass-/Messing-/Goblin-Assets getrennt von realen UI-Werten. Bereitschaftseffekt einmalig und nur sichtbar; Warte-/Blockierzustände ruhig, keine neue permanente Aktualisierungsschleife. Alte Zusatzknöpfe müssen in den Details Platz finden.
- Dashboard-Klick bei veränderter Aktionsidentität aktualisiert zuerst die Anzeige. Auflösungsabnahme über echte Bildschirmmanifeste mit Hashnachweis; Quellemulation und noch offene Live-Grafik-/Addonkonfiguration klar unterscheiden.

## beta.22 — 16.11.2026

- Nächster bekannter geeigneter Lehrer aus ausdrücklicher Rezept-/Rangmitgliedschaft, Fraktion und vergleichbaren Standortdaten. Keine beliebigen Berufsmeister als Rezeptlehrer einsetzen; keine behauptete Vollständigkeit oder kürzeste Reisezeit. Gekappte/übernommene Referenzdaten transparent halten und eindeutige tatsächliche Besuche ergänzen.
- Native OnShow-/explizite OpenTradeSkill-Wege stellen Anzeige wieder her. Kein neuer Auftrag und kein zusätzlicher Vollscan allein durch den Wiederöffnungs-Hook. Minimap und native Addon-Kategorie als dauerhafte manuelle Zugänge, keine externe Bibliothek.

## beta.21 — 16.11.2026

- Die beta.20-Bankempfehlung wird auf ausdrücklichen Nutzerwunsch durch einen explizit gestarteten Containerauftrag ergänzt. Jede Menge anhand beider tatsächlichen Bestände bestätigen; Timeout ist kein Ablehnungsnachweis und erlaubt keine blinde Wiederholung. Nur persönliche Bank, keine Account-/Gildenbank. Aktuelle Craftzutaten behalten. Bankzugriff nicht an sichtbares Blizzard-BankFrame koppeln; TSM-Kompatibilität benötigt noch Live-Test.
- Händleranzeige als gespeicherte Option (Standard an), Anzeigeunterdrückung getrennt von Modell-/Inventarfortschritt. Berufsaufruf bleibt explizites Öffnen desselben Auftrags. Belege und Grenzen: docs/BANK_FLOW.md.

## beta.20 — 16.11.2026

- Auf Nutzerwunsch Route innerhalb eines Rezeptabschnitts festhalten; vollständiger Vergleich am Rezept-/Rangwechsel oder auf ausdrücklichen Auftrag, nicht nach jedem Preis-/Inventar-/Fortschrittsereignis. Laufende Suche nicht für normale Beobachtungen verwerfen. Neue Daten weiterhin vor Käufen/Herstellung prüfen; alte Vergleichskosten nicht als aktuelle Ersparnis darstellen.
- Bankempfehlung nur für tatsächlich in Taschen vorhandenen späteren Bedarf abzüglich bereits eingelagerter und aktuell benötigter Mengen. Keine automatischen Gegenstandsbewegungen; pro Abschnitt aufschiebbarer Hinweis. Belege: docs/ROUTE_CHECKPOINTS.md.

## Ergänzungen beta.19 — 16.11.2026

- Mehrrezept-Routen vergleichen vollständige gleiche Ziele mit gefrorenem Bestand/Preisstand. Begrenzte asynchrone Kandidatensuche, kein uneingeschränktes Globaloptimum. Fehlende Preise/Gebühren/Belege sind unbekannt, niemals kostenlos.
- Intermediate-Ausgaben werden je Stück reserviert; später verbautes Material erhält keinen Verkaufserlös. Zukauf, Lernen, Übergabe und wirtschaftlicher Verbrauchswert getrennt; Gebühren einmalig.
- Routenauftrag ist realm-/fraktionsgebunden kontoweit gespeichert; eigener Twink braucht eingelesenen Rezept-/Skillbeleg. Gilde bleibt opt-in, nur kanonische Metallruten/Salzstreuer, keine Bulk-Unteraufträge und keine Bestands-/Golddaten im Nachrichtenprotokoll.
- Gildenempfehlung benötigt bestätigte Konditionen/Zusage und einen streng günstigeren Vergleich. AH-Abwahl hält bis zum ausdrücklichen Reset, auch nach Reload/Preisupdate/Charakterwechsel.
- Kein unbewiesenes Trainer-Batchverfahren: ein frisch geprüftes Angebot pro Spieler-Klick, Erfolg erst nach Clientbeleg. Rangangebote nur über bekannte exakte IDs; Unbekanntes bleibt manuell/vorläufig.
- Originalauftrag und konkrete Abnahme: docs/tasks/MULTI_STAGE_ROUTE_REQUEST.md und docs/MULTI_STAGE_ROUTES.md. Automatisierung bestätigt keine Live-Übergabe zwischen Spielern oder tatsächliche FPS.

| Entscheidung | Begründung | Status |
|---|---|---|
| Wirtschaftlichkeit pro Skillpunkt ist Hauptziel | Anzahl Crafts allein misst Goldverbrauch nicht | beschlossen |
| Leichte Updates während Craft-Serien | schwere Scans können die Herstellung stören | implementiert |
| Vergleich als Schätzung kennzeichnen | Forever-Skillchancen nicht abschließend validiert | gültig |
| Netto-Kosten unter Verkaufsannahme | Materialkosten minus bestätigten Mindest-Händlerwert, geteilt durch erwarteten Skillgewinn | beta.10 implementiert; volle Windows-Regression bestanden (372/372) |
| Händler-Mindestwert vor optionalem AH-Erlös | Clientwert je Item × Mindestmenge; Einkauf bleibt brutto | beta.10 implementiert, Datenabhängigkeit beachten |
| Große fachliche Testsuiten | zusammenhängende Abläufe und Grenzfälle absichern | gültig |
| Beschreibung DE/EN, Goblinbild oben, Demo EN | Wiedererkennung und internationale Lesbarkeit | gültig |
| Keine Rankings oder Einsparungen ohne Vergleichsnachweis versprechen | auffindbar und überprüfbar statt unbelegt | gültig |
| Projektstand in Dateien/Git sichern | Gesprächskontext kann unvollständig verfügbar sein | auf main bei GitHub veröffentlicht (Basiscommit 19d8816); weitere Änderungen ebenfalls committen/pushen |
| Negative Nettokosten behalten | Erwartete Marge korrekt vorzeichenbehaftet; kein Gewinnversprechen | beta.10 implementiert, Null/Negativ-Vergleicher ohne Prozentersparnis |
| Jeder Windows-Testlauf erzeugt Bericht | Nutzer moechte direkt teilbare Ergebnisse statt Terminalkopien | tools/Test-CraftDeja.ps1; ZIP mit Protokoll/Metadaten, auch bei Fehlern |

| Rezepttrainer nur mit Rezeptbeleg ergänzen | Nähe und Berufsrang beweisen keine Lehrfähigkeit für ein konkretes Rezept | beta.11-Korrektur für 14807; Quelldaten weiter unvollständig |
| Quellenliste und Kartenwahl lokal ausrichten | Passende Fraktion, aktuelle Karte, dann vergleichbare Entfernung | beta.11 implementiert; 402/402 Windows geprüft, siehe TEST_RESULTS.md |

| Manuelle kleinere AH-Kaufmenge respektieren | Automatische Planmenge ist eine Vorbelegung, keine wiederholte Zwangseingabe | beta.12 implementiert; Kaufvalidierung bleibt |
| Unveränderten Zustand nicht voll neu einlesen | Ereignisse invalidieren Daten, Header-Poll fängt fehlende Skillmeldungen ab | beta.12 implementiert; reale FPS separat prüfen |

| Erwerbsgebühr einmalig gegen begrenzte Route prüfen | Billiger pro Craft rechtfertigt nicht jede Lerngebühr | beta.13-Entwicklung; ein Kandidat plus bekannte Alternativen |
| Fehlende Gebühren nicht als Null speichern | Quelle/Kosten erst prüfen; keine belegte Billiger-Aussage | beta.13-CTA Lernkosten prüfen |
| Keine Rezeptzuordnung über Namensähnlichkeit | Exakte Links bevorzugen; nil-Link nur mit belegter NPC/Rezept/Gegenstand-Beziehung, exakter Clientidentität und ohne Mehrdeutigkeit; Rang nur bei API mit Rangfeld | beta.15: beide Trainer-API-Layouts, C_Spell-Unterstützung; begrenzter Mot-Fallback 11071 / 7771 / 6345 |

| Mot-Nil-Link nur abgesichert zuordnen | NPC-GUID, Katalogbeziehung und Clientidentität müssen passen; doppelte Angebote/Spellidentitäten ablehnen, Livegebühr statt Festwert | beta.15 installiert; konkreter Livebeleg 7771 = 200 Kupfer / trainer am 15.11. bestätigt; keine allgemeine Trainerabdeckung behaupten |
| Übergabe am tatsächlichen Git-/Teststand ausrichten | Branch, Commit, offene Änderungen und CONTINUE.md bei Beginn prüfen; Abschluss mit Änderungen, Nachweisen, Fehlern und nächstem Schritt | verbindlich in AGENTS.md |

| Fehlende Rangfelder nicht erfinden | Forever liefert name/status/icon; bei ranglosen Angeboten sind gleiche Spellnamen immer mehrdeutig | beta.15 erkennt Status per Typ/Wert, C_Spell-Tabellen mit geprüfter Spell-ID; Legacy bleibt unterstützt |

| Bekannte Routenarbeit pro Snapshot teilen | Gleicher Skill/Punktgewinn hat denselben Folgeknoten; dominierte Kanten sind unnötig | beta.16; unabhängige Routenreferenz und vollständige Regression bestanden |
| Preis-Bursts pro Frame zusammenführen | Preise sofort speichern, nur finale Neuentscheidung einmal; explizite Aktionen synchron prüfen | beta.16; keine neue Zeitdrossel, keine Änderungen an manuellen Mengen |
| CPU-Diagnose nur auf ausdrücklichen Befehl | Bounded 30s, Originalhandler wiederherstellen, keine Nutzerdaten/Argumente | /cdj perf start / stop / show, standardmäßig aus |
| Performanceauftrag ohne Installation | Aktuelle ausdrückliche Nutzeranweisung hat Vorrang vor allgemeinem Auto-Installwunsch | beta.16 nur Quellbranch; beta.15 im Spiel unverändert |

| Unmögliche Kandidaten vor Wahrscheinlichkeit prüfen | Gleiche Auswahl, weniger unnötige Live-/Lookahead-Auswertungen; ungeprüfte Quellen getrennt erhalten | beta.17, 480 differenzielle Vergleiche und 520/0/0 |
| Metadateninteresse je Rezepttabelle indizieren | Keine wiederholte Vollsuche für jedes Gegenstandsereignis; bei readRecipes invalidieren | beta.17; Event-/Sitzungswechselregression bestanden |

| Einkaufsbedarf vom Materialverbrauch trennen | Eigener Bestand ist wirtschaftlich nicht wertlos; späterer Erlös bezahlt nicht den Einkauf davor | beta.18-Rezeptdetails, 529/0/0; unbekannter Bestand ausdrücklich markiert |
| Vollständige Route in begrenzten Stufen entwickeln | Lokaler Skillpunktpreis ist kein Beweis des günstigsten Gesamtziels | docs/PRODUCT_PLAN.md, zunächst bekannte Rezepte, später Erwerbs-/Ressourcenzustand |
