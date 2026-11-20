# CraftDeja — aktueller Projektstand

Stand: 20.11.2026. Fakten dieser Momentaufnahme beim Arbeitsbeginn erneut prüfen.
Arbeitsregeln: AGENTS.md. Planung: ROADMAP.md. Nachweise: TEST_RESULTS.md.

Der Zielbestandsreiter listet clientbestätigte Verbrauchsrezepte je Charakter und fasst identische
Ausgaben je Item-ID zusammen. Rechts stehen Taschen, editierbares Ziel, Fehlmenge und Bezugswege.
Der kompakte Guide verweist für die Auftragsbearbeitung auf das Werkstattpult. Gehostete
Optionen und Guide-Aktionen haben getrennte Sichtbarkeit. Die Forever-Abnahme ist offen.

| Ebene | Letzter belegter Stand |
|---|---|
| Repository / lokaler Ordner | DejaBansh/CraftDeja / C:\Users\Tim\Projects\CraftDeja |
| Addon-Version im Arbeitszweig | 3.9.0-beta.26, wowlua.json und src/Start.lua |
| Freigegebener Release-Commit | 0b5d627fb68f6ac6f65d0ad3e0faac8cc3cec5c9 |
| Release-Tag | v3.9.0-beta.25 |
| Arbeitsbranch / HEAD / Änderungen | Mit Get-ProjectContext.ps1 ermitteln; nicht mit Release gleichsetzen |
| Letzter geprüfter main | 711d463af4c17f1e711248bb409f1dd5fecfe303; kein Merge dieser Arbeit |
| CurseForge | Projekt 1796977, Datei 9660180, Beta, Forever 1.60.1 / Versions-ID 17053 |
| Veröffentlichung | API angenommen, öffentliches CDN-ZIP per SHA256 geprüft; Approved-Status nicht separat abgefragt |
| Lokales Paket | dist/packages/CraftDeja-3.9.0-beta.25-release.zip (ignoriert; nicht in jedem Checkout vorhanden) |
| Paket SHA256 | 5D87821D290827637FABC46C15C7EE167380606FCE6123534870701EAF003976 |
| Installationsnachweis | Lokaler Guide-Testbuild `3.9.0-beta.25-alpha+9e44f40`, Release-Profil `725c8fab`. Alle 77 Dateien entsprechen bytegenau dem getesteten Build. |
| Spielziel | C:\Program Files (x86)\World of Warcraft\_forever_\Interface\AddOns\CraftDeja |
| Lokaler Zielbestands-Kandidat | In TEST_RESULTS.md verlinkt. Release-Profil aus dem Arbeitsbaum auf Basis b080727. |

Installationsangabe ist der protokollierte Stand, keine fortlaufende Überwachung.
Installation am 20.11.2026 aus der privaten Quellkopie mit Commit
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

## Lokaler Entwicklungsstand vom 20.11.2026

- Der Guide speichert die Sichtbarkeit getrennt vom Auftrag. Der Button im Berufsfenster
  öffnet oder schließt den Guide für den Besuch. Aktualisierungen laufen auch bei geschlossenem Guide.
- Teilkäufe, Post und Händlerbestand nutzen bestätigte Mengen. Die Herstellung setzt einen
  unterbrochenen Auftrag mit der offenen Menge fort. Abgeschlossene Produktionsaufträge
  haben eine eigene Fertig-Ansicht. Die gewünschte Skillgrenze bleibt beim Fensterwechsel erhalten.
- Opt-in Zielbestände per `/cdj stock` und über das Hauptfenster. Taschenbestand, fehlende
  Menge und Rundung für herstellbare und direkt gekaufte Verbrauchsgüter. Alte Giftziele
  werden nach Bestätigung des nativen Rezepts übernommen. Die Zusatzproduktion bleibt separat.
- Dev-Build in dist/dev/CraftDeja. Zugehörige Berichte und Prüfung des installierten
  Release-Profils stehen in TEST_RESULTS.md.

Offene Punkte ausschließlich
in docs/OPEN_ITEMS.md. [Historie](docs/archive/2026-11-17-handoff/README.md) und Git erhalten
frühere Zwischenstände und Livebelege.
