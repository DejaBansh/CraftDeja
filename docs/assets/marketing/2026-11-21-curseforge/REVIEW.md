# CraftDeja auf CurseForge

## Prüfstand, 21. November 2026

- Öffentliches Referenzpaket 3.9.0-beta.26 für Forever 1.60.1 (TOC 16001), CurseForge-Datei-ID 9722537, Git-Tag v3.9.0-beta.26, Commit e6cb2909067f41ebc2e3e9def59e3c0274c58606. SHA-256 des geprüften ZIPs F4873231D36A064EFA2CE74A8CD017796ABB527128E9952E84EDF68C06F88F58.
- Die öffentliche Seite zeigte die bisherige zweisprachige Beschreibung zu Levelrouten, Rezeptquellen und Auctionator. Die Hauptseite zeigte als Standard-Download die ältere, als Release eingestufte beta.18. Die neue Copy bezieht sich auf die separat veröffentlichte Beta.26. Wenn der Standard-Download so bleibt, die neuen Zielbestandsfunktionen bei der Veröffentlichung weiterhin ausdrücklich als Beta kennzeichnen.
- Auctionator ist der Einkaufspartner. TSM liefert optional archivierte Marktpreise (DBMinBuyout). Kalkulationen und Wegpunkte bleiben von verfügbaren Daten abhängig. Einkäufe, Training und das Starten nativer Serien bleiben Spieleraktionen.
- In den Texten fehlen aktuelle Entwicklungsarbeiten und unbestätigte Live-Fälle bewusst. Es gibt keine Zusage einer stets billigsten Route, flächendeckender Stationskoordinaten oder einer automatischen Herstellung. Der 1–300-Entwicklerdurchlauf und die Live-Abnahme sind keine Werbeaussage.
- Alle Texte stehen einzeln in A, B und C. Summary als Klartext übernehmen. description.md ist der vollständige englische Markdown-Inhalt und funktioniert auch ohne Medien. Für Medien die PNGs im Editor hochladen und gemäß media.md platzieren. Die Vorschauen sind lokale Layoutproben. Für schmale Ausschnitte lässt sich das Bild zum Vergrößern öffnen.

## Verifizierte Möglichkeiten

| Bereich | Offiziell dokumentiert | Anwendung hier |
| --- | --- | --- |
| Summary | Kurzer Klartext für Projektlisten. | Jeweils ein eigenständiger Satz. Ein verbindliches Zeichenlimit war in den Guides nicht angegeben. |
| Beschreibung | Markdown oder WYSIWYG. Whitelist für HTML-Tags und Inline-CSS. Dokumentiert sind Überschriften, Listen, Links, Bilder mit alt, Tabellen und eingeschränkte Inline-Stile. | Portables Markdown, kurze FAQ mit fett gesetzten Fragen, responsive Vorschau außerhalb des Editors. Keine frei eingebundenen CSS-Dateien, Skripte oder angenommenen details/summary-Akkordeons. |
| Bilder und Hosting | Upload über den Editor. Erlaubtes img-Element mit src, alt und optionalen Größen. Projektlogo mit separaten Originalitätsvorgaben und 400 × 400 Zielgröße. | PNG für alle Medien; CurseForge-CDN-URLs nach Upload übernehmen. Die Bildtexte stehen in normalem Text unter den Bildern. |
| Galerie | Bilder-Upload mit Beschreibung; der dokumentierte Galerieablauf unterstützt auch YouTube-Videos. | Dieselbe Reihenfolge und Bildunterschriften verwenden. Ein separates Galerie-Alt-Feld konnte nicht verifiziert werden. |
| Video | Beschreibung unterstützt Videos. Die iframe-Regeln beschränken die erlaubten Quellen, unter anderem YouTube und forgecdn.net. | B enthält bereits eine statische Abfolge, die ohne Einbettung funktioniert. |
| GIF, weitere Formate, Dateigröße | GIF/WebP werden in einem Editor-Update erwähnt. Verbindliche WoW-spezifische Grenzen für Galerie/Inline-Bilder und Erhalt der GIF-Animation sind in den eingesehenen offiziellen Seiten nicht eindeutig angegeben. | Statische PNGs verwenden. Medien nach Upload im Editor prüfen. ZIP-Grenzen sind keine Maßgabe für Bilder. |

Quellen

- [Öffentliche CraftDeja-Projektseite](https://www.curseforge.com/wow/addons/craftdeja)
- [Geprüfter Beta.26-Download](https://edge.forgecdn.net/files/9722/537/CraftDeja-3.9.0-beta.26.zip)
- [Project Submission Guide](https://support.curseforge.com/support/solutions/articles/9000199552-project-submission-guide-and-tips)
- [CurseForge HTML- und CSS-Whitelist](https://support.curseforge.com/support/solutions/articles/9000284625-supported-html-tags-css-for-project-descriptions)
- [Projekt erstellen und einreichen](https://support.curseforge.com/support/solutions/articles/9000197241-creating-and-submitting-a-project)
- [Galerie und YouTube](https://blog.curseforge.com/curseforge-platform-release-notes-february/)
- [Editor und Upload-Formate](https://blog.curseforge.com/platform-release-notes-january/)
- [Logo-Upload und Größenanpassung](https://blog.curseforge.com/platform-release-notes-mar/)

## Fehlende Live-Medien und genaue Aufnahmeabfolge

- **A, kompakter Guide.** Beta.26 im Forever-Client starten, einen Beruf öffnen, über /cdj den kompakten Guide einblenden und einen Auftrag mit offenem Materialbedarf wählen. Screenshot machen, sobald der Materialname, die Restmenge und die konkrete Hauptaktion zugleich sichtbar sind. Damit den älteren Live-Beschnitt ersetzen.
- **B, GIF.** Aufnahme in Undercity mit gelerntem Kupferrohr, Ingenieurskunst 65 und Ziel 75 vorbereiten. Guide offen lassen und zuerst im AH den Vorschlag mit Menge aufnehmen, dann den sichtbaren Post-Schritt, die bestätigte Entnahme und den geöffneten Händler mit der Fluxus-Aktion. Für den letzten Clip mit Material und Schmiedehammer am Amboss den Wechsel zu „Herstellung vorbereiten“, den Klick darauf und den vorbereiteten Originalknopf aufnehmen. Übergänge als kurze Schnitte. Falls nur ein Motiv gefilmt wird, den Wechsel am Amboss mit je etwa zwei ruhigen Sekunden vor und nach dem Klick aufnehmen. Ein statisches Standbild mit sichtbarem vorbereiteten Originalknopf als Fallback aufnehmen. Der aktuelle Entwurf nutzt vier statische WoWLua-Bilder; die abschließende Herstellungsansicht wurde aus einem eigenen, bereits versorgten Ausgangszustand aufgenommen.
- **C, Zielbestände und Feldguide.** Im selben Build über /cdj stock einen gelernten Verbrauchsgegenstand wählen, möglichst mit 12 Stück in den Taschen. Ziel 20 speichern. Wenn 8 fehlen, die ganze Ansicht und ein Detail mit Ziel und Fehlmenge erfassen. Danach den kompakten Feldguide mit aktivem Herstellungsauftrag erfassen. Die Konzeptillustration bleibt als solche beschriftet.
- Für die englische Seite sind englische Live-Aufnahmen ideal. Die vorhandenen deDE-Aufnahmen haben deshalb englische Bildunterschriften, die die Handlung und Zahlen erklären. Chat, Namen und private UI-Details vor dem Export ausblenden.
