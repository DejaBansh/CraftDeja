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
| Keine Rezeptzuordnung über Namensähnlichkeit | Trainerlink muss exakte Spell-/Enchant-ID liefern | beta.13-Beobachtung; fehlende Links bleiben unbekannt |

| Nil-Trainerlink als offenen Fehler erhalten | Mot Dawnstrider: Rezept 7771 / Gegenstand 6345, Link nil, gemeldete Gebühr 200 Kupfer; kein exakter Zuordnungsbeleg | separate Korrekturaufgabe; beta.14 noch nicht ausgeliefert oder installiert |
| Übergabe am tatsächlichen Git-/Teststand ausrichten | Branch, Commit, offene Änderungen und CONTINUE.md bei Beginn prüfen; Abschluss mit Änderungen, Nachweisen, Fehlern und nächstem Schritt | verbindlich in AGENTS.md |
