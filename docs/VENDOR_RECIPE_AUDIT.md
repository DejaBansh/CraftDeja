# Händlerrezepte — Intervallprüfung vom 16.11.2026

## Tatsächlicher Addonstand

Es gibt keinen wöchentlichen Gesamtabgleich. `Run.lua` verarbeitet `MERCHANT_SHOW` und `MERCHANT_UPDATE`; `Client.observeMerchant` liest dabei die gerade verfügbaren Händlerzeilen und speichert beobachtete Stückpreise mit Zeitstempel. `Merchants.recordMerchant` speichert Standorte, unlimitierte Angebote und separat die beim Besuch tatsächlich kaufbaren Rezeptgegenstände. Das ist ein Besuchsabgleich, kein vollständiges Verzeichnis aller Rezeptangebote. Limitierte Angebote und erweiterte Kosten sind keine verlässlichen unlimitierten Kupferpreisquellen.

`Client.vendorPrice` verwendet gespeicherte unlimitierte Preise ohne Sieben-Tage-Ablauf. `Acquisition.acquisitionQuote` hat dagegen eine Gültigkeit von 604800 Sekunden für beobachtete **Lern-/Erwerbskosten**. Das löst keinen Netzabruf und keinen erneuten Händlerbesuch aus. Rezeptquellen im ausgelieferten Katalog stammen aus versionierter Referenzpflege.

Am 23.11.2026 wurden die rezeptbezogenen Händler-, Drop- und Questdaten aus OneForAll Forever in den lokalen beta.27-Kandidaten übernommen. Grundlage, Lizenz, Commit und Importbefehl stehen in [DATA_SOURCES.md](../DATA_SOURCES.md). Ein Rezeptverkäufer in dieser Referenz ist kein Beleg für momentane Verfügbarkeit oder einen Kaufpreis.

## Neuer Referenzstand gefunden

Die dokumentierte Importbasis ist ProfessionDB 1.9.1, Snapshot vom 10.11.2026. Die offizielle Projektseite und Dateiseite führen jetzt **ProfessionDB 1.10.1**, Datei **9653856**, vom 16.11.2026, einschließlich Forever 1.60.1:

- https://www.curseforge.com/wow/addons/libprofessiondb
- https://www.curseforge.com/wow/addons/libprofessiondb/files/9653856

Nach den dortigen Entwicklerangaben wurden unter anderem neue native Forever-Lehrerbeobachtungen und Allianz-Rezepthändler aufgenommen. Ein Teil der neuen Preise besteht aus Merchant's Favor (Währungs-ID 3402), nicht Kupfer. Horde-Aufnahmen sind ausdrücklich noch unvollständig; viele andere Quellen bleiben als aus Vanilla übernommen markiert. Ein Update ist deshalb ein prüfbarer Daten-Diff, keine pauschale Bestätigung aller Quellen. Die Angaben wurden auf den primären Upstream-Projektseiten geprüft; das neue Archiv wurde in diesem Auftrag noch nicht importiert oder vollständig auditiert.

## Sinnvoller wöchentlicher Ablauf

1. Außerhalb des Spiels einmal pro Woche die aktuelle offizielle Forever-Referenzversion prüfen; Downloadversion, Hash, Lizenz, Clientbuild und Herkunft festhalten.
2. Rezept-, Quellen-, Fraktions-, Kosten- und Entfernungsänderungen gegenüber dem letzten freigegebenen Snapshot als Diff erzeugen. Gelernte native Beobachtungen und Korrekturen nicht blind überschreiben.
3. Ausleihdaten weiter als unbestätigt markieren. Währungs-/Itemkosten von Kupferkosten trennen; fehlende Modellunterstützung bleibt unbekannt, niemals Nullkosten oder ein normaler Goldkauf.
4. Änderungen gezielt und mit breiter WoWLua-Suite prüfen, danach im nächsten Addon-Release ausliefern.
5. Im Spiel besuchte Händler weiter ereignisbezogen erfassen; gegebenenfalls eine ruhige Erinnerung für alte Daten anbieten. Kein wöchentliches Abfragen ungeöffneter Händler und keine wiederkehrenden vollständigen Scans im Leerlauf.

Dieser Ablauf ist eine **Empfehlung/offene Umsetzung**, noch kein eingerichteter Wochenjob. beta.24 enthält den separat geprüften Guidefix und die Giftfreischaltung; seine versionierten Release-Texte und sein Tag werden für diesen späteren Datenauftrag nicht verändert.
