# Entscheidungen — Stand 15.11.2026

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
