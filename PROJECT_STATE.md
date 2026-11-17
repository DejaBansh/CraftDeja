# CraftDeja — aktueller Projektstand

Stand: 17.11.2026. Fakten dieser Momentaufnahme beim Arbeitsbeginn erneut prüfen.
Arbeitsregeln: AGENTS.md. Planung: ROADMAP.md. Nachweise: TEST_RESULTS.md.

| Ebene | Letzter belegter Stand |
|---|---|
| Repository / lokaler Ordner | DejaBansh/CraftDeja / C:\Users\Tim\Projects\CraftDeja |
| Addon-Version | 3.9.0-beta.25, wowlua.json und src/Start.lua |
| Freigegebener Release-Commit | 0b5d627fb68f6ac6f65d0ad3e0faac8cc3cec5c9 |
| Release-Tag | v3.9.0-beta.25 |
| Arbeitsbranch / HEAD / Änderungen | Mit Get-ProjectContext.ps1 ermitteln; nicht mit Release gleichsetzen |
| Letzter geprüfter main | 711d463af4c17f1e711248bb409f1dd5fecfe303; kein Merge dieser Arbeit |
| CurseForge | Projekt 1796977, Datei 9660180, Beta, Forever 1.60.1 / Versions-ID 17053 |
| Veröffentlichung | API angenommen, öffentliches CDN-ZIP per SHA256 geprüft; Approved-Status nicht separat abgefragt |
| Lokales Paket | dist/packages/CraftDeja-3.9.0-beta.25-release.zip (ignoriert; nicht in jedem Checkout vorhanden) |
| Paket SHA256 | 5D87821D290827637FABC46C15C7EE167380606FCE6123534870701EAF003976 |
| Installationsnachweis | beta.25 / release6eb9372c; 77 Laufzeit-/Grafikdateien bytegleich zum veröffentlichten Payload |
| Spielziel | C:\Program Files (x86)\World of Warcraft\_forever_\Interface\AddOns\CraftDeja |

Installationsangabe ist der protokollierte Stand, keine fortlaufende Überwachung.
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

Aktuelle Übergabearbeit verändert keine Addonfunktion/Version. Offene Punkte ausschließlich
in docs/OPEN_ITEMS.md. [Historie](docs/archive/2026-11-17-handoff/README.md) und Git erhalten
frühere Zwischenstände und Livebelege.
