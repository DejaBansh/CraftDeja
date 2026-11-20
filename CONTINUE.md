# CraftDeja — hier beginnen

Aktualisiert: 20.11.2026. Aktuelle Übergabe, kein Verlaufsprotokoll.

1. AGENTS.md lesen; Arbeitsordner, Branch, HEAD und offene Änderungen tatsächlich prüfen.
2. powershell -NoProfile -ExecutionPolicy Bypass -File .\tools\Get-ProjectContext.ps1 -AsJson ausführen.
3. PROJECT_STATE.md, DECISIONS.md, ROADMAP.md und auftragsrelevante Module/Tests lesen.
4. Offene Fehler/Live-Abnahmen: [docs/OPEN_ITEMS.md](docs/OPEN_ITEMS.md).
   Orientierung im Code: [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md).

Release-/Installationsstand ausschließlich in PROJECT_STATE.md, Nachweise in TEST_RESULTS.md.
Abgeschlossen: zwei Werbebild-Entwürfe A/B im vorhandenen Goblinstil erstellt und lokal gespeichert:
docs/assets/marketing/2026-11-17/. PNGs, Prompts und Prüfsummen vorhanden. Nutzer hat Option A gewählt;
finale DE-Datei: CraftDeja-Description-Hero-DE.png;
Zusätzlich neues Logo mit Schriftzug und quadratisches Goblin-Symbol im gleichen Stil:
docs/assets/branding/2026-11-17/ (PNG mit Alpha, Prompts und Hashes).
Keine Veröffentlichung und kein Einbau in Description/Addon. Keine Addon-/Build-/Teständerung.
Arbeitsstand 20.11.: Guide-Sichtbarkeit pro Berufsbesuch, durchgehender Auftrag und
gemeinsame Zielbestandsrechnung überarbeitet. Finale WoWLua-Vollsuite 668/0/0, lokaler Dev-Build.
Code und Testnachweis lokal, siehe
TEST_RESULTS.md und docs/GUIDE_FULL_FLOW_DEV.md. Freigegebene beta.25 bleibt die Basis.
Vorhandene Werbe-/Logoänderungen wurden im Arbeitsbaum erhalten.

Zielbestände: Der Reiter zeigt erlernte Verbrauchsrezepte berufsübergreifend pro Charakter.
Die Zeile ist je Item-ID eindeutig. Bezugsweg und Zielmenge stehen rechts. „Auftrag ändern“
liegt in „Auftrag & Angebote“. Gastgeberseiten wie Optionen blenden die Materialaktionen
des kompakten Guides aus. Nutzer meldet den Kandidaten als gut laufend. Beta.26 ist auf
CurseForge verfügbar, mit 675/0/0 im Tag-Lauf und verifiziertem CDN-Paket. Commit und
Datei-ID stehen in PROJECT_STATE.md. Die Author-Console-Beschreibung und die detaillierten
STOCK-UI-Livefälle bleiben offen.

Offene Live-Abnahme: Forever/deDE nach docs/GUIDE_FULL_FLOW_DEV.md prüfen (GUIDE-DEV).
Besonders native Unterbrechung, Rückkehr zum Beruf, TSM/Bank und verspätete Händler-/Postdaten prüfen.
Der geprüfte lokale Teststand ist als Release-Profil in WoW Forever installiert. Buildkennung,
Backups und Ziel stehen in PROJECT_STATE.md und TEST_RESULTS.md.

Bei Abschluss diese Übergabe ersetzen. Fehlerstatus in OPEN_ITEMS, Nachweise im Index,
Planung in ROADMAP pflegen; keine identischen Statusblöcke kopieren.
Historie: [Archiv vom 17.11.2026](docs/archive/2026-11-17-handoff/README.md).
