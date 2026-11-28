# CraftDeja — hier beginnen

**28.11.2026 · Kochkunst 225/225** · Lokaler Prüfcommit 776d0ce3b48a5c803fe22652a1b89ea21a79681f auf development. 706 WoWLua-Tests bestanden. Forever-Installation mit vollständigem Backup und SHA256 geprüft. [Installationsbericht](reports/install/verified-20261128-024534-bericht.zip). Nächster Schritt ist die Live-Abnahme COOK-6610 bei Dirge. Die CurseForge-Beschreibung für beta.27 hat Tim laut eigener Rückmeldung manuell aktualisiert.

**BAG_UPDATE_DELAYED-Scan-Debounce, 26.11.2026.** Uncommittierter Arbeitsbaum auf `34a90a60c33e3c33fae3bc0f396c5f6f0383909e`: `src/Inventory.lua` — synchroner Inventarscan bei geöffneter Bank durch das bestehende 0,3-s-Debounce-Intervall ersetzt. Kein Ereignis setzt das Debounce-Intervall mehr zurück; die ausstehende Anfrage wird im `captureInventory` zu Beginn konsumiert, damit ein Re-Dirty während des Scans nicht verloren geht. `BANKFRAME_CLOSED` und `PLAYER_LOGOUT` sind nun unmittelbare synchron geschaltete Pfade (`captureInventory` direkt); `BANKFRAME_OPENED` geht über das Debounce wie die übrigen Ereignisse. Neue Suite `tests/InventoryDebounceSuite/inventory-debounce.test.wowlua` (10 Tests: Burst, Bank schließen synchron, Bank schließen mit nicht verfügbarer Bank-API, Logout, Missed-Capture, Mixed-Event-Cadence, Re-Dirty während des Scans, Craft-Busy-Defer, voller Dispatch-Pfad, Bank-open-Pfad). Red-Green-Nachweis: gegen den unveränderten Stand fehlschlagen die betroffenen Tests (2 bestanden, 8 fehlgeschlagen); nach den Korrekturen 10/10. Dev-Profil über `tools/Test-CraftDeja.ps1 -Profile dev`: **699/0/0** (328 Dateien), 233,83 s. Kein Commit, kein Push, keine Installation, keine Veröffentlichung. [Bericht](reports/tests/20261126-032219-ce0f0f.zip). Nächster Schritt: Freigabe für Commit/Merge/Install über den Arbeitsbaum.

**Release 3.9.0-beta.27, 24.11.2026.** Tag v3.9.0-beta.27 auf 8d66c68050882d99cc49c9cdc9c7a3f52aa06fbd. [GitHub Actions](https://github.com/DejaBansh/CraftDeja/actions/runs/45334384376) erfolgreich. [CurseForge-Datei 9786102](https://www.curseforge.com/wow/addons/craftdeja/files/9786102) für Forever 1.60.1, Beta. 689/0/0 im Release-Dry-Run, 89 Dateien im öffentlichen CDN-Paket einzeln per SHA256 abgeglichen. Hauptbeschreibung separat für die Author Console vorbereitet.

**OneForAll-Quellen, 23.11.2026.** Installierter lokaler beta.27-Kandidat auf cf51214966014ccfb9123b262580a494246aec1e plus Arbeitsbaum. 3.138 Rezeptbeziehungen abgeglichen, 168 weitere Boss-Zuordnungen. Alle 4.125 Zutaten-Händler-Paare auflösbar. WoWLua 0.13.14: 689 bestanden, 0 fehlgeschlagen, 0 übersprungen (285,46 s). 89 installierte Dateien sowie Backup geprüft. Nächste Live-Abnahme: OFA-SOURCES, Rezept 7751 bei Lizbeth Cromwell und begrenzt verfügbares Rezeptangebot. [Bericht](reports/tests/20261123-210708-559a1e.zip) · [Installation](reports/install/oneforall-210708/Installationsbericht.zip).

Lokaler Hgarth-Kandidat beta.27 auf Basis cf51214966014ccfb9123b262580a494246aec1e plus Arbeitsbaum, 23.11.2026. 375 Lehrerlisten geprüft. WoWLua: 688 bestanden, 0 Fehler, 0 übersprungen in 217,79 s. Materialreserve vor der Anreise und verfügbare Lernschritte am Lehrer geprüft. 86 installierte Dateien und Backup per SHA256 verifiziert. Nächste Live-Abnahme: Packliste und Lernschritt bei Hgarth in Sonnenfels. Weitere Datenlücken unter DATA-TRAINERS. [Tests](reports/tests/20261123-203103-19c91f.zip) · [Installation](reports/install/hgarth-203103/Installationsbericht.zip).

Vorheriger Prüfstand war der lokale beta.27-Kandidat für Godan und das Verlaufsprotokoll. Grundlage ist `cf51214966014ccfb9123b262580a494246aec1e` plus Arbeitsbaum. 687 Tests bestanden. Installation und Backup sind verifiziert. Als Nächstes in Forever bei Godan „Quelle zeigen“ für Rezept 13637 und beim ersten Öffnen die vier Protokollbuttons prüfen. Hgarth ist inzwischen in der Forever-Datenbank bestätigt (TRAINER-13637). [Installationsbericht](reports/install/godan-log-194415/Installationsbericht.zip).

Der installierte lokale beta.27-Kandidat zeigt g, s und c in Gold, Silber und Kupfer. Er enthält den kurzen Händlerhinweis mit Gegenstandssymbol, Kaufmenge und Namen bei Mouseover. 686/0/0 Tests, 86 installierte Dateien verifiziert. [Installationsbericht](reports/install/muenzfarben-175825/Installationsbericht.zip). Als Nächstes den Kontrast der drei Währungen im Forever-Client prüfen.

Die zweite Meisterpult-Designprobe ist als lokaler beta.27-Build in Forever installiert. Der kompakte Guide hat ein Amboss-Siegel, abgestimmte Material- und Rezeptaktionen sowie den Werkstattpult-Zugang unter Zahnrad → Einstellungen. 685 Tests bestanden, 86 installierte Dateien per SHA256 geprüft. [Guide](reports/install/meisterpult-v2/Guide.png) und [Optionen](reports/install/meisterpult-v2/Optionen.png) zeigen den Emulatorstand. Nächster Schritt ist die visuelle Abnahme UI-27 im Forever-Client.

1. [AGENTS.md](AGENTS.md) lesen. Arbeitsordner, Branch, HEAD und offene Änderungen prüfen.
2. Den lesenden [Projektcheck](docs/PROJECT_CONTEXT.md) ausführen.
3. [PROJECT_STATE.md](PROJECT_STATE.md), [DECISIONS.md](DECISIONS.md), [ROADMAP.md](ROADMAP.md) und auftragsrelevanten Code lesen.
4. Den jüngsten Beleg in [TEST_RESULTS.md](TEST_RESULTS.md) und offene Prüfungen in [docs/OPEN_ITEMS.md](docs/OPEN_ITEMS.md) nachlesen.

Beta.27 ist als Beta veröffentlicht. Release-Commit und Datei-ID stehen in PROJECT_STATE.md.
Der zusammenhängende Ingenieurslauf ist in TEST_RESULTS.md protokolliert. Als Nächstes
die dort bezeichneten Übergänge in Forever prüfen. Lokale Werbe-, Logo- und Mockup-Entwürfe
sind separat vorhanden. Für die CurseForge-Seite ist [Option D](docs/assets/marketing/2026-11-21-curseforge/D/desktop.html) ausgewählt. Der Prüfstand und die noch benötigten Live-Aufnahmen stehen in
[REVIEW.md](docs/assets/marketing/2026-11-21-curseforge/REVIEW.md).
Historische Übergaben liegen in [docs/archive](docs/archive).

Der lokale Kandidat beta.27 ergänzt die [Rezeptbeschaffung und Serienwahl](docs/GUIDE_BESCHAFFUNG_UND_SERIEN.md). Im Guide beim Händler oder AH „Rezepte bis Skill 300 prüfen“ öffnen. Der aktuelle Auftrag behält sein Ziel. Die sichere Serie bleibt voreingestellt. Eine längere Serie muss der Spieler am Ziel selbst stoppen. Prüfstand und Bericht stehen in TEST_RESULTS.md. Am 23.11.2026 sind 683 Tests bestanden. Das lokale beta.27-Paket wurde mit Backup und Prüfung aller 81 installierten Dateien übernommen. Für die nächste Forever-Runde PROC-27 in docs/OPEN_ITEMS.md verwenden.

## 26.11.2026 - PERF-001: Passive hidden guide

Periodic guide refresh is skipped only when the guide is hidden,
no profession is active, and the owner's active route waits for
a profession to open. Transaction and explicit refresh paths
remain unchanged.

Baseline: 79db8a149c184315c355a67e0aa43deba8b85ec5.
Changed: src/Run.lua.
Regression suite: tests/GuideIdleSuite/guide-idle.test.wowlua.
Local release build: passed.
Source emulator: 705 passed, 0 failed, 0 skipped (329 files).
WoWLua 0.13.14, 254.79 seconds.
Report: reports/tests/20261126-065943-c236fd.zip.
Live CPU verification and red baseline test remain open.
No installation or publication.
