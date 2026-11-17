# CraftDeja — Testnachweise

Stand: 17.11.2026. Maschinenlesbarer Einstieg: [docs/evidence/index.json](docs/evidence/index.json).
Der Index bezeichnet Belege, keine pauschale Freigabe späterer Änderungen.

| Prüfung beta.25 | Ergebnis | Nachweis |
|---|---|---|
| Lokale Vollsuite, release-Build | 657/0/0; 208,54 s | reports/tests/20261117-054821-3541b2.zip |
| Material-/Rangregressionen | 23/0/0; 7,58 s, emulierte Ansichten | reports/tests/20261117-054730-b4238e.zip |
| Kanonischer getaggter Checkout | 657/0/0; 200,99 s | reports/curseforge-beta25-local/source/reports/tests/20261117-055309-55a048.zip |
| Tatsächliches Actions CI | 657/0/0; 660,03 s; 26 Releasechecks | [Run 44020213463](https://github.com/DejaBansh/CraftDeja/actions/runs/44020213463) |
| UI-Matrix | 1920×1080 / 3440×1440, UI 65%/100%, je 14/0/0 | reports/workshop-matrix/20261117-054835/MATRIX.json |
| Installation / Veröffentlichung | 77 installierte / 81 Distributionsdateien geprüft | reports/install/beta25-20261117-055802-bericht.zip |

Gesamtbericht: reports/material-sources-beta25.zip. reports/-Pfade sind lokal und ignoriert;
in einem neuen Checkout können sie fehlen. Fehlend ist nicht bestanden.
Versionierte Quellen-/Test-/Inputhashes: docs/evidence/beta25-source-manifest.json.
Die lokale Vollsuite lief auf Basiscommit plus uncommittierter Implementierung; Manifest
nennt deshalb Test-Basiscommit und späteren Release-Commit getrennt. Die geprüften Bytes zählen.

Umgebung: Windows, wowlua 0.13.14, Camelot-/Blizzard-UI-Quellemulation, Forever 1.60.1/70938.
Simulation beweist keine FPS, echten Preise, geschützten Live-Aktionen oder Live-Grafikabnahme.
Bekannte W1034-/Testlocal-Warnungen sind keine Compilerfehler.

Windows-Addonprüfungen ausschließlich über tools/Test-CraftDeja.ps1 starten;
für Releaseprüfung -Profile release ausdrücklich setzen. Anleitung: docs/TEST_REPORTS.md.
Isolierte technische Prüfung des Projektchecks: docs/PROJECT_CONTEXT.md.
Keine neue vollständige Addonsuite für diese Übergabearbeit behaupten.
Ältere Zwischenläufe: [Archiv](docs/archive/2026-11-17-handoff/TEST_RESULTS.md).
