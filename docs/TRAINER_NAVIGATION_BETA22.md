# beta.22 — Trainerwahl und erneuter Zugriff

## Ausgangsstand und Belege

Sauberer Ausgangsbranch codex/bank-flow, Commit 2d94f64388827a977f76aa005242fcbe08fdc48c. Neue Arbeit lokal auf codex/trainer-navigation. Der Nutzerlog meldet Rezept 3924, NPC 2857, Karte 1454 um 19:29:38/44; der Nutzer war in Unterstadt. Die private Originaldiagnose wird nicht veröffentlicht.

Die ursprüngliche Entfernungslogik konnte bereits Lehrer auf derselben Karte bevorzugen. Die zugrundeliegenden Rezeptquellen waren jedoch Beispiele und enthielten für Kupferrohr keinen Unterstadt-Lehrer. Ein anderer Rang-Lehrer war absichtlich kein Nachweis für ein bestimmtes Rezept. Ein weiterer Fehlerpfad war reproduzierbar: Nach Guide-Schließen konnte das native Berufsfenster erneut OnShow auslösen, ohne TRADE_SKILL_SHOW zu senden. Der bisherige Guide reagierte darauf nicht. Ob genau dieser alternative Ereignispfad beim Nutzer auftrat, ist im begrenzten Log nicht vollständig aufgezeichnet; reproduziert und abgesichert ist der Clientvertrag.

Identischer Zweifalltest über öffentliche Client-Ereignisse: unveränderte beta.21, reports/navigation-ab/beta21/reports/tests/20261116-194730-f7ec47.zip, 0/2/0 mit den konkreten Fehlern falsche Stadt und Guide bleibt geschlossen. beta.22, reports/navigation-ab/beta22/reports/tests/20261116-194749-8ee7b6.zip, 2/0/0. Runtime-Dateien nicht im Reproduktionsprojekt verändert. Frühere A/B-Versuche mit fehlendem ADDON_LOADED-Bool bzw. Reporterinput sind keine Freigaben.

## Umsetzung

- Einheitlicher Standortvergleich für Rezeptquellen, Detailreihenfolge und Rang-Lehrer aller neun unterstützten Berufe. Spielerkarte aus GetBestMapForUnit, nicht aus der gerade gewählten Weltkarte. Mit gültigen Weltkoordinaten Entfernung innerhalb derselben Welt/ desselben Kontinents in vergleichbaren Yards. Sonst aktuelle Karte und vergleichbare lokale Koordinaten, danach deterministischer Fallback; keine erfundenen Entfernungen zwischen Kontinenten.
- 435 ausdrücklich rezeptbezogene Lehrerlisten aus dem bereits verwendeten MIT-ProfessionDB-1.9.1-Forever-Profil ergänzen die bisherigen Beispiele. Koordinaten werden ausschließlich über dieselbe NPC-ID aus vorhandenen Standortreferenzen ergänzt. Für Franklin Lloyd zusätzliche Unterstadt-Referenz 76,74; Kupferrohr-Mitgliedschaft separat auf der Forever-Rezeptseite belegt. Nicht aus Berufszugehörigkeit oder Rang abgeleitet.
- Tatsächliche Trainerbesuche speichern eindeutige, identifizierte Angebote einschließlich benutzter/gesperrter Angebote beim aktuellen Charakter. Fehlende/mehrdeutige IDs erzeugen keine Zuordnung. Ein neuer Besuch ersetzt den Angebotssnapshot. Standort ist die beobachtete Spielerposition beim Gespräch, keine genaue NPC-Vermessung. Keine Übertragung an andere Spieler oder Server.
- Explizite, bereits bekannte Rangidentitäten können beobachtete Standorte verwenden; für unbekannte Rangidentitäten keine Hochstufung eines bloßen Rezeptlehrers. Bestehende Rang-/Fraktions-/Buchvoraussetzungen bleiben erhalten.
- Native Berufsfenster bekommen je Instanz genau einen OnShow-Hook. Ein einzelner sicherer Posthook für OpenTradeSkill deckt erneutes explizites Öffnen eines bereits sichtbaren Berufs ab. Diese Anzeigewege öffnen den Guide, ohne dafür selbst einen vollständigen Rezeptscan zu starten. Bestehende reguläre Datenereignisse und Aufträge werden weiterverarbeitet.
- Minimap-Button: Linksklick öffnet Guide, Rechtsklick öffnet Einstellungen, Ziehen speichert Position. Kein dauerhafter OnUpdate; nur während des Ziehens. Ausblenden/Wiederanzeigen über den Addon-Eintrag möglich.
- Optionen → Addons → CraftDeja: Guide öffnen, Einstellungen öffnen, Händleranzeige und Minimap-Button schalten. Native Canvas-Kategorie mit Legacy-Fallback, keine externe UI-Bibliothek nötig. DE/EN-Texte, gespeicherte Optionen.

## Quellen und Grenzen

ProfessionDB 1.9.1: https://edge.forgecdn.net/files/9095/167/ProfessionDB-ProfessionDB-v1.9.1.zip

Archiv SHA256: 909CB41720CF6BF6920F1C25C644F89B39AD63087F589C07737E7DA943C52379. Sources.lua nennt ausdrücklich gekappte Listen mit maximal zwölf IDs und aus Classic-Nachfolgedatenbanken übernommene Metadaten. Diese sind Referenzen, keine live bestätigten Forever-Angebote. Reproduktion: tools/Update-TrainerMemberships.ps1 -ReferenceZip reports/professiondb-reference.zip. Keine neue Fremd-Runtime eingebunden; vorhandene MIT-Lizenz erhalten.

Kupferrohr mit Franklin Lloyd: https://www.wowhead.com/forever/spell=3924/copper-tube und https://www.wowhead.com/forever/npc=11031/franklin-lloyd. Standort quergeprüft als historische Referenz: https://foreverbase.org/en/db/npc/11031/ (76.1,74.0; gerundet 76,74 verwendet). Namen/Angebote/Positionen im Live-Client bestätigen.

Primäre technische Quellen: installierte Blizzard-UI 1.60.1.70938, MapDocumentation.lua (GetWorldPosFromMapPos), Blizzard_Settings_Shared/Blizzard_Settings.lua (RegisterCanvasLayoutCategory/RegisterAddOnCategory/OpenToCategory). App-Code selbst implementiert das Routing.

**Nächster belegter passender Lehrer** ist nicht gleich vollständig erfasster Lehrerbestand oder kürzeste Reisezeit. Datenlücken bleiben möglich. Keine pauschale Zusage, dass jeder Lehrer weltweit bekannt ist, jedes Referenzangebot aktuell verfügbar ist oder eine Luftlinie den kürzesten begehbaren Weg beschreibt. Insbesondere Instanzen, Tore, Transport und andere Kontinente haben kein vollständiges Reisekostenmodell. Keine neue FPS-Zusage.

## Prüfung und Live-Schritte

Neue NavigationSuite prüft Kupferrohr, alle neun Berufskataloge/Rangfilter, Detail-/Zielgleichheit, Weltentfernung einschließlich benachbarter Karte, eindeutige Beobachtungen, Guide-Wiederöffnung ohne schweren Scan, idempotente Einrichtung, Minimap-Klicks, gespeicherte Schalter und echte native Addon-Kategorie. UI wurde mit wowlua gerendert. Breite finale Ergebnisse und Quellhashes in TEST_RESULTS.md.

1. Nach Release-Installation /cdj version: beta.22. In Unterstadt Kupferrohr-Quelle öffnen: Unterstadt/Franklin Lloyd als nächster gespeicherter passender Lehrer, keine Orgrimmar-Zwangsauswahl. Angebot vor Ort prüfen; dessen eindeutige Identität/Standort wird anschließend beobachtet gespeichert.
2. Guide schließen, Berufsfenster schließen/öffnen und dasselbe Berufssymbol erneut anklicken. Guide öffnet, bestehender Auftrag und tatsächlicher Fortschritt bleiben erhalten. Mit Händleroption aus wiederholen.
3. Minimap links/rechts anklicken, verschieben, /reload und Position prüfen. Optionen → Addons → CraftDeja öffnen, Guide/Einstellungen/Schalter prüfen, Button aus- und wieder einblenden. DE/EN prüfen.
4. Stadtwechsel und anderer Beruf/Rang: lokale passende Quelle und Voraussetzungen prüfen. Nicht vorhandene oder zweifelhafte Referenzangebote mit konkretem Rezept-/NPC-/Rangbeleg melden. Live-Abnahme bleibt bis zu diesen Schritten offen.
