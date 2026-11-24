# CraftDeja — aktueller Projektstand

Stand: 23.11.2026. Fakten dieser Momentaufnahme beim Arbeitsbeginn erneut prüfen.
Arbeitsregeln: AGENTS.md. Planung: ROADMAP.md. Nachweise: TEST_RESULTS.md.

Der lokale Build enthält OneForAll-Rezeptquellen für acht Berufe und Zutatenhändler. Die Quellenansicht, Einkaufsvorschläge und Kartenführung verwenden diese Referenzen. Beobachtete Rezeptangebote haben auf der Karte Vorrang. Berufsstandorte liefern keine neuen Lehrer-Rezept-Zuordnungen. Prüfstand: TEST_RESULTS.md, Live-Abnahme OFA-SOURCES.

Der lokale Guide nutzt rezeptbezogene Forever-Lehrerlisten und plant vor einem gemeinsamen Lehrerbesuch die Zutaten bis zur nächsten benötigten Lernschwelle mit Reserve. Hgarth ist für Rezept 13637 belegt. Der Datenabgleich umfasst zehn Katalogberufe. Einzelne Quellen und der Live-Durchlauf bleiben unter DATA-TRAINERS und TRAINER-13637 offen.

Der Zielbestandsreiter listet clientbestätigte Verbrauchsrezepte je Charakter und fasst identische
Ausgaben je Item-ID zusammen. Rechts stehen Taschen, editierbares Ziel, Fehlmenge und Bezugswege.
Das Werkstattpult ist im kompakten Guide über Zahnrad → Einstellungen → Werkstattpult erreichbar. Die Kopfzeile trägt ein Amboss-Siegel. Gehostete
Optionen und Guide-Aktionen haben getrennte Sichtbarkeit. Die Forever-Abnahme ist offen.

Option D ist für künftige CurseForge-Updates ausgewählt. Die Hauptbeschreibung samt Banner und Guide-Bild wurde am 21.11.2026 öffentlich geprüft. Die neue Summary ist in der Author Console gespeichert, ihre öffentliche Anzeige ist offen. [Prüfstand und Medienstatus](docs/assets/marketing/2026-11-21-curseforge/REVIEW.md).

| Ebene | Letzter belegter Stand |
|---|---|
| Repository / lokaler Ordner | DejaBansh/CraftDeja / C:\Users\Tim\Projects\CraftDeja |
| Addon-Version im Arbeitszweig | 3.9.0-beta.27, lokaler Beschaffungs-Kandidat. Der letzte öffentliche Build ist beta.26. |
| Freigegebener Release-Commit | e6cb2909067f41ebc2e3e9def59e3c0274c58606 |
| Release-Tag | v3.9.0-beta.26 |
| Arbeitsbranch / HEAD / Änderungen | Mit Get-ProjectContext.ps1 ermitteln; nicht mit Release gleichsetzen |
| Letzter geprüfter main | 711d463af4c17f1e711248bb409f1dd5fecfe303; kein Merge dieser Arbeit |
| CurseForge | Projekt 1796977, Datei 9722537, Beta, Forever 1.60.1 / Versions-ID 17053 |
| Veröffentlichung | API angenommen, öffentliches CDN-ZIP per SHA256 geprüft; Moderationsstatus nicht separat abgefragt |
| Letztes öffentliches Paket | dist/packages/CraftDeja-3.9.0-beta.26.zip (Download aus dem öffentlichen CurseForge-CDN) |
| Öffentliches Paket SHA256 | F4873231D36A064EFA2CE74A8CD017796ABB527128E9952E84EDF68C06F88F58 |
| Lokaler Kandidat | `dist/packages/CraftDeja-3.9.0-beta.27-RC.zip`, Paketversion `3.9.0-beta.27-alpha+6daffa3`, Release-Profil `445168f4` |
| Installationsnachweis | Am 23.11.2026 vollständiges Backup des vorgefundenen beta.25-Builds und Vergleich aller 81 installierten Dateien mit dem Kandidaten per SHA256. `reports/install/procurement-20261123-073403/INSTALLATION.json` |
| Spielziel | C:\Program Files (x86)\World of Warcraft\_forever_\Interface\AddOns\CraftDeja |
| Zielbestands-Kandidat und exakter Release-Test | In TEST_RESULTS.md verlinkt. Spielerfeedback zum lokalen Kandidaten positiv. |

Installationsangabe ist der protokollierte Stand, keine fortlaufende Überwachung.
Frühere Installation am 20.11.2026 aus der privaten Quellkopie mit Commit
`9e44f40dfd7fecd460d8197b6e4502d804e0a137`. Vorher fehlte der entpackte CraftDeja-Ordner.
Das vorhandene `CraftDeja.rar` blieb im AddOns-Ordner und wurde per SHA256 verifiziert gesichert.
Installationsbericht: `reports/install/guide-test-verified-20261120-201506-bericht.zip`.
Der Projektcheck liest weder Spielprozesse noch Installation. ZIP-Container können sich
bei identischem Payload unterscheiden; zusätzlich Dateihashes vergleichen.

## Implementiert und automatisiert geprüft

- Preisbewusste Berufsplanung mit begrenztem Routenvergleich, bekannten einmaligen Lernkosten,
  getrenntem Zukauf/Materialwert und unbekannten Preisen. Kein Globaloptimum versprechen.
- Abschnittsweise feste Route; Bestand, Angebote und Preise vor konkreten Aktionen erneut prüfen.
  AH, Post, Händler, Bank, eigene Twinks und opt-in Gilden-Crafts nutzen bestehende Auftragslogik.
- beta.25: Eigenbestand/AH, echte native Alternativzutaten und bestätigte eigene Konversionen.
  Reservierte Altbestände bleiben geschützt; Ranglimit vor Zielabschluss.
- beta.24: Ingenieursauftrag vor Gift-Prompt geschützt; echte Giftfreischaltung erforderlich;
  Mengen/Post konsistent, Fluxus-Händleraktion, beobachtete Stationsmarker, proportionale Guidegrafik.
- Hauptfenster und kompakter Guide sind Ansichten desselben Auftrags. Minimap-/Addon-Einstellungen
  ermöglichen Öffnen. Release-only im Spiel; keine automatische Dev-Instrumentierung.

## Grenzen und offene Abnahme

Letzte vollständige lokale und CI-Prüfung: TEST_RESULTS.md. Live-Abnahme der neuen Flüsse offen.
Kein vollständiger verifizierter Forever-Stationsatlas, kein begehbarer Welt-/Ebenengraph und
kein globaler Wochenabgleich der Händlerrezepte. Öffentliche Hauptbeschreibung braucht den
manuellen Author-Console-Schritt; erfolgreicher description-Job bedeutet nur Textvorbereitung.

## Marketingdateien

Zwei unveröffentlichte Marketingentwürfe liegen unter docs/assets/marketing/2026-11-17/
(A: Goblin/Goldvorteil, B: Werkstattablauf). Beide 1672×941, mit eingebautem image_gen erzeugt,
visuell auf Text und Bezug zu vorhandenen Funktionen geprüft; keine Live-Client-Aufnahmen.
Nutzer hat A ausgewählt. Finale lokale DE-Datei: CraftDeja-Description-Hero-DE.png.
Einbindung in die öffentliche Description noch offen. Prompts und Dateihashes liegen daneben.
Neues dazu passendes Logo und Goblin-Symbol unter docs/assets/branding/2026-11-17/:
Logo 1536×1024, Icon 1254×1254, PNG mit Alpha geprüft. Aktive Art/Logo.tga-/MapLogo.tga-Dateien
unverändert; noch kein Addon-/CurseForge-Einbau. Prompts und Manifest daneben.

## Guide und aktuelle Abnahme

- Der Guide speichert die Sichtbarkeit getrennt vom Auftrag. Der Button im Berufsfenster
  öffnet oder schließt den Guide für den Besuch. Aktualisierungen laufen auch bei geschlossenem Guide.
- Teilkäufe, Post und Händlerbestand nutzen bestätigte Mengen. Die Herstellung setzt einen
  unterbrochenen Auftrag mit der offenen Menge fort. Abgeschlossene Produktionsaufträge
  haben eine eigene Fertig-Ansicht. Die gewünschte Skillgrenze bleibt beim Fensterwechsel erhalten.
- Opt-in Zielbestände per `/cdj stock` und über das Hauptfenster. Taschenbestand, fehlende
  Menge und Rundung für herstellbare und direkt gekaufte Verbrauchsgüter. Alte Giftziele
  werden nach Bestätigung des nativen Rezepts übernommen. Die Zusatzproduktion bleibt separat.
- Der zusammenhängende Ingenieurslauf von 1 bis 300 erreicht in der deDE-Simulation
  bei 300/300 „Fertig“. Der veröffentlichte Runtime-Quellstand ist gleich geblieben.
  Reale Rezeptwechsel, Skillchancen und der komplette Forever-Liveablauf sind separat
  zu prüfen. Build und Zuordnung zum Test-Basiscommit stehen in TEST_RESULTS.md.

Offene Punkte ausschließlich
in docs/OPEN_ITEMS.md. [Historie](docs/archive/2026-11-17-handoff/README.md) und Git erhalten
frühere Zwischenstände und Livebelege.
