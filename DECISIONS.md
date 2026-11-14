# Entscheidungen — Stand 14.11.2026

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
