# CraftDeja — Testnachweise

Stand: 20.11.2026. Maschinenlesbare Nachweise in [docs/evidence/index.json](docs/evidence/index.json).

## Veröffentlichung von beta.26

- Exakter Tag `v3.9.0-beta.26`, Commit `e6cb2909067f41ebc2e3e9def59e3c0274c58606`.
  Lokaler Dry Run mit **675/0/0** in 219,90 Sekunden und **26/0** Pipeline-Prüfungen.
  [Lokaler Testbericht](reports/beta26-release-check/reports/local-dry-run/artifacts/TEST-REPORT.zip).
- [GitHub Actions](https://github.com/DejaBansh/CraftDeja/actions/runs/44815834310) mit
  **675/0/0**, erfolgreichem Beta-Upload als Datei 9722537 und vorbereiteter Projektbeschreibung.
  Die 81 entpackten Dateien des CI-Pakets entsprechen dem Dry Run. Die öffentlich
  heruntergeladene ZIP stimmt bytegenau mit dem Upload-Beleg überein.
- Der lokale Dry Run wurde in einem sauberen Klon ausgeführt. Die erfassten
  Test- und Eingabedateien stimmen nach Zeilenende-Normalisierung mit dem Arbeitsbaum überein.
  Rohprüfsummen beziehen sich auf den Klon. Der Nutzer hat den vorherigen Kandidaten im Spiel
  als gut laufend bestätigt. Die detaillierte Forever-Matrix bleibt offen.

## Berufsübergreifende Zielbestände und Guide, Kandidat vor Veröffentlichung

- Vollsuite mit WoWLua 0.13.14 und Camelot unter Windows, **675 bestanden,
  0 fehlgeschlagen, 0 übersprungen**, 325 Dateien, 216,40 Sekunden. Der
  [Bericht](reports/tests/20261120-213753-9e940a.zip) enthält Quellprüfsummen und Protokoll.
- Geprüft sind Quellenzusammenführung je Item-ID, Berufswechsel, Charakterwechsel,
  vorhandener Rezeptstand nach erneutem Initialisieren, neue Rezepte und der Händlerablauf
  von der Zeilenauswahl über Ziel 20 bei Bestand 12 bis zur bestätigten Auffüllung.
- Die Tests prüfen die Auftragsbearbeitung im Werkstattpult und den Wechsel aus der
  Materialwahl in die Optionen und zurück. Ohne Ausblenden der Materialaktion scheitert
  die isolierte [Gegenprobe](reports/stock-guide-views/20261120-213909/reports/tests/20261120-214011-1b8714.zip)
  an der Sichtbarkeitsprüfung. WoWLua-Ansichten in 1080p bei UI-Skala 65 % für
  [Zielbestände](reports/stock-guide-views/20261120-213909/stock.png),
  [Guide](reports/stock-guide-views/20261120-213909/guide.png) und
  [Optionen](reports/stock-guide-views/20261120-213909/options.png).
- [Installierbares ZIP](dist/packages/stock-guide-rc-20261120-213753-9e940a/CraftDeja-3.9.0-beta.25-Zielbestaende-Guide-RC.zip),
  Release-Profil `3.9.0-beta.25-alpha+b080727`. Alle 81 ZIP-Dateien mit dem Build
  abgeglichen. TOC, Forever-Interface, Grafiken, Lizenzen und Spieler-Runtime geprüft.
  SHA256 `56EF5AC4614BC111B78609A9DCBC4F4D838E72837F2A52E5ED9AC57871E00CF4`.
- Die Live-Abnahme in Forever bleibt offen. Die exportierten Forever-API-Dokumente 1.60.1.71037
  führen `GetProfessionSpells`, `GetProfessionInfoByRecipeID` und `NEW_RECIPE_LEARNED`.
  Der Reiter übernimmt nur individuell bestätigte Ausgaben. Wie viel der Client bei
  geschlossenem Berufsfenster tatsächlich liefert, gehört zur Live-Abnahme.

## Zielbestände im Hauptfenster, vorheriger Release-Kandidat

- WoWLua 0.13.14, Camelot unter Windows mit Blizzard-UI. Vollsuite **672 bestanden,
  0 fehlgeschlagen, 0 übersprungen**, 325 Dateien, 230,51 Sekunden.
  [Bericht mit Quellprüfsummen](reports/tests/20261120-210852-88c2a0.zip).
- Die StockRefillSuite deckt Namenssuche, Zieländerung, Giftmigration, anerkannte
  Teilbestände, verzögerte Händlerbestätigung, Rezept- und Händlerstapel ab. Die
  UndercityFlowSuite prüft Beruf, AH, Teilkäufe, Post, Händler, unterbrochene
  Herstellung und „Fertig“ innerhalb desselben Auftrags.
- Vier WoWLua-Ansichten bei 1920 × 1080 und 3440 × 1440 mit 65 % und 100 % UI-Skala
  sowie langem deDE-Testnamen. [Ansichten](reports/stock-workshop-matrix/20261120-210553/Zielbestaende-Matrix.png).
  Forever-Abnahme mit realem Addonset offen.
- [Installierbares ZIP](dist/packages/stock-ui-rc-20261120-210852-88c2a0/CraftDeja-3.9.0-beta.25-Zielbestaende-RC.zip)
  im Release-Profil `3.9.0-beta.25-alpha+b080727`. 81 ZIP-Dateien mit dem Build
  abgeglichen. Verifizierte TOC, Assets, Lizenzen und Laufzeit ohne Dev-Instrumentierung.
  SHA256 `24545B8918E19EA587E90BD4BF21BB2910D39827738F4A427782390A374D1320`.

## Guide und Zielbestände, lokaler Dev-Stand vom 20.11.2026

| Prüfung | Ergebnis | Nachweis |
|---|---|---|
| Vollständige Ausgangsmessung (beta.25, HEAD b080727) | 657/0/0, 205,31 s | reports/tests/20261120-193838-3b814e.zip |
| Zwei gezielte Gegenproben auf dem unveränderten Ausgangscode | 0/2/0: AH öffnet geschlossenen Guide, fertige Produktion fällt in Rezeptwahl | reports/guide-baseline-repro-20261120/source/reports/tests/20261120-195316-59381c.zip |
| Gezielte Prüfung Guide-, Händler-, Workshop- und Zielbestandsfälle | 65/0/0, 24,84 s | reports/tests/20261120-195711-923309.zip |
| Finale Vollsuite mit Dev-Build | **668/0/0**, 229,10 s, 325 Dateien | reports/tests/20261120-195751-596a7e.zip |
| Vollsuite des installierten Release-Profils | **668/0/0**, 205,63 s, 325 Dateien, Forever 1.60.1.71037 | reports/guide-install-20261120-201022/source/reports/tests/20261120-201109-7717f0.zip |
| Installation des lokalen Guide-Teststands | 77 installierte Dateien stimmen mit dem Build aus der Release-Vollsuite überein. Vorhandenes RAR gesichert und verifiziert. | reports/install/guide-test-verified-20261120-201506-bericht.zip |

Testumgebung: Windows, WoWLua 0.13.14, Camelot mit Blizzard-UI des installierten Clients
Forever 1.60.1.70959. Der erste Ausgangslauf scheiterte am Cachezugriff, bevor ein Test lief
(reports/tests/20261120-193733-70798b.zip). Nach Cache-Aufbereitung lief die Ausgangssuite vollständig.
Die erste geänderte Vollsuite wies alte Sichtbarkeitsannahmen in Händler-/Workshop-Fixtures
und fehlende Argumente im Login-Fixture aus. Die bestehenden Kauf- und Mengenassertionen wurden
beibehalten und die Fixtures verwenden einen ausdrücklichen Einstieg in den Guide.

Der neue Kupferrohrfall prüft eine Folge von 4+6 bestätigten Barren, Post in zwei Lieferungen,
5 Fluxus, native Rückkehr zum Beruf, Abbruch nach 2 und Fortsetzen mit 3 Versuchen bis 70.
Der native Abbruch-Payload wird kontrolliert an den registrierten Handler übergeben.
Der Bankablauf prüft Einlagern und Entnehmen einschließlich Teilbestand und vollem Zielcontainer.
Zielbestände testen Taschenbestätigung für Gifte, feste Mehrfachausbeute für ein Alchemie-Fixture,
direkte Kaufware, verspätete Angebote und Bag-Updates, Sitzungsstart, erneuten Bedarf, Gold und Taschenplatz.
Die Live-Klickfolge steht in docs/GUIDE_FULL_FLOW_DEV.md. Dev-Build `dev e91506af` in dist/dev/CraftDeja.

## Veröffentlichter Stand beta.25 vom 17.11.2026

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
