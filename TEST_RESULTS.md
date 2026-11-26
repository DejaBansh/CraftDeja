# CraftDeja — Testnachweise

**Release 3.9.0-beta.27, 24.11.2026.** Tag v3.9.0-beta.27 auf 8d66c68050882d99cc49c9cdc9c7a3f52aa06fbd. [GitHub Actions](https://github.com/DejaBansh/CraftDeja/actions/runs/45334384376) erfolgreich. [CurseForge-Datei 9786102](https://www.curseforge.com/wow/addons/craftdeja/files/9786102) für Forever 1.60.1, Beta. 689/0/0 im Release-Dry-Run, 89 Dateien im öffentlichen CDN-Paket einzeln per SHA256 abgeglichen. Hauptbeschreibung separat für die Author Console vorbereitet.

**OneForAll-Quellen, 23.11.2026.** Installierter lokaler beta.27-Kandidat auf cf51214966014ccfb9123b262580a494246aec1e plus Arbeitsbaum. 3.138 Rezeptbeziehungen abgeglichen, 168 weitere Boss-Zuordnungen. Alle 4.125 Zutaten-Händler-Paare auflösbar. WoWLua 0.13.14: 689 bestanden, 0 fehlgeschlagen, 0 übersprungen (285,46 s). 89 installierte Dateien sowie Backup geprüft. Nächste Live-Abnahme: OFA-SOURCES, Rezept 7751 bei Lizbeth Cromwell und begrenzt verfügbares Rezeptangebot. [Bericht](reports/tests/20261123-210708-559a1e.zip) · [Installation](reports/install/oneforall-210708/Installationsbericht.zip).

Lokaler Hgarth-Kandidat beta.27 auf Basis cf51214966014ccfb9123b262580a494246aec1e plus Arbeitsbaum, 23.11.2026. 375 Lehrerlisten geprüft. WoWLua: 688 bestanden, 0 Fehler, 0 übersprungen in 217,79 s. Materialreserve vor der Anreise und verfügbare Lernschritte am Lehrer geprüft. 86 installierte Dateien und Backup per SHA256 verifiziert. Nächste Live-Abnahme: Packliste und Lernschritt bei Hgarth in Sonnenfels. Weitere Datenlücken unter DATA-TRAINERS. [Tests](reports/tests/20261123-203103-19c91f.zip) · [Installation](reports/install/hgarth-203103/Installationsbericht.zip).

**Godan und Verlaufsprotokoll**, 23.11.2026. Lokaler beta.27-Build auf `cf51214966014ccfb9123b262580a494246aec1e` plus Arbeitsbaum. WoWLua/Camelot: 687 bestanden, 0 fehlgeschlagen, 0 übersprungen in 244,94 s. Geprüft wurden Quellenwahl für Rezept 13637 und Gestaltung der Log-Aktionen beim ersten Öffnen. Der alternative Lehrer und die Darstellung im Forever-Client bleiben zur Live-Abnahme offen. [Testbericht](reports/tests/20261123-194415-07837e.zip).

**Münzfarben**, 23.11.2026. Release-Build beta.27, Basis `6daffa3fc5c27449e07a441cb6a75dccc178b5f0` plus Arbeitsbaum. 686 bestanden, 0 fehlgeschlagen, 0 übersprungen in 205,39 s. Geprüft wurden die Formatierung von 1g 2s 13c, negative und anteilige Kupferbeträge sowie das Preisangebot im Kaufbutton. [Bericht](reports/tests/20261123-175825-ec906d.zip).

**Händlerhinweis im kompakten Guide**, 23.11.2026. Lokaler Release-Build beta.27, Basiscommit `6daffa3fc5c27449e07a441cb6a75dccc178b5f0` plus Arbeitsbaum. In WoWLua/Camelot sind 686 Tests bestanden, 0 fehlgeschlagen, 0 übersprungen (210,60 s). Der Händlerfall prüft Item-ID 2880, Menge 10, Tooltip-Name und den Wechsel zwischen Guide und Optionen. [Testbericht](reports/tests/20261123-155412-2e49bd.zip). Die visuelle Abnahme im Spiel ist offen.

**BAG_UPDATE_DELAYED-Optimierung**, 26.11.2026. Lokaler Arbeitsbaum-Stand auf `34a90a60c33e3c33fae3bc0f396c5f6f0383909e` plus uncommittierte Änderung in `src/Inventory.lua` (synchroner Inventarscan bei geöffneter Bank durch das bestehende `dirty`-Debounce-Intervall ersetzt) und neue Suite `tests/InventoryDebounceSuite/inventory-debounce.test.wowlua`. Dev-Profil via `tools/Test-CraftDeja.ps1 -Profile dev`: **696 bestanden, 0 fehlgeschlagen, 0 übersprungen** (328 Dateien), 228,33 s. ZIP SHA256 `dec3f38a99741840968d289b7270820581d2f4c67937a0e2da4d143476b467f9`. 7 neue deterministische Tests: 5/7 schlagen mit dem bisherigen Code fehl (Fehlschlagsnachweis), 7/7 nach der Optimierung (4,80 s). Gemessene Reduktion bei 50 Delay-Events mit offener Bank: 50 Synchron-Scans → 1 Scan (98 %), 450 → 9 GetItemCount-Aufrufe (98 %). Basiscommit und änderungsführender Arbeitsbaum getrennt dargestellt; der Lauf ist kein Release/keine Release-Evidenz, deshalb bleibt der Release-Nachweis in docs/evidence/index.json unberührt. [Bericht](reports/tests/20261126-023618-f9e921.zip).

Stand: 23.11.2026. Maschinenlesbare Nachweise in [docs/evidence/index.json](docs/evidence/index.json).

## Beta.27 · Rezeptbeschaffung und Herstellserien

Zweite Meisterpult-Probe vom 23.11.2026, Basis `6daffa3fc5c27449e07a441cb6a75dccc178b5f0` plus Arbeitsbaum. Release-Build und vollständige WoWLua-Suite: 685 bestanden, 0 fehlgeschlagen, 0 übersprungen in 196,50 s. Geprüft wurden unter anderem Händlerguide mit Materialwahl, Optionen, Rückkehr und Werkstattpult-Navigation. [Bericht](reports/tests/20261123-154140-5bf06d.zip), [Quell- und Grafikprüfsummen](docs/evidence/beta27-meisterpult-v2-manifest.json). Installationsvergleich: 86 Dateien identisch. UI-27 bleibt zur Spielabnahme offen.

Der nachfolgende Meisterpult-Prüfstand vom 23.11.2026 basiert auf `6daffa3fc5c27449e07a441cb6a75dccc178b5f0` plus Arbeitsbaum. Vollständiger Release-Build und Camelot-Quellsuite mit 683 bestandenen, 0 fehlgeschlagenen und 0 übersprungenen Tests in 238,90 s. Nachweis `beta27-meisterpult-local-full` im Index. Separater Emulatorabruf des geöffneten Händlerguides mit 10 Fluxus. Lokale Forever-Installation per SHA256 bestätigt. Sichtprüfung durch den Spieler offen (UI-27).

Vollständige WoWLua/Camelot-Quellsuite mit Blizzard-UI, 683 bestanden, 0 fehlgeschlagen, 0 übersprungen, 219,87 Sekunden. Lokale Paketversion `3.9.0-beta.27-alpha+6daffa3`, Basis `6daffa3fc5c27449e07a441cb6a75dccc178b5f0` plus Arbeitsbaum. Der erste Zwischenlauf hatte einen Dateizugriffsfehler beim Laden einer Suite. Der abschließende Lauf prüfte den fertigen Quellstand. Bericht und SHA256-Quellmanifest stehen in [docs/evidence/index.json](docs/evidence/index.json), Eintrag `beta27-procurement-local-full`. Bericht `reports/tests/20261123-072955-849f50.zip`.

Die ProcurementSuite prüft sieben Fälle, darunter Kochkunst 219/225 mit sechs sicheren und 30 ausdrücklich gewählten Versuchen, grüne Materialreserve, unterschiedliche Rezeptwege, einen Händlerkauf mit verzögertem Eingang und den exakten AH-Sofortkauf samt Preisänderung und Beleg-ID. Die bestehende RodSuite prüft Werkzeugketten und die Rückkehr zum Hauptauftrag. Ungeklärt bleibt, welcher Clientzustand den gemeldeten Silberruten-Stillstand ausgelöst hat. Der kurze Forever-Test steht unter PROC-27.

## Ingenieurskunst 1–300, zusammenhängende WoWLua-Abnahme

**300/300 erreicht, „Fertig“ erst am Ziel.** WoWLua 0.13.14, Camelot, deutsche Guide- und
Client-Texte, simulierter Charakter auf Stufe 60. Lokaler Build
`3.9.0-beta.26-alpha+6daffa3` mit Release-Profil. Testbasis
`6daffa3fc5c27449e07a441cb6a75dccc178b5f0` plus neuer lokaler Test.
Addon-Laufzeitquellen und Build-Konfiguration stimmen mit dem Tag-Quellstand überein.

- Einzeltest **1/0/0** in 9,93 s. [Einzelbericht](reports/tests/20261121-044754-876855.zip).
- Gezielte Regressionen für Rang, Route, Guide, Undercity und Produktion **71/0/0**
  in 38,67 s, 39 Dateien. [Bericht mit Prüfsummen](reports/tests/20261121-044823-d557c7.zip).
- Die Simulation verwendet eine kontrollierte Kupferrohr-Variante mit festen Zutaten,
  Preisen und Skillchancen. Der vollständige native Rezeptkatalog pro Rang, echte
  Auctionator-Angebote und die Forever-Ökonomie sind nicht Bestandteil des Durchlaufs.
  AH-Preisstand und Kaufdialog kommen aus der Testumgebung. Die Auftrags- und Guide-Logik
  sowie die Ereignisverarbeitung stammen aus CraftDeja.

| Übergang im selben Auftrag | Auslöser | Ergebnis |
|---|---|---|
| 1/75, AH | Beruf öffnen, im Werkstattpult Route planen, AH-Suche | 74 Herstellungen, 148 Barren und 74 Fluxus. Zwei bestätigte Barren im Teilkauf lassen 146 im AH offen. |
| AH → Post → Händler | Kaufbestätigung, Post geöffnet, bestätigter Taschenzuwachs, Händler geöffnet | Postbedarf erst nach verbuchtem Bestand erledigt. Der Händler bietet 74 Fluxus an. |
| Händler → Herstellung | Kaufklick und Taschenupdate, danach Klick auf den nativen Herstellknopf | 74 Herstellungen verbrauchen die Zutaten, eine davon ohne Skillpunkt. Bei 74/75 plant der Guide genau eine weitere Herstellung mit zwei Barren und einem Fluxus. |
| 75/75 → 75/150 | Trainer öffnen, „Rang lernen“, Client bestätigt höhere Grenze | Genau ein bestätigter Trainingskauf, derselbe Auftrag fordert die nächste Materialmenge an. |
| 150/150 → 150/225 und 225/225 → 225/300 | „Lehrer zeigen“, manueller Kauf im simulierten Trainerfenster, höhere Grenze per Client-Ereignis | Guide setzt denselben Auftrag nach beiden Rangwechseln fort. Für diese Ränge fehlt der verifizierte Kauf anhand der Service-ID. |
| 300/300 | Bestätigter Herstellungserfolg | „Fertig“ ist deaktiviert. Beide simulierten Zutatenbestände sind aufgebraucht. |

Die anfänglichen Fehler des Testaufbaus betrafen die native Frame-Attrappe, den
Rangbalken und erlaubte AH-/Händler-Übergänge. Der bereinigte Lauf erreichte 300.
Der separate, frühere isolierte Guide-Test scheiterte an der anfänglichen
Sichtbarkeitsprüfung. Der Lauf der gesamten Undercity-Testdatei reproduzierte den Fehler
nicht. Die echte Sichtbarkeit bleibt Teil der Live-Abnahme.

**Forever-Checkliste:** An einem erreichbaren Rang einen Teilkauf bestätigen und Post
abholen. Händlerangebot und Restmenge prüfen und den originalen Herstellknopf am Amboss
verwenden. Bei einer Herstellung ohne Skillpunkt auf offenen Bedarf achten. Bei 75/75
prüfen, ob der Guide den passenden Lehrer zeigt und erst mit 75/150 weiterplant.
Für 150/150 und 225/225 den Rang im Lehrerfenster lernen und die Fortsetzung prüfen.
Der Abschluss bei Skill 300 kann mit einem höherstufigen Testcharakter abgenommen werden.

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
