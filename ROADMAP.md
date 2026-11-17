# Roadmap — Stand 15.11.2026

## beta.25 veröffentlicht und installiert — 17.11.2026, 06:07

- Release-Commit/Tag **0b5d627fb68f6ac6f65d0ad3e0faac8cc3cec5c9 / v3.9.0-beta.25**, Feature codex/material-source-choice. Actions https://github.com/DejaBansh/CraftDeja/actions/runs/44020213463 erfolgreich: package/upload/description jeweils success; **657/0/0**,324Dateien,**660.03s**,26Releasechecks. Genau ein echter Upload über offizielle API, **CurseForge-Datei9660180 / Beta / Forever1.60.1 (ID17053)**. API meldet accepted_moderation_pending; separater Approved-Status nicht abgefragt. Öffentliches CDN-ZIP bereits abrufbar und SHA256-verifiziert.
- Öffentliches Paket **dist/packages/CraftDeja-3.9.0-beta.25-release.zip**, SHA256 **5D87821D290827637FABC46C15C7EE167380606FCE6123534870701EAF003976**. Alle81Payload-Dateien und freigegebenen Texte einzeln geprüft. Alle77installierten Laufzeit-/Grafikdateien zusätzlich bytegleich zum veröffentlichten Payload bestätigt. Unterschiedlicher lokaler ZIP-Containerhash ist kein Laufzeitunterschied; kanonischer lokaler und CI-Payload sind identisch.
- Installiert **3.9.0-beta.25 / release6eb9372c**, Backup aller78Altdateien verifiziert, keine Dev-Instrumentierung/Runtime. Automatischer Bericht **reports/install/beta25-20261117-055802-bericht.zip**, um PUBLISHED-PAYLOAD-CHECK.json ergänzt. Keine Spielprozesse in diesem Auftrag beendet, vor/nach Installation vollständig geprüft; Installer verändert keine WTF-/SavedVariables-Dateien.
- Teilbarer Gesamtbericht **reports/material-sources-beta25.zip** mit Analyse, finalen/gezielten/getaggten Tests, Matrix, emulierten Ansichten, Uploadquittung und Installationsnachweis. Keine raw Spielerlogs/Screenshots im Repository oder Spielerpaket. DE/EN-Patchnotes exakt aus freigegebenem Tag am Upload veröffentlicht.
- Beschreibungstatus **manual_author_console_required**: Job bereitet nur Text vor. Öffentliche Hauptbeschreibung nicht vom Workflow geändert; releases/3.9.0-beta.25/description.md über offizielle Author Console übernehmen, Datei dafür NICHT erneut hochladen.
- Nächster Schritt: tatsächlicher Live-Test nach docs/MATERIAL_SOURCES_BETA25.md (Bank/AH, echte Reagenzalternative, Erz→Barren mit Rückkehr,75/75→Lehrer→150). Annahme des früheren Preisvergleichs nur teilweise zutreffend: der eigene Verhüttungspfad wurde vorher nicht verglichen. Aktuelle eigene Bank-/AH-Preise und Live-Abnahme nicht durch Simulation bewiesen. Bekannte Daten-/Sonderfallgrenzen bleiben sichtbar. Kein Merge nach main; Versions-Tags unverändert lassen.

## beta.25 lokal installiert — 17.11.2026, 05:58

- Release-Commit/Tag **0b5d627fb68f6ac6f65d0ad3e0faac8cc3cec5c9 / v3.9.0-beta.25** auf codex/material-source-choice gepusht, Remote-Feature und Tag dereferenziert identisch. Echter Actions-Lauf https://github.com/DejaBansh/CraftDeja/actions/runs/44020213463 noch im Paket-/Testjob; CurseForge-Upload und Datei-ID noch ausstehend. Kein main-Merge.
- Kanonischer getaggter lokaler Release nochmals657/0/0,324Dateien,200.99s: reports/curseforge-beta25-local/source/reports/tests/20261117-055309-55a048.zip. Sämtliche aufgezeichneten Quellen/Tests/Inputs dieser Privatkopie geprüft. Reguläre Arbeitskopie separat657/0/0,208.54s; Hashsätze nicht zwischen verschiedenen Zeilenenden-Checkouts vermischen.
- WoW war nach Hinweis bereits vollständig beendet; vor Backup, vor Ersatz und nach Installation erneut vollständig geprüft. Kein Client in diesem Auftrag beendet. Installiert **3.9.0-beta.25 / release6eb9372c**, alle77Laufzeit-/Grafikdateien bytegleich zum kanonischen Paket. Vollbackup aller78vorhandenen Dateien vor und nach Installation SHA256-geprüft: reports/curseforge-beta25-local/source/reports/install/verified-20261117-055802/CraftDeja-before-install.zip. Keine Dev-Runtime/automatische Instrumentierung, keine WTF-/SavedVariables-Änderungen.
- Teilbarer Installationsbericht **reports/install/beta25-20261117-055802-bericht.zip**. Build **dist/packages/CraftDeja-3.9.0-beta.25-release.zip**, DE/EN-Notizen daneben; aktuell kanonisches lokales ZIP SHA2562224E56A2997A4E28F3A3427F0457EB7522339F8A0C1981C2DF87AF0A546BE14. Nach Upload das tatsächliche CI-/CDN-Paket zusätzlich prüfen; Containerbytes können abweichen, Laufzeitdateien müssen verglichen werden.
- Nächster Schritt: CI abschließen, einzelne Uploadquittung und CF-Datei-ID sichern, öffentliche Datei nach Möglichkeit SHA256 prüfen, Beschreibungstatus separat melden. Bereits lokal testbar nach docs/MATERIAL_SOURCES_BETA25.md. Reale AH-Preise/nächster Lehrer und vollständige Live-Abnahme weiterhin offen.

## beta.25 — finale lokale Freigabe, 17.11.2026, 05:52

- Vollsuite reports/tests/20261117-054821-3541b2.zip: **657/0/0**,324Dateien,**208.54s**, Release-Build bestanden. WoWLua0.13.14/Windows/Camelot/Blizzard-UI. Alle aufgezeichneten Runtime-/Test-/Inputhashes mit finalem Stand geprüft.23neue Material-/Rangfälle, auch Teilbestand/Twinkbestand/Post, nativer kompletter Verhüttungsablauf und Produktionsaufträge ab300.
- Zielprüfung reports/tests/20261117-054730-b4238e.zip:23/0/0 in7.58s samt emulierten Ansichten. Finale Matrix reports/workshop-matrix/20261117-054835:1920x1080/3440x1440 bei UI65%/100%, jeweils14/0/0, Runtime-/Grafikhashes geprüft. Keine Live-/FPS-Abnahme.26Release-Schutztests bestanden, API dabei ausschließlich gemockt; Actionlint ohne Fehler. Bekannte Root-Lazy-Getter-Warnung und vier unbenutzte Testlocals, keine Compilerfehler.
- Geprüfte DE/EN-Texte releases/3.9.0-beta.25; passender veröffentlichter Beta-Vorgänger9656532/Quellcommit a52b9cf09f047b4bdcedf596a7007cdc3ba97409 mit offiziellem CDN-Hash belegt. Diffreview fertig, Freigabe true. Nächster Schritt: exakt neuen beta.25-Tag bauen, Feature/Tag pushen, tatsächliche CI- und Uploadquittung prüfen. Noch keinen Erfolg des ausstehenden Uploads behaupten.
- Vollständige Prozesssicht05:50: WoW beendet. Installationshinweis gegeben; nach erneutem Prozesscheck kanonischen geprüften Release mit vorhandenem Backupskript installieren. main bleibt unverändert. Kein neuer Wochenjob und keine unkontrollierte Datenbankaktualisierung in diesem Patch. Frühere Zwischenläufe sind keine Freigaben des finalen Standes.

## beta.25 — Materialquellen und Rangwechsel, 17.11.2026

- Neuer Feature-Branch codex/material-source-choice aus sauberem74d99f64add3d2aca1c140edd3af742636eb7eb1. Version3.9.0-beta.25; keine vorgefundenen Änderungen überschrieben. Neues MaterialSources-Modul, native Reagenzienprüfung und Rangpriorität; tatsächliche Analyse und Live-Plan docs/MATERIAL_SOURCES_BETA25.md.
- Annahme differenziert: Bisher kein eigener berufübergreifender Erz→Barren-Vergleich in diesem Pfad; frühere Barrenkauf-Empfehlung beweist daher keinen durchgerechneten Preisvorteil. Gleiche Friedensblume auf Bank/AH hat denselben aktuellen Marktwert, aber unterschiedliches zusätzlich benötigtes Gold; kein erfasster historischer Einkaufspreis oder garantierter Verkaufserlös. Alternative Reagenzien nur bei echter nativer Auswahl.
- Explizite Materialwahl: Taschen/gespeicherte Bank, echte Alternativzutaten, bekannte eigene Konversionen. AH-Wahl reserviert alten lokalen Bestand; interne Bankbewegungen/Twinkbestand gelten nicht als neue Lieferung. Fehlende/veraltete Preise sichtbar; keine Nullpreisbehauptung. Bestehende Käufe/Post und native Mengen-/Preisprüfungen erhalten. Wahl pro Abschnitt/Produktionsauftrag gespeichert, manuell änderbar, während Pending-Kauf/Craft gesperrt.
- Nativ bestätigte eigene Verhüttung kann zur ursprünglichen Berufsroute zurückführen. Keine rekursive Vollautomatik, keine geschützten Craft-Aufrufe, kein neuer dauernder Timer/OnUpdate. Unbekannte Konversionen nicht behaupten; Kupfer-Hinweis öffnet nur zur Prüfung. Native Reagenzienbelegung anhand installierter Blizzard-UI1.60.1.70938 geprüft.
- Ranglimit hat Vorrang vor erreichtem Routenziel. Nach realer Skillgrenzen-Erhöhung setzt ein am Cap endender Auftrag fort; echte Teilziele bleiben fertig. Bekannter lokaler Ingenieursrang-Lehrer Franklin Lloyd ergänzt (Referenz76/74, nicht live bestätigt). Rangangebot nur eindeutig, geöffnet, unverändert, bezahlbar und nach Klick; unbekannte/linklose Identitäten weiterhin nativ prüfen.
- Neue Suite23/0/0,7.58s, reports/tests/20261117-054730-b4238e.zip samt emulierten Ansichten. Ältere655er-Vollsuite203.27s war vor zwei weiteren Grenzfällen; finale vollständige Prüfung läuft erneut. Bestehende Bank-/Stations-/Werkstatt-Fixtures starten explizit nach angenommener Eigenbestandswahl, neue Suite prüft diese Wahl selbst. Intermediate Fehlerberichte sind keine Freigabe.
- Noch kein neuer Tag oder Upload. Veröffentlichung erst nach finaler Vollsuite, Hash-/Paketprüfung und Review. Keine main-Änderung. Installationshinweis gegeben: WoW vollständig schließen; ohne aktuellen Prozessnachweis nicht ersetzen. Neue Live-Abnahme weiterhin offen.

## beta.24 installiert — 16.11.2026, 23:45

- Nutzer hat das Beenden von WoW ausdrücklich angefordert. Genau den verifizierten Forever-Wow.exe-Prozess44644 regulär mit CloseMainWindow geschlossen, Exit bestätigt; kein erzwungenes Beenden nötig. Vollständige Prozessprüfungen vor Backup, vor Ersetzen und nach Installation: WoW beendet.
- Installiert: **3.9.0-beta.24**, **release2968f7b8**, Quellcommit **a52b9cf09f047b4bdcedf596a7007cdc3ba97409**. Ausführung des bestehenden Install-VerifiedCraftDeja.ps1 aus der vollständig getesteten kanonischen Privatkopie; eigener lokaler Prüfbranch nur dort. Tatsächlicher Projektbranch bleibt codex/undercity-guide-fixes; main und Release-Tag unverändert.
- Vollbackup reports/curseforge-beta24-local/source/reports/install/verified-20261116-234504/CraftDeja-before-install.zip: alle78vorhandenen Dateien SHA256-geprüft, Altinstallation vor Ersatz unverändert bestätigt, Archiv danach erneut geprüft. Alle77installierten Laufzeit-/Grafikdateien identisch zum getesteten Build und zum tatsächlich veröffentlichten CurseForge-Payload9656532. Vier zusätzliche Lizenz-/Herkunftsdateien sind Beigaben der81-Dateien-Distribution. Keine Dev-Runtime/automatische Instrumentierung; WTF/SavedVariables unverändert.
- Teilbarer Bericht **reports/install/beta24-20261116-234504-bericht.zip**, inklusive zusätzlichem PUBLISHED-PAYLOAD-CHECK.json. Unveränderte634/0/0-Quellprüfung und sämtliche aufgezeichneten Eingaben vor/nach Installation geprüft; keine unnötige neue Vollsuite. Erster Installeraufruf aus detachedHEAD brach vor Backup/Ersetzen an fehlendem Branchnamen ab (Bericht234448); erneuter Lauf mit benanntem privatem Prüfbranch vollständig erfolgreich.
- Nächster Schritt: WoW starten, /cdj version prüfen und Undercity-Kupferrohr-Ablauf nach docs/UNDERCITY_GUIDE_BETA24.md testen; echte Giftfreischaltung vor/nach Quest separat prüfen. Live-Abnahme weiterhin offen. Wochenabgleich ist analysiert, noch nicht implementiert. Frühere Nicht-installiert-Angaben unten sind historisch.

## beta.24 veröffentlicht — 16.11.2026, 23:41

- Release-Commit/Tag: **a52b9cf09f047b4bdcedf596a7007cdc3ba97409**, **v3.9.0-beta.24**; Feature codex/undercity-guide-fixes. Remote-Branch und dereferenzierter Tag wurden auf diesen Commit geprüft. main bleibt711d463af4c17f1e711248bb409f1dd5fecfe303, kein Merge; alter beta.23-Tag unverändert.
- Echter Actions-Release https://github.com/DejaBansh/CraftDeja/actions/runs/43969872088: package/upload/description jeweils success. Vollsuite634/0/0,323Dateien,765.00s;26Pipelinechecks. Authentifizierte offizielle Versions-API löst Forever1.60.1/Typ88568 eindeutig auf **17053** auf. Genau ein echter Upload, **CurseForge-Datei9656532**, Beta. API-Status accepted_moderation_pending; separater Approved-Status nicht geprüft. Offizieller CDN-Download inzwischen erfolgreich und bytegleich.
- Offizielles ZIP dist/packages/CraftDeja-3.9.0-beta.24-release.zip: **F16968A9AFD2A33A50E6A6F6DEFC6F6C3B8C3158683D4DA80E5A20AC4AA26116**. Alle81Payload-Dateien und freigegebenen Texte einzeln geprüft. Gleiches Payload wie lokaler getaggter Build; ZIP-Containerhash wegen Packungsdetails verschieden. ExakteTOC3.9.0-beta.24/16001/release; keine Dev-Runtime/automatische Instrumentierung.
- Lokaler exakt getaggter Release erneut634/0/0 in204.17s: reports/curseforge-beta24-local/source/reports/tests/20261116-232518-0ebfc4.zip. Arbeitskopie634/0/0 in209.27s: reports/tests/20261116-231943-98a8e1.zip. Unterschiedliche Checkout-Zeilenenden können den diagnostischen Buildfingerabdruck ändern; beide Hashsätze jeweils gegen ihre eigene Quellkopie geprüft. Keine Vermischung als bytegleiche Quelldateien behaupten.
- Uploadquittung, CI-Artefakte/Digests, CDN-ZIP und Tests lokal reports/undercity-beta24/; teilbare Zusammenfassung reports/undercity-beta24.zip. Berichte nicht eigenständig öffentlich hochgeladen; Actions-Artefakte gehören zum ausdrücklich freigegebenen Releaseworkflow.
- Beschreibungsjob bedeutet **manual_author_console_required**, keine öffentliche Beschreibungsänderung. Freigegebener DE/EN-Text releases/3.9.0-beta.24/description.md, Patchnotes am hochgeladenen Paket veröffentlicht. Nur Beschreibung manuell übernehmen, Datei nicht erneut hochladen.
- **Nicht installiert:** vollständige Prozessprüfung findet weiterhin Wow.exe44644. Installiert bleibt alterbeta.23-Stand; Client nicht beendet, Spielinstallation/WTF unverändert. Vorbereitete exakte Installation reports/undercity-beta24/NEXT-INSTALL.md. Erst nach geschlossenem WoW mit bestehendem geprüftem Backup-/Installationsskript fortfahren. Live-Abnahme des neuen Ablaufs weiterhin offen.
- Nachprüfung Händlerrezepte: kein globaler Wochenabgleich. Neuere offizielle Referenz1.10.1/Datei9653856 gefunden, gegenüber Importbasis1.9.1. Neue Forever-Beobachtungen und zusätzliche Währungskosten benötigen eigenen Herkunfts-/Daten-Diff; Horde/unbestätigte Quellen bleiben begrenzt. docs/VENDOR_RECIPE_AUDIT.md beschreibt Befund und vorgeschlagenen Wochenablauf; noch kein Wochenjob eingerichtet. Gifte-Freischaltung bereits im geprüften beta.24-Fix enthalten.

## beta.24 — nächste Abnahme und Datenpflege, 16.11.2026

- Umgesetzt: Ingenieursauftrag vor automatischen Gift-Prompts schützen; echte Giftfreischaltung prüfen; aktuelle Teilmengen, Post und offene Käufe für AH-Liste vereinheitlichen; Livepreis nach AH-Schließen behalten; benannter Händlerkauf; proportionale Guidegrafik. Automatisierter vollständiger Ablauf mit zwanzig neuen Regressionen; Live-Abnahme siehe docs/UNDERCITY_GUIDE_BETA24.md noch offen.
- Stationsanforderungen und beobachtete Arbeitsbereiche sicher markieren/aufräumen. OFFEN: verifizierter Forever-Stationsatlas für Erstbesuche, verlässlicher Zugangs-/Ebenengraph und tatsächliche begehbare Reisewege. Aktuell nur bestätigte Punkte derselben Karte/Ebene/Instanz; keine Vollständigkeitszusage.
- Nutzerwunsch geprüft: wöchentlicher Händlerrezept-Abgleich fehlt. OFFEN: autoritative Forever-Datenquelle, Herkunfts-/Lizenzprüfung, wöchentlicher Daten-Diff und fachliche Freigabe; gegebenenfalls Besuchserinnerung für alte lokale Beobachtungen. Ungeöffnete Händler lassen sich im Addon nicht weltweit abfragen. Nicht mit vorhandener 7-Tage-Lernkostengültigkeit verwechseln; keine wiederkehrenden Vollscans im Spiel einführen.
- Nach bestandenen Prüfungen neue beta.24 über bestehenden Feature-/Tag-Workflow veröffentlichen. Kein main-Merge. Hauptbeschreibung benötigt weiterhin offiziellen manuellen Author-Console-Schritt; Datei-/Changelog-Upload separat nachweisbar.


## Hinweis zum vorhandenen Tag — Abschlussprüfung 16.11.2026

- refs/tags/v3.9.0-beta.23 existiert bereits lokal und remote als annotierter Tag d42f80fe003d448fb6e99f14f3a87663120ae00c auf Commit 642dc69d40c0e35b76735822f665183dae64d68a; Tagger-Zeit 2026-11-16T21:11:29Z, vor dem neuen Dry-Run-Branchlauf. Nicht durch diesen Lauf erstellt, nicht verschoben/gelöscht/erneut gepusht. Früheres „keine Tags“ bedeutet: von diesem Auftrag keine erstellt oder gepusht.
- Aktuelle Actions-API listet den einen erfolgreichen Branch-Dry-Run 43959442195; keine neue echte Veröffentlichung. beta.23 ist bereits CurseForge-Datei 9654021. Ausschließlich neue Version für nächstes echtes Update verwenden; keinen erneuten beta.23-Upload auslösen.

## GitHub-Dry-Run erfolgreich — 16.11.2026, 22:36

- Echter Actions-Lauf https://github.com/DejaBansh/CraftDeja/actions/runs/43959442195 erfolgreich; geprüfter Commit 1a5100095632199fb2272b74abcb2ff39f4216f4 auf codex/curseforge-dry-run. package success, upload skipped, description skipped. Kein Token im Testjob, keine echte Veröffentlichung oder Beschreibungsänderung; Tokenberechtigung damit nicht geprüft.
- Vollsuite: 614/0/0, 322 Dateien, 788.85s, Windows/Camelot/Blizzard-UI/WoWLua 0.13.14. 26 Pipeline-Prüfungen ebenfalls grün. Paket 81 Dateien einzeln verifiziert, exakt Version 3.9.0-beta.23/16001/release. Keine neue Live-Abnahme daraus ableiten.
- GitHub-Artefakt 14274836707 / curseforge-package-43959442195 heruntergeladen und GitHub-Digest C24F64888E15F3FA289DD084891BF9110575884EAB931911EC938E89F32FE0C5 geprüft. Enthaltenes Paket SHA256 9A7536F1FAED035BBEC87EB76BB2AE00751A358038B90597DDD28E00C0AF5D60; Texte und alle 81 Payloadhashes geprüft. Lokal reports/github-dry-run-43959442195-bericht.zip, inklusive Testnachweis, Run-/Jobstatus und Baselinebeleg.
- Bereits veröffentlichte Datei 9654021 separat vom offiziellen CDN heruntergeladen: ZIP SHA256 F0633ABFBB186A479ECC85FB33FFE0FE1E194B4C4D6B645B07B0D250052A3A31 identisch zum originalen lokalen beta.23-Release für Quellcommit e4b8bdcb69dccd71a05b854d446ee7c8b0cf9d9d. Damit Beta-Baseline für nächstes echtes Update belegt; kein Rückgriff auf unzugeordnete alte 3.8-Beta nötig. releases/published-history.json aktualisiert.
- Legacy-veröffentlichte beta.23-TOC enthält alpha+e4b8bdc; künftige Tag-Pakete verlangen exakte Version ohne diesen Zusatz. beta.23 nicht erneut freigeben/hochladen; REVIEW.md markiert die bisherige Vorabprüfung als Historie. Nächstes echtes Update braucht neue Versionsnummer, reale Änderungen, eigenen Diff und DE/EN-Texte.
- main bleibt 711d463af4c17f1e711248bb409f1dd5fecfe303. Keine Tags, kein Merge, keine Spielinstallation. Ergebnisdokumentation nur auf codex/curseforge-release pushen, damit kein zweiter Testlauf ausgelöst wird. Nächster Schritt für Nutzer: grünen Run und Artifacts ansehen; Automatisierungs-Dry-Run ist abgenommen.

## GitHub-Dry-Run-Auslöser — 16.11.2026

- Nutzer hat codex/curseforge-release gepusht; beta.23 ist nach Author-Console-Screenshots als Beta Approved, Datei 9654021, bereits veröffentlicht. Hauptbeschreibung laut Nutzer manuell geändert, CF_API_TOKEN laut Nutzer eingerichtet. Tokenberechtigung nicht geprüft; keine erneute beta.23-Veröffentlichung. releases/published-history.json dokumentiert Beobachtung und noch nicht verifizierten Remote-Payloadhash.
- Eigener Push-Auslöser ausschließlich für codex/curseforge-dry-run ergänzt, damit Actions ohne main-Merge ausgeführt werden kann. Dieser Branch erzwingt DryRun, liest Kandidatenversion aus Manifest, kein Secret im Paketjob. Upload benötigt explizit refs/tags/, Beschreibung wird im Branchlauf übersprungen. Normale Branch-Pushes bleiben ohne Workflowlauf.
- Actionlint und alle 26 Release-Pipeline-Schutztests erneut bestanden (API gemockt). Runtime-/Testquellen unverändert; die volle 614er-Suite wird jetzt im tatsächlichen GitHub-Dry-Run ausgeführt. Remote-Ergebnis noch ausstehend; nicht als bestanden markieren. Kein neuer Tag, kein CurseForge-Upload, kein main-Merge, keine Spielinstallation.

## CurseForge-Dry-Run abgeschlossen — 16.11.2026, 21:58

- Code-/Workflowcommit 25bee977a941f9d44b5ba340c126476214e67c83 auf codex/curseforge-release. Lokaler isolierter Dry Run reports/curseforge-dry-run-20261116, vollständiges Prüfpaket reports/curseforge-dry-run-20261116.zip. Kein GitHub-Actions-Lauf gestartet, kein Push/echter Tag, Upload, Merge oder Spielinstallationswechsel.
- Vollsuite über Test-CraftDeja.ps1 (nun --locked): 614/0/0, 322 Dateien, 196.67s, WoWLua 0.13.14/Windows/Camelot/Blizzard-UI. Automatischer Bericht source/reports/tests/20261116-215443-589356.zip im Dry-Run-Ordner, auch artifacts/TEST-REPORT.zip. Bekannte W1034-Lazy-Getter-Warnung unverändert.
- 26 Release-Schutztests bestanden, API vollständig gemockt. Actionlint 1.7.7 ohne Workflowfehler, alle PowerShell-Skripte parsebar. Description-only mit exakt getaggtem Checkout-Text in privater Testkopie geprüft; echte Veröffentlichung stoppt an offener Historienfreigabe vor Netzwerkzugriff.
- ZIP artifacts/CraftDeja-3.9.0-beta.23.zip: exakt 3.9.0-beta.23, release/16001, CraftDeja/ als einzige Wurzel, 81 Dateien einzeln SHA256-geprüft. SHA256 D53E0DB02C3BD6C12F2732128025ABAE34E9473545E4168874B233B8FD533DE4. Zusätzliche LICENSE, Licenses/ und DATA_SOURCES übernehmen vorhandene Herkunfts-/Lizenzbelege; generiertes LICENSES allein deckte importierte Daten nicht ab. Keine Dev-Instrumentierung/Runtime.
- DE/EN-Beschreibung, Patchnotes, Metadaten, Code-Diff/Commitliste und Prüfbelege im Artefaktordner. Veröffentlichungsfreigabe weiterhin false: aktueller passender Beta-Kanal benötigt verifizierte alte Datei-/Quellzuordnung; öffentliche beta.18-Datei 9642059 ist Release. Keine angeblich vollständige Beta-Diffprüfung. REVIEW.md enthält nächste Schritte.
- CF_API_TOKEN später als Repository-Actions-Secret setzen; kein Token erstellt/gelesen/veröffentlicht. Authentifizierte eindeutige Forever-Versions-ID-Auflösung vor Upload noch offen. Hauptbeschreibung über offizielle Author Console manuell, separater Status/description-only-Modus ohne Duplikatdatei. Offizielle API bietet keine dokumentierte Schreiboperation dafür. Keine vollständige Dreifachautomatisierung behaupten.

## CurseForge-Automatisierung — 16.11.2026, Dry Run in Vorbereitung

- Neuer Branch codex/curseforge-release aus sauberem 962a28b. Kein bisheriger Workflow lokal oder auf GitHub; neuer Tag-/Dispatch-Workflow verändert keine Branch-Pushes. Einzelheiten und Bedienung docs/CURSEFORGE_RELEASE.md.
- Release-Texte DE/EN versioniert unter releases/3.9.0-beta.23; Review des tatsächlichen Code-Diffs seit lokaler beta.18-Quelle und öffentlicher CurseForge-Historie. Nutzer meldet beta.23 im bisher getesteten Umfang sehr gut; keine vollständige Live-Abnahme daraus ableiten.
- Offizielle Upload API ermöglicht Datei und Markdown-Changelog, aber keine dokumentierte Hauptbeschreibungsänderung. Beschreibung bleibt offizieller Author-Console-Schritt mit getrenntem Status und unabhängigem description-only-Modus ohne Dateiupload/Token. Keine privaten Endpunkte erfunden.
- Öffentliche beta.18-Datei 9642059 ist Release, nicht Beta. Letzte sichtbare Beta 3.8.0-Beta1 noch ohne verifizierte Datei-ID/Quellzuordnung; echte Veröffentlichung bewusst gesperrt (approved/historyReviewComplete=false). REVIEW.md nennt die Auflösung. Versions-API benötigt Token (401 ohne); Forever-Typ 88568/Name 1.60.1 wird vor POST eindeutig aufgelöst, ID nicht geraten.
- 26 lokale Release-Regressionen bestanden (API ausschließlich gemockt); offizieller Actionlint 1.7.7 mit SHA256 geprüft und Workflow ohne Fehler validiert. Vollständiger Dry Run/Testnachweis folgt. Kein Tag/Upload/öffentliche Beschreibung, kein main-Merge und keine Spielinstallation in diesem Auftrag.

## beta.23 — Werkstattpult, 16.11.2026

- [x] Fensterbeziehungen geprüft und bestehendes Routenfenster in Übersicht mit Navigation, Rezeptabschnitten, Status-/Detail- und Kostenkarten überführt; seltener genutzte Originalaktionen erhalten.
- [x] Eigenständiger Guide, konkrete Hauptaktion, sichtbare Gründe/Werkzeuge, aufklappbare Details, ruhige Blockierung und einmaliger sichtbarer Bereitschaftsimpuls.
- [x] Vier eigene getrennte hochauflösende Assets mit PNG-Quellen/transparenter TGA-Ausgabe, Logo erhalten; keine eingebrannten Spielwerte.
- [x] 614/0/0 breit, 204.95s; 382 Hashes identisch; finale Suite reports/tests/20261116-204829-9f7d8f.zip.
- [x] Vier echte Bildschirm-/UI-Skalierungsfälle 1920x1080/3440x1440 x 65%/100%, je 14/0/0, PNG-Abmessungen und Quellen/Grafiken geprüft. Quellemulation ausdrücklich gekennzeichnet.
- [x] Finalen Release e4b8bdc bei vollständig beendetem WoW mit geprüftem Vollbackup installiert; 77 Payload-Dateien und portable ZIP identisch, automatischer Installationsbericht verified-20261116-205431-bericht.zip.
- [ ] Layout/Aktionen mit echter Forever-/ElvUI-/TSM-Konfiguration live prüfen. Keine neue Performance- oder komplette Live-Abnahme behaupten.

## beta.22 — Trainer und Zugriff, 16.11.2026

- [x] Kupferrohr-Unterstadt und fehlendes Wiederöffnen im unveränderten beta.21 reproduziert; gleiche Clientfälle in beta.22 bestanden.
- [x] Gemeinsame Standortwahl für alle unterstützten Berufe/Ränge, 435 ausdrückliche Rezept-Lehrerlisten, lokale Angebotsbeobachtungen; Voraussetzungen/Fraktionen erhalten. Referenzabdeckung bleibt begrenzt.
- [x] Native Wiederöffnungswege ohne eigenen Vollscan, Minimap-Zugriff und native Addon-Einstellungen mit DE/EN und gespeicherten Schaltern.
- [x] 600/0/0 breit, 182.51s; echte UI gerendert und Prüfsummen abgeglichen. reports/tests/20261116-194918-dbcd1e.zip.
- [x] Release beta.22 bei beendetem WoW installiert; 74 Backup-Dateien und 73 Payload-Dateien SHA256-verifiziert. Bericht reports/install/verified-20261116-195436-bericht.zip. Paket/DE-EN-Patchnotes unter dist/packages, Gesamtbericht reports/trainer-navigation-beta22.zip.
- [ ] Live Unterstadt/Franklin/Angebot, Berufsaufruf, unveränderten Auftrag, Minimap und Addon-Einstellungen nach docs/TRAINER_NAVIGATION_BETA22.md prüfen. Keine globale Lehrer-/Reisekosten-Vollständigkeit behaupten.

## beta.21 — Bankablauf, 16.11.2026

- [x] Bankstillstand auf unverändertem beta.20 reproduziert: Detailsaktion führte keine Bewegung aus.
- [x] Gespeicherte Händleroption DE/EN; geschlossenen Guide bei Option aus geschlossen halten, manuellen/Berufsaufruf und aktiven Auftrag erhalten.
- [x] Explizit gestartete Einlagerung/Entnahme, Teilstapel und kompatible Ziele, beidseitige Bestandsbestätigung, genaue Restmengen und sichere Fortsetzung bei Unterbrechung.
- [x] 17 Regressionen einschließlich drei vollständiger Modulabläufe; finale breite Suite 589/0/0, 290.54s, reports/tests/20261116-183835-968304.zip. UI gerendert geprüft. Release-Source-Validierung bestanden.
- [x] beta.21 Release bei beendetem WoW installiert; 74-Dateien-Backup und 73 Payload-Dateien SHA256-verifiziert. Bericht reports/install/verified-20261116-191154-bericht.zip.
- [ ] Live mit persönlicher Bank/TSM: konkrete Mengen, Teilkapazität, Schutz-/Klickanforderungen, Berufsaufruf und spätere Entnahme nach docs/BANK_FLOW.md bestätigen.

## beta.20 — feste Prüfpunkte, 16.11.2026

- [x] Release nach beendetem WoW mit verifiziertem 73-Dateien-Backup installiert; 73 Payload-Dateien SHA256-identisch. Bericht reports/install/verified-20261116-172135-bericht.zip; Live-Retest bleibt offen.

- [x] Wiederholte Route-Pending-Wechsel aus Nutzerlog und unverändertem beta.19-Code reproduziert; zwei gezielte Reproduktionsfälle schlagen dort fehl.
- [x] Routenentscheidung bis Abschnitts-/Ranggrenze festhalten; laufende Coroutine bei normalen Beobachtungen erhalten, native Vorbereitung sichtbar lassen. Aktuelle Mengen-/Preis-/Kaufprüfungen bleiben aktiv.
- [x] Bankhinweis für späteren Bedarf abzüglich aktuellem Bedarf und vorhandener Bankmengen; pro Abschnitt aufschiebbar, keine automatischen Gegenstandsbewegungen.
- [x] Gezielt asynchronen Abschluss unter Inventarereignissen ohne UI-Neuöffnung, Bankmengen und frühen Ladefall geprüft; Belege/Limits in docs/ROUTE_CHECKPOINTS.md. Breiter finaler Ergebnisstand in TEST_RESULTS.md.
- [ ] Live-Retest: mehrere Craft-Vorbereitungen im selben Abschnitt, AH/Briefkasten ohne Neuöffnung, echter Abschnittswechsel und Bankhinweis. Keine FPS- oder abgeschlossene Live-Abnahme behaupten.

## beta.19 — 16.11.2026

- [x] Integrierte, explizit gestartete Mehrrezept-Route mit gemeinsamem Ziel/Snapshot, Zwischenproduktreservierung und getrennten Zahlungs-/Nettokosten.
- [x] Beobachtete Preisstaffeln/Mengen, Restplanung, abgesicherte Trainer-Einzelschritte und bestätigte eigene Twink-Berufe.
- [x] Gespeicherte Aufträge, Runenruten-Voraussetzungen, optionale private Gildenrezeptfreigabe für Ruten/Salzstreuer, Bulk-Sperre und persistente AH-Abwahl.
- [x] Durchgängiger kontrollierter Engineering-1–75- und Silberruten-Vergleich, 34 neue Regressionen; finale breite Suite 563/0/0, 210.33s, reports/tests/20261116-060955-1159db.zip. 47 Laufzeitquellen/319 erfasste Testdateien/3 Inputs SHA256-geprüft.
- [x] DE/EN-Spielertexte, aufklappbare Details, Release-Build und gerenderte UI-Prüfung. Belege/Abnahmematrix: docs/MULTI_STAGE_ROUTES.md.
- [ ] Live: tatsächliche AH-Mengentiefe, Skillup-Restplanung, Trainerklick/Rang, Charakterwechsel/Übergabe und zwei Gildenclients nach dem dokumentierten Plan bestätigen.
- [ ] Weitere Rangidentitäten/Gebühren und austauschbare Reagenzkombinationen nur anhand belegter Daten erweitern. Begrenzte Suche bleibt kein uneingeschränktes Globaloptimum; tatsächliche Lehrerbesuche nicht als global minimiert behaupten.
- [x] Beta.19 Release lokal installiert und 73 Payload-Dateien per SHA256 geprüft; vollständiges 74-Dateien-Backup verifiziert. Bericht reports/install/verified-20261116-061524-bericht.zip; Paket mit DE/EN-Patchnotes unter dist/packages. Live-Abnahme weiterhin offen. Kein Upload/GitHub-Push und kein Merge nach main.

## Sichtbarkeit: erste Runde

- [x] Öffentliche CurseForge-Seite geprüft.
- [x] Beschreibung DE/EN mit frühem Kosten-pro-Skillpunkt-Nutzen überarbeitet.
- [x] Bereits veröffentlichte Goblinbild-/GIF-Adressen eingebunden.
- [x] Formel, Voraussetzungen und tatsächliche Grenzen ergänzt.
- [x] Dokumentierten Kostenabschnitt mit aktuellem Economy.lua/Run.lua abgeglichen.
- [x] Projektstand, Entscheidungen, Arbeitsregeln und Quellsicherung vorbereitet.
- [x] Beschreibung auf CurseForge laut Nutzer übernommen.
- [ ] Kurzbeschreibung und finale öffentliche Vorschau gesondert prüfen.
- [x] Öffentliches Repository mit Code, Lizenz/Attribution und Tests veröffentlicht (19d8816).
- [x] CurseForge Source-/Issues-Links laut Nutzer gesetzt.
- [x] GitHub-Vorabveröffentlichung v3.9.0-beta.9 mit installierbarer ZIP öffentlich geprüft.
- [x] Technische Tests sind im öffentlichen Repository enthalten.
- [x] README, Entwicklerdokumentation und Bug-/Feature-Vorlagen auf GitHub veröffentlicht (d3b0217).
- [ ] Community-Beitrag mit echter Aufnahme veröffentlichen, sobald passender Kanal und Regeln geprüft sind.
- [ ] Rückmeldungen zu Beruf, Skill, Empfehlung, Preisdatum und Clientbuild erfassen.

## Wirtschaftlichkeit: nächste Entwicklungsrunde

- [x] Händler-Verkaufswert und bestätigte Mindestmenge im beta.10-Entwicklungspatch aufgenommen; voller Windows-Lauf: 372/372 bestanden.
- [x] Unknown/BoP/Verzauberungen/Mehrfachausgabe/negative Nettokosten implementiert und gezielt geprüft; volle Windows-Regression bestanden.
- [ ] Lern-, Rezept- und Voraussetzungskosten einmalig verrechnen; keine Doppelzählung.
- [ ] Optionalen AH-Erlös separat und als unsicher kennzeichnen, inklusive Gebühren/Verkaufsrisiken.
- [ ] Materialbesitz: zusätzlicher Goldbedarf vs wirtschaftlicher Marktwert ausdrücklich unterscheiden.
- [ ] Komplette Route einschließlich Zwischenprodukten gegen unabhängige Referenzfälle prüfen.
- [ ] Forever-Skillwahrscheinlichkeiten mit tatsächlichen Versuchen/Skillanstiegen und Unsicherheit validieren.

## Prüfmaßstab

Keine festen Einsparungsprozente oder beste-Route-Aussagen ohne gleiche Startbedingungen,
Preise, Rezepte, Skillchancen und reproduzierbaren Ergebnisvergleich.
Sichtbarkeit messen an echten Rückmeldungen und Nutzung, nicht nur einer KI-Rangfolge.


## Reproduzierbare Belegfälle — 14.11.2026

- [x] 20 synthetische Wirtschaftsfälle mit realem Economy.lua geprüft (isoliert, Lua 5.1).
- [x] Vier absichtlich fehlerhafte temporäre Varianten durch Tests erkannt.
- [x] Zweisprachige Belegseite mit Inputs, Resultaten und Prüfgrenzen vorbereitet.
- [x] Neue Fälle auf dem Gaming-PC mit wowlua/Blizzard-UI ausgeführt: 20/20 bestanden, 4.99s (14.11.2026).
- [x] Beta.9-Belegfälle und Windows-Ergebnis auf GitHub veröffentlicht (711d463).
- [ ] Automatische Eventverarbeitung und native Serien weiterhin getrennt von Modulbelegen validieren.


## Beta.10-Freigabe

- [x] 50 Netto-Kostenfälle und 37 bestehende Wirtschaftsfälle im minimalen Testprojekt bestanden.
- [x] Sechs absichtlich defekte Varianten erkannt.
- [x] Vollständiger wowlua-Build und alle 372 Tests mit Blizzard-UI auf dem Gaming-PC bestanden (195.46s).
- [ ] Händlerwerte und wechselnde Ausgabemengen im Livespiel stichprobenartig prüfen.
- [ ] Beta.10 nach geprüften Ergebnissen committen, installierbar bauen und veröffentlichen.


## Integrationsfix und Berichtswunsch

- [x] Ersten kompletten Windows-Lauf ausgewertet: 369/372, drei Fehlschlaege.
- [x] Gifte-Wrapper-Fehler lokal reproduziert und korrigiert; fokussiert 87/87 mit Wrapper bestanden.
- [x] Automatische ZIP-Berichte fuer kuenftige Windows-Laeufe implementiert und fuer Erfolg, Testfehler und Startfehler geprueft.
- [x] Korrigierten kompletten Windows-Lauf anhand des ZIP-Berichts verifiziert: 372/372, Quellhashes abgeglichen.


## Beta.11 — Rezeptlehrer-Routing

- [x] Fehlende Donnerfels-Quellen für Zauberstab 14807 identifiziert und belegt ergänzt.
- [x] Quellenliste priorisiert aktuelle Karte / vergleichbare lokale Entfernung, ohne Fraktionsschutz zu lockern.
- [x] 30 neue + 12 vorhandene Routingfälle lokal bestanden; drei fehlerhafte Varianten erkannt.
- [x] Vollständige 402 Tests mit Blizzard-UI auf Gaming-PC prüfen.
- [x] Quelle/Marker und tatsächliches Zauberstab-Angebot bei Mot in Donnerfels im Spiel bestätigt.
- [ ] Quellenabdeckung weiterer Rezepte anhand konkreter Belege erweitern; keine pauschale Trainerzuweisung.


## Beta.12 — AH-Mengen und Performance

- [x] Live-Fehler aus Screenshot und Diagnose eingegrenzt; keine weiteren Materialkäufe für die Fehlersuche erforderlich.
- [x] Manuelle kleinere Kaufmenge und leeres Eingabefeld erhalten; native Statusabfrage ohne wiederholte UpdateView-Aufrufe.
- [x] Unpassende Ereignisse herausfiltern, Debounce vor Aushungern schützen, Leerlauf nur Berufskopf prüfen.
- [x] 25 Regressionen mit tatsächlichen Modulen; 18 Fehler am alten Code nachgestellt.
- [x] Vollständiger beta.12-Camelot-Lauf: 427/427, 306 Dateien, 141.38s; Bericht geprüft.
- [x] Windows-Gesamtlauf 427/427 (197.37s) und Installation mit Backup bestätigt.
- [x] Nutzer bestätigt funktionierenden Live-Check; Screenshot Menge 5, CTA 6s20c, geringe momentane Profilerlast. Kein kontrollierter Benchmark.
- [ ] Änderungen nach erfolgreichem Abschluss committen/pushen.


## Sicherung und Fortsetzung

- [x] CONTINUE.md mit exaktem Stand, Grenzen und nächstem Arbeitsschritt erstellt.
- [ ] Sicherungscommit und Push auf fix/local-recipe-trainers durch Nutzer-PC-Skript; erst nach Remote-Prüfung als extern gesichert melden.
- [ ] Danach Lern-/Rezept-/Voraussetzungskosten anhand definierter Belegfälle entwickeln.


## Beta.13 — einmalige Rezeptkosten

- [x] Sicherungscommit f26799d öffentlich verifiziert, isolierter Entwicklungsbranch.
- [x] Exakte beobachtete Trainergebühr, Rezeptgegenstandspreis/Bestand und unbekannten Status trennen.
- [x] Einmalzahlung gegen begrenzte Route mit bekannten Alternativen prüfen, nicht je Craft addieren.
- [x] 34 fokussierte Fälle mit realen Modulen/vertraglichen Trainerfixtures bestanden.
- [x] Finaler Gesamtlauf mit aktueller Quelle: 461/461, 307 Dateien, 143.22s; 18 Quellhashes geprüft.
- [x] Windows-Gesamtlauf anhand 20261115-010908-b537ed.zip geprüft: 461/0/0, 212.88s; alle 18 Quellprüfsummen identisch.
- [ ] Beta.13-Installation mit Backup gesondert belegen; diese Übergaberunde verändert die Spielinstallation nicht.
- [x] Nutzer-Livefall dokumentiert: Mot Dawnstrider, Rezept 7771, Rezeptgegenstand 6345, Trainerlink nil, Lerngebühr 200 Kupfer.
- [x] Mot-Nil-Link-Fehler in beta.14 abgesichert korrigiert; finaler Windows/Camelot-Lauf 485/485, siehe unten.
- [ ] Reale erfolgreiche Zuordnung bei Mot nach separat beauftragter Installation bestätigen.
- [ ] Werkzeug-/Reise-/Ranggebühren und mehrere unbekannte Rezepte gemeinsam modellieren.

## Übergabe beta.13 (historisch)

- [x] Vorhandenen Windowsbericht und alle 18 aufgezeichneten Quellhashes geprüft; lokales Backup mit geprüftem Git-Bundle erstellt.
- [x] CONTINUE.md und AGENTS.md für gemeinsame Weiterarbeit aktualisiert.
- Beta.14 wurde noch nicht ausgeliefert oder installiert. Main und Spielinstallation bleiben unverändert. Frühere Sicherungsaufgaben oben sind historische Einträge; aktueller Branch feature/acquisition-costs.
- Commit/Push und Remote-Gleichheit erst anhand der tatsächlichen Git-Ausgabe bestätigen; aktueller Sicherungscommit über git log -1.

## Beta.14 — abgesicherte Mot-Nil-Link-Zuordnung

- [x] Link-only-Ursache im aktuellen Acquisition.lua bestätigt; belegte Beziehung NPC 11071 / Rezept 7771 / Gegenstand 6345 abgesichert ergänzt.
- [x] Exakte Clientnamen/Ränge, NPC-GUID und Katalogbeziehung prüfen; doppelte Angebote und Spellidentitäten ablehnen. Keine Namensähnlichkeit oder festgeschriebene Gebühr.
- [x] 24 neue Regressionen für Erfolg, Mehrdeutigkeit, fehlende Daten, DE/EN und native Craft-Sperre.
- [x] Finaler Build und Windows/Camelot-Gesamtlauf mit Blizzard-UI: 485/0/0, 308 Dateien, 204.91s. ZIP 20261115-140332-96c718; alle 18 aufgezeichneten Quellhashes exakt geprüft.
- [x] CONTINUE.md, PROJECT_STATE.md, DECISIONS.md und TEST_RESULTS.md aktualisiert.
- [ ] Live-Erfassung der gemeldeten 200 Kupfer bei Mot bestätigen; keine Installation in dieser Runde.
- Weitere Trainer erst nach eigenen Belegen; main und Spielinstallation bleiben unverändert, kein Addon-Release. Commit/Remote-Gleichheit anhand Git prüfen.

## Beta.14 — Abschlussprüfung am 15.11.2026

- Trainerfix-Commit: 014381f3cc8c5197e3e268b1a35c7418a371cc8f, Branch feature/acquisition-costs; Ausgangsarbeitsbaum sauber.
- Vorhandenen Windowsbericht 20261115-140332-96c718.zip erneut geprüft: Build erfolgreich, 485 bestanden, 0 fehlgeschlagen, 0 übersprungen, 204.91s. Alle 18 aufgezeichneten Quellprüfsummen exakt identisch.
- Code, Tests, Manifest/Lockfile und Testskript unverändert; diese Abschlussrunde aktualisiert nur Dokumentation. Kein neuer Testlauf erforderlich oder behauptet.
- Automatisierte Prüfung bestanden, Live-Prüfung der Lerngebühr bei Mot Dawnstrider noch offen.
- Nächste Installation mit Backup und festem _forever_-Ziel in docs/LIVE_TEST_BETA14.md vorbereitet; wowlua install-Optionen lesend geprüft. Kein eigenes Installationsskript vorhanden. Installation nicht ausgeführt, kein Merge nach main.
- Aktuellen Abschlusscommit mit git log -1 bestimmen; Remote-Gleichheit nach Push über git ls-remote origin refs/heads/feature/acquisition-costs prüfen.

## Installation bestätigt — 15.11.2026

- Auf ausdrücklichen Nutzerauftrag installiert; WoW vor und nach der Installation beendet. WowUp-CF als Addonmanager von Spielprozessen unterschieden; kein Spiel gestartet oder beendet.
- Quellstand: 1186209b0f3caa66265d627a1aee4aa9db6b5f78 auf feature/acquisition-costs. Installierte TOC: 3.9.0-beta.14-dev+1186209; app.release: 3.9.0-beta.14.
- Backup reports/install/beta14-20261115-150654/CraftDeja-before-beta14.zip: alle 116 ursprünglichen Dateien per SHA256 im Archiv geprüft. Ursprünglicher Testbuild zusätzlich separat gesichert.
- Dokumentierter wowlua-install-Befehl erfolgreich (Exit 0), ausschließlich _forever_/Interface/AddOns/CraftDeja. Alle 116 Payload-Dateien bytegenau identisch mit neuem Build; zusätzliche .wowlua-install ist die geprüfte wowlua-Verwaltungsdatei.
- Gegen den gesicherten Testbuild unterscheiden sich nur generierte Commit-/Buildkennungen in CraftDeja.toc und wowlua/runtime.lua. Nach Entfernen genau dieser Metadatenzeilen ebenfalls identisch. Code und Assets unverändert; alle 18 Quellprüfsummen aus dem 485/0/0-Windowsbericht stimmen weiterhin.
- Automatischer teilbarer Installationsbericht: reports/install/beta14-20261115-150654-bericht.zip (Bericht, vollständiges Protokoll, Metadaten und Dateiprüfsummen). Ergebnis installed_verified. Backup und Berichte bleiben lokal.
- Main unverändert. Kein Merge, kein Release/Upload. Kein neuer Testlauf: unveränderter getesteter Laufzeitcode. Bekannte W1034 bleibt.
- Automatisierte Prüfung und Installation bestanden; Live-Prüfung der Lerngebühr bei Mot Dawnstrider noch offen. Nächster Schritt: im Spiel beta.14 bestätigen, bei Mot das ungelernte Angebot 7771 öffnen und einen frischen learningCosts[7771]-Beleg (200 Kupfer / trainer / aktueller Zeitstempel) prüfen. Nichts kaufen oder lernen erforderlich.

- [x] Beta.14 auf Nutzerauftrag mit geprüftem Backup installiert; 116/116 Payload-Dateien abgeglichen.
- [ ] Mot-Live-Prüfung: frische tatsächliche Gebühr für 7771 bestätigen.

## Mot-Live-Rückmeldung — 15.11.2026, Screenshots 18:27–18:30

- Nutzerprotokoll bestätigt beta.14-Sessionstart um 18:26:05, Client 1.60.1 / 70938 / 16001, deDE.
- Screenshot 182757 zeigt `7771 fee/source/at/now nil nil nil 1794763659`: zu diesem Zeitpunkt kein gespeicherter Gebührenbeleg für 7771. Spätere Rezeptdetails (183028/183032) melden weiterhin unbekannte Lern-/Rezeptkosten.
- Damit ist erfolgreiche Live-Erfassung nicht bestätigt. Kein neuer Erfolg aus automatisierten Tests ableiten. Die Screenshots zeigen außerdem keine Mot-Quelle unter den sechs Referenzquellen; Quellenliste und Gebührenbeobachtung sind getrennte Datenwege.
- Im gelieferten Log fehlt acquisition.trainer_observed; rohe Trainerereignisse und konkrete Ablehnungsgründe werden im aktuellen Code nicht protokolliert. Das Fehlen von TRAINER-Zeilen beweist deshalb nicht, dass kein Trainerfenster geöffnet wurde. Welche Identitäts-/Ambiguitätsprüfung ablehnt, ist noch unbekannt.
- Nächster Schritt: bei offenem Mot-Trainerfenster NPC-GUID, GetSpellInfo(7771)-Name/Rang sowie die echte Servicezeile (Name/Rang/Status/Kosten/Link) lesend erfassen. Danach den Unterschied als Regression nachstellen; keine Aufweichung der Zuordnung auf Verdacht.
- In dieser Auswertungsrunde nur Übergaben ergänzt, keine Codeänderung, kein erneuter Testlauf und keine Installation. Bestehende lokale Änderungen bleiben erhalten.

## Beta.15 — bestätigter API-Unterschied und Korrektur, 15.11.2026

- Neue Nutzer-Chatdiagnose: `1 Umhang - Schwacher Schutz available 135913 200 nil`. Bei der verwendeten Ausgabe bedeutet dies Serviceindex, Name, Status, Icon-ID, 200 Kupfer, nil-Link. Der aktuelle Client liefert kein Rangfeld zwischen Name und Status.
- Konkrete beta.14-Ursache: Acquisition.lua interpretierte available als Rang und 135913 als Status; der Fallback lehnte deshalb ab. Die bisherigen Tests benutzten nur die ältere name/rank/status-Form. Ausbleibende Ausgabe des alten GetSpellInfo-Befehls deutet zusätzlich auf fehlende globale API; das ist nicht separat live bewiesen.
- Beta.15 erkennt beide Layouts anhand bekannter Statuswerte und Typen. Bei ranglosen Angeboten wird C_Spell.GetSpellInfo mit name/spellID bevorzugt, Legacy bleibt abgesichert verfügbar. Keine erfundenen Ränge; gleiche Namen sind ohne Rangfeld mehrdeutig, auch bei verschiedenen Legacy-Rängen. Abweichende Spell-IDs/Overrides, doppelte Angebote und unklare Daten werden abgelehnt.
- NPC/Rezept/Gegenstand-Beziehung, aktuelle Gebühr, exakte Namen, vorrangige Links und native Craft-Sperre bleiben unverändert. Keine zusätzlichen Timer, Käufe oder Quellenlistenänderungen.
- 20 neue Forever-API-Regressionen. Mit beta.14-Code 70 bestanden / 8 fehlgeschlagen / 0 übersprungen (3 Dateien, 7.14s): reports/tests/20261115-184454-006099.zip. Mit Korrektur fokussiert 78/0/0 (6.77s): 20261115-184533-2afad6.zip.
- Finaler beta.15-Windows/Camelot-Lauf mit Blizzard-UI, wowlua 0.13.14: Build erfolgreich, 505 bestanden, 0 fehlgeschlagen, 0 übersprungen (309 Dateien), 213.08s. ZIP: reports/tests/20261115-184607-d24132.zip. ZIP-Protokoll geprüft; alle 18 aufgezeichneten Quellprüfsummen stimmen exakt. W1034 bleibt bekannt.
- Entwicklungsversion src/Start.lua und wowlua.json: 3.9.0-beta.15. Ausgangscommit 1186209b0f3caa66265d627a1aee4aa9db6b5f78 auf feature/acquisition-costs; vorhandene vier lokale Übergabeänderungen aus der Installations-/Live-Runde vollständig erhalten und mitgeführt.
- Im Spiel bleibt beta.14 installiert. Beta.15 wurde in dieser Runde NICHT installiert; kein Merge nach main, kein Addon-Release. Live-Erfassung bei Mot weiterhin offen. Nächster Schritt: beta.15 separat bei geschlossenem WoW mit Backup installieren und den frischen Beleg für Rezept 7771 prüfen. Keine weiteren alten GetSpellInfo-Diagnosen nötig.

## Beta.15 installiert — 15.11.2026

- Nutzer hat direkte Installation neuer geprüfter CraftDeja-Versionen freigegeben: vorher Hinweis zum vollständigen Beenden von WoW, tatsächlichen Prozessstatus prüfen, keine zusätzliche Bestätigung. Dauerhafte Regel in AGENTS.md gespeichert.
- WoW vor und nach Installation vollständig beendet; WowUp-CF nicht als Spielclient behandelt. Quellcommit 106c61fa7b838096449dec6b18570d82e08a1ee7, feature/acquisition-costs.
- Backup: reports/install/beta15-20261115-185829/CraftDeja-before-beta15.zip. Alle 117 bisherigen Dateien einschließlich wowlua-Verwaltungsdatei im Archiv per SHA256 verifiziert; Installation vor dem Ersetzen erneut unverändert geprüft.
- Installiert: 3.9.0-beta.15-dev+106c61f (app.release 3.9.0-beta.15), ausschließlich Forever/CraftDeja. Alle 116 Payload-Dateien SHA256-identisch mit neuem Build; zusätzliche .wowlua-install als Installer-Verwaltungsdatei geprüft.
- Gegen den gesicherten automatisiert geprüften Build nur generierte Commit-/Buildkennungen in CraftDeja.toc und wowlua/runtime.lua verändert; normalisierte Inhalte identisch. Alle 18 Quellhashes des Windows-Testberichts 20261115-184607-d24132.zip passen weiterhin. Teststand 505/0/0, 213.08s; W1034 bleibt bekannt.
- Automatischer teilbarer Installationsbericht: reports/install/beta15-20261115-185829-bericht.zip; Ergebnis installed_verified. Berichte/Backup bleiben lokal. Kein Merge nach main und kein Upload/Release.
- Nächster Schritt: WoW starten, /cdj version zeigt beta.15; Mot-Trainerfenster mit Angebot 7771 öffnen und frischen learningCosts[7771]-Beleg auf 200 Kupfer / trainer / aktuellen Zeitstempel prüfen. Live-Erfassung bleibt bis zur tatsächlichen Rückmeldung offen.

- [x] Beta.15 mit vollständig geprüftem Backup installiert und 116/116 Builddateien abgeglichen.
- [x] Gespeicherte Mot-Lerngebühr für 7771 live bestätigt: 200 Kupfer / trainer, Screenshot 19:10; siehe Livebeleg unten.

## Mot-Livebeleg bestätigt — 15.11.2026, Screenshot 19:10

- Nutzerbild zeigt `CraftDeja 3.9.0-beta.15` und `7771: 200 trainer 1794766159 1794766291`.
- Damit ist die gespeicherte Lerngebühr für Rezept 7771 (Umhang - Schwacher Schutz, Rezeptgegenstand 6345) mit 200 Kupfer und Herkunft trainer im echten Client belegt. Sie passt zum zuvor ausgegebenen Mot-Angebot `available 135913 200 nil`.
- Beobachtungszeitpunkt 1794766159, Diagnosezeit 1794766291: der Beleg war bei der Abfrage 132 Sekunden alt. Es wird kein neuer Schreibvorgang exakt im Moment der Chatabfrage behauptet.
- Der konkrete Nil-Link-/API-Layout-Fall ist damit live bestätigt. Dies belegt weder alle Trainer/Rezepte noch eine vollständige wirtschaftliche Route oder die Anzeige aller Detailansichten. Das Fehlen von Mot in der separaten Referenzquellenliste wurde hier nicht korrigiert.
- Automatisierter beta.15-Testnachweis bleibt 505/0/0 (213.08s), reports/tests/20261115-184607-d24132.zip; geprüfte Installation: reports/install/beta15-20261115-185829-bericht.zip. Nur Dokumentation/Übergabe geändert, kein neuer Testlauf oder erneute Installation nötig.
- Trainerfix-Quellcommit: 106c61fa7b838096449dec6b18570d82e08a1ee7. Kein Merge nach main und kein Addon-Release. Nächster Schritt: normale Nutzung; weitere konkrete Abweichungen getrennt mit Belegen untersuchen. Für diesen Gebührenbeleg ist kein weiterer Diagnosebefehl nötig.

## Aktueller Stand — beta.16 Performance, 15.11.2026

- Nutzerauftrag: hohe CPU/Ruckler anhand Code und identischer Camelot-Messfälle untersuchen und beheben; ausdrücklich KEINE Installation und kein Merge nach main. Diese auftragsspezifische Ausnahme geht der allgemeinen Auto-Installregel vor. Im Spiel bleibt beta.15 mit bestätigter Mot-Gebühr.
- Ausgang: sauberer Branch feature/acquisition-costs, Commit 9cf3669700b55ba6bc2603ad60624021004d8ffc. Neuer Feature-Branch codex/performance-refresh, Entwicklungsversion 3.9.0-beta.16. Aktuellen Sicherungscommit mit git log -1 bestimmen und nach Push mit Remote vergleichen.
- Nachgewiesen: bekannte Erwerbskosten-Kanten wurden seit beta.13 für jeden Kandidaten/Skill erneut ausgewertet; jetzt einmal pro Snapshot/Skill und billigste Kante je gleichem Punktgewinn. Neue Snapshots invalidieren korrekt. Unabhängige vollständige kleine Routenenumerationen prüfen gleiche Lernentscheidung/Kosten auch mit negativen Nettokosten und mehreren Punkten.
- Beide Commodity-Ereigniskanäle speicherten Preise und lösten sofort volle Marktvergleiche aus. Preise bleiben synchron gespeichert; mehrere Meldungen vor einem Frame werden einmal auf dem nächsten OnUpdate verarbeitet. Explizite Kauf-/Quote-/Suchaktionen rechnen synchron neu; native Craft-Sperren erhalten. Kein zusätzlicher Zeit-Throttle/Timer.
- Versteckte Rezeptkataloge werden aus allgemeinem UI-Refresh ausgeschlossen; Öffnen und sichtbare Kataloge aktualisieren weiter. Alte manuelle Mengenregeln unverändert; vorhandene 25 AHPerformance-Fälle bestanden. Kein aktueller 101-Rücksetzfehler behauptet.
- Identische Stress-Fixture (262 Rezepte, 200 bekannt, 62 synthetische Erwerbsgebühren, Skill 117 bis Cap 150): drei Snapshots 1,235,310 -> 27,510 Wahrscheinlichkeitsauswertungen, Quotes unverändert 786. 24 Preisereignisse vor einem Frame: Markt-/UI-Berechnungen 24 -> 1, letzter Preis erhalten; 0 Rezept-Neueinlesungen. 100 gleiche Preise: 0 -> 0 Marktberechnungen.
- Nativer wowlua bench, gleicher Windows-Host/Camelot/Dev-Profil, 7 Batches à 100ms Zielgröße, identische Fixture SHA256: 2141.9962 -> 53.16255 ms je Entscheidung (unoptimiert 2162.1248 -> 54.56185 ms). Adaptive Aufrufzahl je Batch normiert. Reine Emulatorlaufzeiten, KEINE gemessene FPS-/Spiel-Framezeitverbesserung!
- Finale breite Windows/Blizzard-UI-Regressionssuite: 517 bestanden, 0 fehlgeschlagen, 0 übersprungen, 311 Dateien, 183.59s, wowlua 0.13.14. Report reports/tests/20261115-195119-54e166.zip. 12 neue Tests plus unabhängige Referenzfälle; 38 Lua-Quellhashes und sämtliche Testeingabehashes geprüft. W1034 bleibt bekannt.
- Teilbare Gesamt-ZIP: reports/performance/beta16-20261115-195714.zip. Enthält Ursachen, Änderungen, Audit, Vergleichs-JSON, Umgebung, Hashes, Vorher-/Nachher-Benchmark-ZIPs, negative Baseline-Grenzen und finale Testberichte, Grenzen und Liveplan. Rohberichte bleiben lokal. Details/Reproduktion in docs/PERFORMANCE_BETA16.md; automatische Erstellung über tools/New-PerformanceReport.ps1.
- Standardmäßig AUS: /cdj perf start aktiviert höchstens 30s feste Funktions-/Eventzählungen, inklusive/exklusive/max Zeiten; /cdj perf stop stellt Originalfunktionen/Handler wieder her, /cdj perf show zeigt kopierbaren Bericht. Keine Argumente/Chat-/Charakter-/Kontodaten, kein dauerhaft laufender Diagnose-Timer. Generierten Dev-Code gegen gestapelte Monitor-Wrapper geprüft.
- Noch offen: Zuordnung der konkreten Live-Spitzen (historisch 12.89 ms/f, neu gezeigt 2.66 ms/f) und tatsächliche Spielverbesserung. Lokales Auctionator 346 lesend geprüft; Vertragstests laden nicht das vollständige Addon. Nach später separat beauftragter Installation exakt 30s AH-Angebot öffnen, kleinere manuelle Menge eingeben, warten, /cdj perf show kopieren; kein Kauf nötig. Bis dahin keine Live-CPU-Besserung behaupten.

- [x] Nachgewiesene Rechenwiederholungen und Preis-Bursts mit reproduzierbaren Vorher-/Nachher-Fällen korrigiert.
- [x] Breite Regression und Gesamtbericht für beta.16 bestanden/erstellt.
- [ ] Kontrollierter Live-AH-Vergleich nach späterer ausdrücklicher Installationsfreigabe; diese Runde ohne Installation.

## Beta.16 installiert für CPU-/Lag-Live-Test — 15.11.2026, 20:12

- Neuer ausdrücklicher Nutzerauftrag hebt die vorherige installationsfreie Performance-Runde auf: geprüfte beta.16 jetzt lokal installieren und AH/Lagspikes im Spiel testen. Kein Merge nach main.
- Installiert: 3.9.0-beta.16-dev+243cf98, Quellcommit 243cf9803e7b783161bd33d8565de7c2b7481fc1, Branch codex/performance-refresh. Ausschließlich Forever/Interface/AddOns/CraftDeja; SavedVariables/WTF nicht verändert.
- Vollständige CIM-Prozesssicht vor Backup, unmittelbar vor und nach Installation: kein WoW-Spielprozess; nur WowUp-CF. Spiel nicht selbst beendet oder gestartet.
- Backup reports/install/beta16-20261115-201216/CraftDeja-before-beta16.zip: alle 117 alten Dateien im ZIP per SHA256 verifiziert und unmittelbar vor Installation erneut mit dem unveränderten Ziel verglichen.
- Alle 38 Quellhashes passen zum automatisierten Freigabenachweis reports/tests/20261115-195119-54e166.zip (517/0/0, 183.59s). Kein neuer Testlauf, Laufzeitcode unverändert.
- Alle 117 installierten Payload-Dateien SHA256-identisch zum neuen Build; zusätzliche .wowlua-install-Verwaltungsdatei geprüft. Gegen gesicherten Testbuild nur generierte Commit-/Buildmetadaten in TOC/runtime.lua verändert, normalisierte Inhalte identisch. Bekannte W1034 bleibt.
- Teilbarer automatischer Installationsbericht: reports/install/beta16-20261115-201216-bericht.zip; Ergebnis installed_verified. Backup und getesteter Buildsnapshot separat im selben lokalen Verzeichnis. Main unverändert.
- Offen: tatsächliche CPU-/Lagwirkung im Client. Erst ohne Diagnose normalen AH-Ablauf/kleinere manuelle Kaufmenge prüfen; für eine gezielte 30s-Aufnahme /cdj perf start, nachher /cdj perf show, CPU-Abschnitt kopieren. Diagnose selbst verursacht Overhead. Kein Kauf nötig. Detaillierter Vergleichsplan: docs/PERFORMANCE_BETA16.md. Mot-Gebühr ist unter beta.15 bereits live bestätigt.

- [x] Geprüfte beta.16 auf neuen Nutzerauftrag mit verifiziertem Backup installiert.
- [ ] Nutzer-Rückmeldung zu AH-Ablauf und Lagspikes auswerten.

## Beta.17 — Folgeprüfung nach Live-Aufnahme, 15.11.2026

- Nutzer meldet beta.16 besser, verbleibendes Ruckeln. Screenshot: CraftDeja 10.9%, 3.89ms/f; kein kontrollierter Vergleich. 30s-CPU-Aufnahme: 9 Refreshs, max. 171.212ms; 216 selectionAt, 63984 probability; 363 Gegenstandsereignisse. Messoverhead enthalten, keine konkrete Auctionator-Endlosschleife bewiesen.
- Weitere nachgewiesene Arbeit korrigiert: unmögliche Skill-/Zugangs-/Statuskandidaten vor Wahrscheinlichkeit ausschließen, ungeprüfte Quellen gesondert erhalten; Gegenstandsinteresse per Rezepttabelle indizieren statt vollständiger Suche je Metadatenereignis. Index nach Rezeptlesung invalidiert. Keine neue Drossel oder Mengenänderung.
- Identische synthetische gemischte 262-Rezept-Fixture: 8908 -> 1088 Wahrscheinlichkeitsauswertungen; native Windows/Camelot/wowlua 0.13.14-Zeit 35.421267 -> 9.928720ms je Entscheidung (unoptimiert 34.950167 -> 9.915473ms), sieben Samples. Nicht die echte Katalogzusammensetzung, kein Spiel-FPS-Beleg. 480 differenzielle Auswahlvergleiche bestehen.
- Finale suite beta.17: Build bestanden, 520/0/0, 312 Dateien, 207.86s. reports/tests/20261115-202609-aaf84c.zip. Gesamtbericht reports/performance/beta17-20261115-202609.zip mit Live-CPU-Auszug, Roh-ZIPs, Vergleich und 38 Quellprüfsummen. W1034 bleibt bekannt.
- Branch codex/performance-refresh, Basiscommit 243cf9803e7b783161bd33d8565de7c2b7481fc1; Quellsicherungscommit mit git log bestimmen. Vorhandene drei lokale Installationsübergaben beta.16 vollständig erhalten und mitgeführt. Details, verworfener Versuch und Grenzen: docs/PERFORMANCE_BETA17.md.
- Aktuell zur Installation vorbereitet; bestätigten Installationsbericht separat beachten. Offen bleibt die tatsächliche Wirkung von beta.17 im Client. Nächster Schritt: gleicher AH-Ablauf, kleine manuelle Menge; zunächst ohne Diagnose, dann 30s /cdj perf start und /cdj perf show. Kein Kauf nötig, Spitzen nach Phase unterscheiden. Kein Merge nach main.

## Beta.17 installiert und geprüft — 15.11.2026, 20:32

- Installiert für den fortgesetzten CPU-/Lag-Live-Test: 3.9.0-beta.17-dev+59bee85, Quellcommit 59bee85403f8de8dbfaec7a7d0b9f43522ce9050, codex/performance-refresh. Nutzerhinweis zum Beenden erfolgt; vollständige CIM-Prozesssicht vor Backup, unmittelbar vor und nach Installation ohne laufenden WoW-Client. WowUp-CF und wowlua als Werkzeuge ausgeschlossen.
- Backup reports/install/beta17-20261115-203201/CraftDeja-before-beta17.zip: alle 118 beta.16-Dateien per SHA256 im Archiv und unmittelbar vor Ersatz gegen das unveränderte Ziel geprüft. Alle 117 beta.17-Payload-Dateien SHA256-identisch mit neuem Build; .wowlua-install zusätzlich geprüft. Gegen gesicherten Testbuild nur generierte TOC/runtime-Buildkennungen verändert, normalisierte Inhalte identisch.
- Automatischer Bericht reports/install/beta17-20261115-203201-bericht.zip, Ergebnis installed_verified. 38 Quellhashes passen weiterhin zum finalen 520/0/0-Testnachweis 20261115-202609-aaf84c. Kein erneuter Test nötig: ausschließlich Installation/Übergabe nach geprüftem Code. Main und WTF/SavedVariables unverändert.
- Live-Stand: Nutzer meldet beta.16 besser, aber noch Ruckler; die 30s-Aufnahme belegt verbleibende teure Auswahlen, keine allgemeine Auctionator-Endlosschleife. beta.17-Livewirkung ausdrücklich OFFEN. Nächster Schritt: gleicher AH-Ablauf und kleinere manuelle Menge zunächst ohne Diagnose; danach 30s /cdj perf start und /cdj perf show. Zeitpunkt der Spitze nach Berufsöffnung, Scan, Angebot oder Leerlauf unterscheiden. Kein Kauf erforderlich.

- [x] beta.17 mit verifiziertem beta.16-Backup installiert.
- [ ] Live-Rückmeldung zu beta.17 und neuer CPU-Aufnahme auswerten.

## beta.17 Live-Rückmeldung: AH unauffällig, Freeze im Leerlauf — 15.11.2026

- Nutzer meldet im AH-Ablauf keine Auffälligkeit; kurzer Freeze im Leerlauf zunächst etwa alle 6s, danach 10s. Als beobachteten Bereich 6–10s behandeln, keine exakte periodische Ursache behaupten.
- Neue 30.001s-Aufnahme beta.17/dev: 2222 OnUpdate-Callbacks, längster gemessener OnUpdate 12.769ms; 5 Refreshs (max 10.400ms), 2 Entscheide (max 0.164ms), 10 probability-Aufrufe. 40 renderNextStep, insgesamt 95.527ms, maximal 6.419ms. Aufzeichnungsaufwand eingeschlossen.
- Diese Aufnahme enthält AUCTION_HOUSE_SHOW, TRADE_SKILL_SHOW, vier Listenupdates, 421 Iteminfos sowie 10/11 Zauberstart/-erfolg-Ereignisse. Sie ist kein kontrollierter reiner Leerlauf und nicht mit dem 262-Rezept-Fall der vorherigen Aufnahme gleichzusetzen. Screenshot 35.7%, 4.20ms/f belegt CPU-Anteil, keinen bestimmten Freeze-Auslöser.
- Keine der alten 171ms-Refreshspitzen in dieser Aufnahme. Die standardmäßige CraftDeja-Aufnahme erfasst ausgewählte Funktionen und den App-Eventframe, nicht sämtliche Addon-/Dev-Runtime-Callbacks und keine globale Framepause. Kein Beweis gegen andere CraftDeja-Pfade oder für ein anderes Addon.
- Codeprüfung: App-Perioden 1s/3s, SystemCheck 0.25s; Inventory nur dirty/eventgetrieben. Generierte wowlua-Dev-Runtime profiliert zusätzlich und führt Frame-/Trend-/optionale sichtbare Konsolenarbeit aus. Dev-Overhead ist eine offene Hypothese, keine bewiesene Ursache des 6–10s-Freezes; Runtime nicht verändern oder ausschalten ohne Vergleich.
- Nächster Schritt: eine 30s-Aufnahme ausschließlich dort im Leerlauf, wo der Freeze vorkommt; Fensterzustand unverändert lassen, nichts öffnen/kaufen/craften. /cdj perf start, auf Freeze warten, nach 30s /cdj perf show. Ergänzend /wl prof CraftDeja top 10 sort max und /wl mon CraftDeja sind aus der tatsächlich installierten Runtime verifizierte Befehle für weitere Funktions-/Callbackdaten. Bis dahin kein neuer Laufzeitfix aus Vermutung.
- Nur Befund/Übergabe aktualisiert; beta.17-Code und Installation bleiben am geprüften Stand 59bee85403f8de8dbfaec7a7d0b9f43522ce9050. Bestehende 520/0/0 gelten für diesen unveränderten Code. Kein neuer Testlauf erforderlich.

## beta.17 A/B-Leerlauf: CraftDeja allein ohne Ruckeln — 15.11.2026

- Nutzervergleich: erster beigefügter Log nur CraftDeja aktiv, kein Ruckeln; zweiter mit allen Addons. Gleiche beta.17/dev-Version, jeweils etwa 30s. Ein anderes Addon oder Zusammenspiel ist damit plausibel, einzelner Verursacher noch nicht isoliert.
- Nur CraftDeja: 2598 gemessene OnUpdate, insgesamt 69.104ms, Maximum 0.266ms; 4 Events, insgesamt 0.198ms. Alle Addons: 2622 OnUpdate, insgesamt 76.625ms, Maximum 0.305ms; 420 Gegenstandsinfos, OnEvent insgesamt 11.313ms, Maximum 0.057ms. Keine Refresh-/Entscheidungs-/Rezeptlesungszeilen in beiden CPU-Abschnitten, keine gemeldeten Fehler. Messbereich sind ausgewählte App-Funktionen/Eventframe; keine globale FPS-/Freeze-Erfassung.
- Zusätzlich gepostete /wl-mon-Werte sind kumulativ (u.a. 7478 Iteminfos, 154 ADDON_LOADED). Die zwei OnUpdate-Einträge SystemCheck/Run sind verschachtelte Wrapper desselben Eventframes; gleiche 35.5ms-Maxima nicht addieren und nicht als zwei unabhängige Freeze-Ursachen ausgeben. Weniger/mehr Events allein beweist keinen problematischen Event-Loop.
- Nächster Vergleich: alle bisherigen übrigen Addons aktiv, CraftDeja deaktiviert, gleicher Ort/Fensterzustand, etwa 60s nach Laden beobachten. Bleibt der Freeze, tritt er auch ohne CraftDeja auf. Falls er verschwindet, Zusammenspiel weiter prüfen. Danach Addons gruppenweise halbieren, Abhängigkeiten zusammen halten, je Runde gleiche Bedingungen und neu laden; bestätigen durch gezieltes Aus/Ein des letzten Kandidaten.
- Kein neuer Laufzeitfix aus diesen Daten nötig/belegt. Installierte beta.17 und automatisierter 520/0/0-Nachweis unverändert; Untersuchung des fremden Addons/Zusammenspiels offen.

## Drei-Wege-Test: Freeze nur mit CraftDeja plus übrigen Addons — 15.11.2026

- Nutzer bestätigt: alle übrigen Addons ohne CraftDeja kein Freeze; nur CraftDeja kein Freeze; alle einschließlich CraftDeja Freeze. Damit ist ein zusammensetzungsabhängiger Effekt unter diesen Bedingungen belegt, kein einzelner Verursacher und keine generelle Entlastung von CraftDeja.
- Lokales Freeloader/Core.lua und UI.lua lesend geprüft: sichtbares Hauptfenster ruft Tick per OnUpdate; CPU-Neuattribution bei aktivem Scriptprofiling, optionaler Speicherscan jede dritte Messung (bei 3s Rate ca. 9s). Schließen des Hauptfensters stoppt dessen Sampling-OnUpdate. Tatsächliche Speichermessung nicht als aktiv behaupten; Screenshots zeigen KB/s-Striche. Ein messbedingter Effekt mit dem instrumentierten CraftDeja-Dev-Build bleibt Hypothese, kein bewiesener Fix.
- Nächster einzelner Vergleich: alle bisherigen Addons einschließlich CraftDeja aktiv lassen, Freeloader-Hauptfenster vollständig schließen, 60s am selben Ort/Fensterzustand beobachten. Bei Verschwinden erneut öffnen und Wiederkehr prüfen. Andernfalls Freeloader als Addon deaktivieren und neu laden; danach gezielte Gruppenhalbierung mit CraftDeja dauerhaft aktiv. Keine unnötigen Spielkäufe oder Codeänderungen.
- beta.17-Code/Installation und 520/0/0 unverändert; nur Übergabe aktualisiert. Partner und technische Ursache weiterhin offen.

## Weitere Gruppenvergleiche / KelaGraphics noch nicht eindeutig isoliert — 15.11.2026

- Nutzer stellt klar: Screenshots vor Reload, alle Funktionsprüfungen danach. Frühere Interpretation von Erfordert-Neuladen als ungültiger Test war falsch; diese Meldung entwertet die später erfolgten Tests nicht.
- Freeze bleibt bei deaktiviertem Freeloader, später auch bei deaktiviertem Plater/Auctionator/TSM. Aus einer flüssigen Gruppe: Forever Companion/Loot Sparkles/Quest Tint hinzu -> kein Ruckeln; ForeverQuestMark/GearQuest hinzu -> kein Ruckeln; KelaGraphics hinzu -> Nutzer bestätigt Ruckeln.
- Anschließend angekündigt alle Addons außer KelaGraphics zu aktivieren; neueste Meldung alles an, Ruckler wieder da. Kela-aus für diesen letzten Stand ist aus dem angekündigten Ablauf angenommen, nicht aus Screenshot/Runtime-Liste verifiziert. Kela ist damit nicht als alleiniger Partner bewiesen; mehrere Kombinationen oder ein gemeinsamer Zustand bleiben möglich.
- KelaGraphics 0.53.3 lesend geprüft: Telemetrie-Ticker standardmäßig 0.25s nur bei benötigter Aktivität, adaptive Grafik/CVars. Keine direkte CraftDeja-Referenz oder globale UpdateAddOnMemoryUsage/UpdateAddOnCPUUsage/collectgarbage-Aufrufe in dessen Lua gefunden. Das ist kein Freispruch; aktive Features/Settings im Client sind unbekannt. Andere lokale Addons enthalten globale Memory-/CPU-Abfragen, teils nur Slash/Tooltip/Click; daraus keinen periodischen Verursacher ableiten.
- Nächster kontrollierter Paarvergleich: ausschließlich CraftDeja + KelaGraphics, alle übrigen Addons aus, nach Reload gleicher Ort 60–90s. So lässt sich prüfen, ob Kela mit CraftDeja allein hinreichend ist oder die frühere Gruppe einen weiteren Partner benötigt. Falls Paar flüssig bleibt, weitere Partner/Mehrfachinteraktion offen. beta.17-Code/Installation und 520/0/0 unverändert; kein neuer Fix ohne reproduzierten Auslöser.

## Peak >100 / Speicherhypothese: Dev-Release-Vergleich vorbereitet — 15.11.2026

- Neue Beobachtung: mehr aktive Addons scheinen Ruckeln zu verstärken. Paar CraftDeja+Kela und anschließend kumulativ Companion/Loot Sparkles/Quest Tint, ForeverQuestMark/GearQuest, LFG Bulletin Board, RogueEnergyCombo, ForeverDungeonJournal jeweils flüssig. Weitere Addons dann ohne vollständige Liste aktiviert, Freeze wieder vorhanden. Kein einzelner Partner isoliert.
- Lokalen Freeloader-Code verifiziert: Peak >100 = vom Client CraftDeja zugeordnete Framezeit über 100ms, keine RAM-Prozentanzeige. Spitzenwert ca. 10s gehalten; daraus keinen zehnsekündigen Freezezyklus ableiten. Screenshot 9.4%, 3.34ms/f, 28FPS und KB/s-Striche enthält keine Speichertrendmessung. GC/Heapdruck plausibel, Speicher voll/Leak unbelegt.
- Installierter beta.17-dev+59bee85 sammelt zusätzlich zur optionalen /cdj-perf-Aufnahme ständig automatische wowlua-Funktions-/Handler-/Zeit-/Speicherstatistiken. Dieser gemeinsame Kostenfaktor wurde bisher nicht im kontrollierten Livevergleich entfernt. Keine weiteren Addons einzeln als Verursacher behaupten.
- Gleicher Quellcode als Release-Vergleich gebaut: dist/release/CraftDeja, automatische Compilerkennung 3.9.0-beta.17-alpha+a1362f0. Kein automatisches __wl.prof/__wl.mon/__wl.perf gefunden; TOC ohne Dev-Runtime/Dev-SavedVariable. 73 Dateien, 2757338 Lua-Bytes gegen 117/3005234 im Dev-Artefakt; Dateigrößen sind keine gemessenen Heap-/CPU-Werte.
- tools/Test-CraftDeja.ps1 unterstützt jetzt -Profile dev|release für Build/Benchmark (Default dev). Native test hat KEINEN Profilselektor; Metadaten trennen buildProfile und source-emulator testMode. Erster Versuch 213806-e02211 scheiterte nach Build am falschen test --profile, keine Tests als bestanden ausgegeben; nach Hilfeprüfung korrigiert.
- Release-Build erfolgreich und komplette Quellsuite 520/0/0, 312 Dateien, 221.77s: reports/tests/20261115-213837-0c6669.zip. Dies ist keine Ausführung des gebündelten Release-Artefakts und kein Live-FPS-/GC-Beleg. W1034 bleibt bekannt. Laufzeitquellen unverändert gegen beta.17; keine neue Fachkorrektur.
- Bericht/gesicherter Kandidat unter reports/performance/dev-release-ab-20261115-213935; teilbare ZIP gleichnamig. Details docs/PERFORMANCE_RUNTIME_AB.md. Spielinstallation bleibt beta.17-dev+59bee85; Release-Kandidat in dieser Untersuchungsrunde nicht installiert. Nächster gezielter Vergleich: abgesicherter Dev->Release-Wechsel bei gleichem Addonset/Ort/Fenster, dann 60–90s Leerlauf; keine gleichzeitige Änderung von Grafik, scriptProfile oder Addongruppen. Kein Merge/Releasepublish.

## beta.17 Release-Vergleich installiert — 15.11.2026, 21:48

- Auf ausdrücklichen Nutzerauftrag nach beendetem WoW installiert: 3.9.0-beta.17-alpha+48e75b3, Buildprofil release, app.release weiterhin 3.9.0-beta.17. Automatischer alpha/Commit-Zusatz ist die Compilerkennung dieses Feature-Branchs; gleicher fachlicher beta.17-Code. Installationsquellcommit 48e75b374c891933847ccf3b4766e08a2b006347, codex/performance-refresh.
- Vollständige Prozesssicht vor Backup, unmittelbar vor und nach Installation ohne Spielclient. Backup reports/install/beta17-release-20261115-214747/CraftDeja-dev-before-release.zip: alle 118 alten Dateien SHA256 im ZIP und unmittelbar vor Ersetzen gegen unveränderte Installation geprüft.
- Alle 73 installierten Release-Payload-Dateien SHA256-identisch mit aktuellem Release-Build; .wowlua-install separat geprüft. Gegen gesicherten geprüften Release-Kandidaten nur generierte Metadaten in CraftDeja.toc verändert, Bundle/Assets exakt gleich. Kein src/-Devbaum oder wowlua/runtime.lua übrig; TOC ohne Dev-Runtime/Dev-SavedVariable, Bundle ohne automatische __wl.prof/__wl.mon/__wl.perf-Instrumentierung.
- 38 Quellhashes passen zum Build-/Quelltestnachweis reports/tests/20261115-213837-0c6669.zip, 520/0/0, 221.77s. Kein neuer Testlauf: unveränderter Laufzeitcode. Grenzen der Quellemulation bleiben dokumentiert; Installation ist kein Live-FPS-Nachweis. Bekannte W1034 bleibt.
- Teilbarer automatischer Installationsbericht reports/install/beta17-release-20261115-214747-bericht.zip, Ergebnis installed_verified; Dev-Backup/Release-Kandidatenbackup separat im gleichen Verzeichnis. SavedVariables/WTF nicht geändert. Main unverändert, kein Merge/Releasepublish.
- Nächster Schritt: exakt dasselbe Addonset, Ort/Fenster und Freeloader-Einstellungen wie beim ruckelnden Dev-Stand. Nach Ladephase 60–90s Leerlauf ohne /cdj perf start; Freeze und nach 10s neu auftretende Peaks beurteilen. Grafik/scriptProfile/Addonset nicht gleichzeitig ändern. Wirkung des Release-Vergleichs und GC-/Heapursache ausdrücklich noch offen.

## Uploadpaket beta.17 vorbereitet, Live-Release flüssig — 15.11.2026

- Nutzer bestätigt nach Installation des Release-Vergleichs keine Lags und keine Freezes. Das grenzt die automatische Dev-Instrumentierung als beteiligten Faktor stark ein; kein Beweis eines bestimmten Speicherlecks/GC-Mechanismus oder universeller FPS-Gewinne.
- Nutzer möchte anschließend Produktanalyse und neue Funktionen mit Schwerpunkt günstiges Berufsleveln; diese Arbeit wurde durch die konkrete Bitte um den aktuellen Uploadordner samt Patchnotes gesteuert. Analyse begonnen: Code/Notizen geprüft, veröffentlichte Wettbewerberfunktionen gesichtet. Noch keine neue Fachfunktion implementiert. Anschließend mit priorisiertem Produktplan fortsetzen; günstigste vollständige Route weiter nicht behaupten.
- Öffentliche CurseForge-Seite am 15.11.2026 gelesen: Hauptdatei beta.9. Neue DE/EN-Patchnotes beschreiben deshalb beta.10–17 kumulativ, nur belegte Funktionen/Grenzen. CURSEFORGE_CHANGELOG.txt aktualisiert; kein Laufzeitcode geändert, keine neue Testsuite erforderlich.
- Uploadfertige ZIP: dist/packages/CraftDeja-3.9.0-beta.17-release.zip; 14842198 Bytes; SHA256 8E38514C2EEF8E7C9E1E129F40CBEC75EF24B6000F946287040ACF66DB1BC27E. Alle 73 Dateien gegen installierten Release-Build und einzeln im ZIP geprüft. CraftDeja/CraftDeja.toc liegt korrekt im Archiv. Technische interne TOC-Kennung beta.17-alpha+48e75b3 bleibt unverändert, app.release beta.17.
- Daneben CraftDeja-3.9.0-beta.17-PATCHNOTES_DE_EN.txt und UPLOAD_HINWEISE.txt. Auf CurseForge als Beta für Forever 1.60.1 kennzeichnen; release ist das Buildprofil, keine stabile Produktfreigabe. Kein Upload, kein Merge nach main, keine erneute Spielinstallation durch den Agenten.

## beta.18 Kostenübersicht und Produktanalyse — 16.11.2026

- Ausstehende beta.17-Uploadnotizen auf codex/performance-refresh gesichert: 03d1b9bb749515f1cbe93b93c2ecd47edd50afaf, Remote bestätigt. Upload-ZIP und DE/EN-Patchnotes unverändert in dist/packages; kein CurseForge-Upload durch den Agenten.
- Neue Arbeit isoliert auf codex/plan-cost-overview, Basis 03d1b9b. Ziel: zuverlässiges, günstiges Forever-Leveln; kein unbelegtes Bestes-Addon-/Globaloptimum-Versprechen. Code und primäre Projektseiten geprüft. Priorisierte Analyse samt Abnahmebedingungen: docs/PRODUCT_PLAN.md.
- Erster implementierter Baustein beta.18: Rezeptdetails trennen Materialwert des angezeigten Plans, verwendeten eigenen Bestand, geschätzten Zukauf und Nettomaterialwert mit bestätigtem Händlererlös. Bei unbekanntem Bestand explizite Schätzung; Lern-/Rezept-/Voraussetzungskosten können extra sein. Post/Pendenzen und Packungsreste erklärt. Kein neues Kaufbudget, keine Änderung von Rankings/Kaufmengen/Spielaktionen.
- Kosten werden aus vorhandener Quote und Materialplanung berechnet: keine zusätzlichen Preis-/Inventarabfragen, keine neuen Timer/Scans. Details DE/EN, Gifte-Sonderpläne ohne Kostenblock unverändert. Produktion ab 300 und vollständige Mehrrezeptroute damit noch nicht erweitert.
- Neun neue fokussierte Tests: 9/0/0, reports/tests/20261116-043301-ae0b92.zip. Finaler Release-Build erfolgreich; komplette Windows/Camelot-Quellsuite 529/0/0, 313 Dateien, 208.60s, wowlua 0.13.14: reports/tests/20261116-043439-116912.zip. Quellhashes vollständig aufgezeichnet. Native Quellemulation bleibt von Ausführung des kompilierten Release-Bundles getrennt; keine neue Live-Bestätigung behaupten. W1034 unverändert bekannt.
- README-Version/Teststand und widersprüchliche alte Erwerbskostenangaben korrigiert. Produktziel-Roadmap: P0 Release-Betrieb, P1 Kostenklarheit (erster Baustein umgesetzt), danach vollständiger Zielskill-Vergleich bekannter Rezepte, mehrstufige Erwerbs-/Voraussetzungskosten, Zwischenprodukte, Budget/Preistiefe, Datenvertrauen und wiederaufnehmbare Mehrschritt-Aufträge.
- Installationsstatus separat anhand aktuellem Bericht prüfen; bis zur bestätigten Installation bleibt beta.17 Release im Spiel. Nächster Live-Check beta.18: gleiche Addons, 60–90s Leerlauf, Rezeptdetail mit Teil-/Vollbestand; Zukauf ändert sich mit Bestand, Materialwert nicht. Keine weitere Profession/Quelle als garantiert geprüft ausgeben.

## beta.18 Release installiert und paketiert — 16.11.2026, 04:41

- Nach vorherigem Hinweis und tatsächlicher vollständiger Prozessprüfung bei beendetem WoW installiert: 3.9.0-beta.18-alpha+9a65820, Buildprofil release, Quellcommit 9a65820eee5db5cf0ee2e89ba5eea60ee7474c39, Branch codex/plan-cost-overview. Funktionaler Stand beta.18.
- Backup reports/install/beta18-release-20261116-044059/CraftDeja-before-beta18.zip: alle 74 bisherigen Dateien verifiziert, vor Ersatz nochmals gegen unveränderte Installation geprüft. Alle 73 installierten Payload-Dateien SHA256-identisch zum neuen Release-Build. Gegen gesicherten geprüften Build nur TOC-Buildmetadaten verändert. Keine automatische Entwicklungsinstrumentierung/Dev-Runtime; WTF/SavedVariables unverändert.
- Automatischer Installationsbericht reports/install/beta18-release-20261116-044059-bericht.zip, Ergebnis installed_verified. 38 Quellhashes passen weiterhin zur finalen 529/0/0-Suite (208.60s); neue DE/EN-Detailanzeige noch live zu bestätigen. Grundsatz Release-only für Spieler/Uploads in AGENTS.md ergänzt.
- Uploadkandidat dist/packages/CraftDeja-3.9.0-beta.18-release.zip mit 73 im Archiv geprüften Dateien, SHA256 BA35BFEA97F80005FEC685A7F31A196F66E9AA2CD9912114E44187A0392FC6A1. Eigene beta.18-DE/EN-Patchnotes und UPLOAD_HINWEISE_beta18.txt daneben. Beta.17-Uploadarchiv unverändert gegen ursprünglichen Hash geprüft; vorhandene beta.17-Uploadhinweise bleiben für dieses Paket gültig. Kein automatischer CurseForge-Upload und kein Merge nach main.
- Nächster Nutzercheck: 60–90s Leerlauf mit gleichem Addonset, dann Rezept-/Materialdetails öffnen und Berechnen. Eigenbestand senkt Zukauf, Gesamtmaterialwert bleibt vollständig; bei unbekanntem Bestand klare Schätzung. Neuer Kostenblock gilt für diese angezeigte Craft-Anzahl, nicht für eine vollständige Mehrrezeptroute. Produktanalyse/Abnahmeprioritäten in docs/PRODUCT_PLAN.md.
