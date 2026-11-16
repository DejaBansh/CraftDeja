# CraftDeja — verbindlicher Projektstand

## beta.21 — bestätigte Bankbewegungen und Händleroption, 16.11.2026

- Aktueller Feature-Branch codex/bank-flow, Basis d57fe6875ce81cf35a88b80ec5c755219d04d168; vorher sauber. Originalauftrag docs/tasks/BANK_FLOW_REQUEST.md, Analyse und Live-Test docs/BANK_FLOW.md. Keine Veröffentlichung, kein Push, kein Merge nach main.
- beta.20 hatte nur Bankempfehlung und Detailsknopf, keine ausführende Bewegung. Unveränderte Basis reproduziert den Stillstand: reports/bank-flow-baseline/beta20/reports/tests/20261116-183822-0efa7f.zip, 0/1/0 (erwarteter Fehler: Bank action stayed on the details-only step).
- beta.21: expliziter Einlagerungs-/Entnahmeklick, vorhandene Stapel vor freien kompatiblen Plätzen, exakte Teilmengen, Bestätigung beider Bestände, konkrete Restmengen/Status für Platzmangel, Sperre, Ablehnung, geschlossene Bank und ausstehenden Nachweis. Keine blind wiederholten Mengen; verspätete Bestätigung während Craftserie löst keinen schweren Inventarcapture aus. Bankzugriff unabhängig von sichtbarem Blizzard-BankFrame, persönliche Bankgrenzen aus Forever-API geprüft; TSM live weiterhin offen.
- Gespeicherter DE/EN-Schalter unter Allgemein: Beim Händler automatisch öffnen. Standard an; aus unterdrückt Wiederöffnung eines geschlossenen Guides auch bei Updates/Folgepoll. Manuelle Anzeige, Berufsaufruf, Händlererkennung und bestätigte Einkäufe bleiben möglich. Berufsaufruf setzt denselben Auftrag fort.
- Finale breite Prüfung: reports/tests/20261116-183835-968304.zip, Build bestanden, 589/0/0, 320 Dateien, 290.54s, wowlua 0.13.14, Windows/Camelot/Blizzard-UI. Alle 50 Laufzeitquellen, 321 Test-/Profilquellen und drei Inputs SHA256-identisch. Native Source-Emulation, keine Live-Abnahme des kompilierten Bundles.
- 17 neue Regressionen; drei vollständige echte Modulabläufe über Händlerbeschaffung, Bankeinlagerung, native Herstellung, spätere Entnahme und Zielabschluss: Option an, aus sowie Teilentnahme bei vollen Taschen. UI-Belege separat reports/tests/20261116-183335-c8011c.zip: 16/0/0 mit gerendertem Bankknopf/DE-EN-Einstellungen (vor ergänzter direkter Reproduktionsregression).
- Aktuell NICHT installiert: vollständige Prozessprüfung fand Wow.exe und WowVoiceProxy.exe. Installiert bleibt beta.20-alpha+f7aa05e. Erst nach vollständig beendetem WoW mit tools/Install-VerifiedCraftDeja.ps1, erfolgreichem finalem Test-ZIP und sauberem Quellcommit installieren; Script prüft Backup/Build/Payload und erzeugt Bericht. Keine Änderung an WTF/SavedVariables.
- Nächster Schritt: Release beta.21 mit persönlicher Bank/TSM live prüfen: Händleroption aus/an plus Reload, Berufsaufruf vor/nach Bank, 8 Stoff → 7 behalten/1 einlagern, Stapel/Teilkapazität/Schließen/Reopen, Herstellung und spätere Entnahme. Schutzmeldung oder weiterer benötigter Klick ehrlich erfassen. Kein Nachweis einer neuen FPS-Verbesserung.

## beta.20 Release installiert — 16.11.2026, 17:21

- Nach Nutzerfreigabe „WoW ist beendet“ und vollständiger Prozessprüfung installiert: 3.9.0-beta.20-alpha+f7aa05e, Profil release, Quellcommit f7aa05ee0e23ff3b060dc0e1b0238a6880c38cce auf codex/route-checkpoints.
- Backup reports/install/verified-20261116-172135/CraftDeja-before-install.zip: alle 73 tatsächlich vorhandenen alten Dateien SHA256-verifiziert, vor Ersatz unverändert geprüft und anschließend erneut im Archiv verifiziert. Alle 73 installierten Payload-Dateien SHA256-identisch zum geprüften Release-Kandidaten; wowlua-Verwaltungsmarker zusätzlich. Keine automatische Dev-Instrumentierung/Dev-Runtime. WTF/SavedVariables nicht bearbeitet.
- Automatischer Installationsbericht reports/install/verified-20261116-172135-bericht.zip, Ergebnis installed_verified. WoW vor Backup, direkt vor Ersetzen und nach Installation vollständig beendet. Alle 48 Laufzeit-, 320 Test-/Profil- und drei Build/Testinput-Hashes stimmen weiterhin mit 572/0/0, 232.55s aus reports/tests/20261116-165128-c7c8c3.zip überein. Kein neuer Testlauf bei unverändertem Addoncode.
- Nächster Live-Test: /cdj version prüfen, bestehende Route im selben Rezeptabschnitt fortsetzen, mehrfach Herstellung vorbereiten; AH-Kauf und Post abholen ohne CraftDeja neu zu öffnen. Vollvergleich erst an Abschnitts-/Ranggrenze oder bewusstem Neuplanen; Bankhinweis mit zurückgehaltenem aktuellem Bedarf prüfen. Live-Ergebnis weiterhin offen.
- Kein Merge nach main, kein GitHub-Push und keine Veröffentlichung. Frühere Abschnitte dokumentieren den damaligen Installationsblocker; aktueller Installationsstatus steht hier.


## beta.20 — feste Routenabschnitte / Bankhinweis, 16.11.2026

- Nutzerlog beta.19 belegt wiederholte route_pending-Schritte bei gleichem Rezept/Skill, direkt beim nativen Vorbereitungsklick und nach Mailboxkontakt. Ursache: jeder Refresh/Inventar-/Preisaufruf invalidierte und verwarf auch laufende Routensuchen. Original beta.19 aus a0a6437 separat geprüft: beide identischen Reproduktionsfälle schlagen fehl. Vollständige Analyse und Regressionspfade in docs/ROUTE_CHECKPOINTS.md.
- Auf codex/route-checkpoints von sauberem a0a6437339345a1dcf5c58c6caec0d8e2d2d9bac isoliert. Beta.20 hält die Route bis Rezept-/Ranggrenze fest; normale Beobachtungen ändern nur die aktuelle Entscheidung und aktuelle Kaufprüfungen. Laufende Suche bleibt erhalten; native Bereitschaft bleibt sichtbar. Kein pauschaler Timer. Geänderte Vergleichskosten werden vorläufig statt als frische Ersparnis gezeigt.
- Bankhinweis nennt tatsächliche überschüssige Taschenmenge für spätere Abschnitte, zieht aktuellen Bedarf und vorhandene Bankmengen ab und lässt sich bis zur nächsten Abschnittsgrenze verschieben. Keine automatischen Bewegungen. Guide-/Lieferanten-/Kaufsperren bleiben erhalten.
- Finaler Windows/Camelot-Lauf mit Blizzard-UI, wowlua 0.13.14, Release-Build: 572/0/0, 319 Dateien, 232.55s. ZIP reports/tests/20261116-165128-c7c8c3.zip. Alle 48 Laufzeitquellen, 320 erfassten Test-/Profilquellen und drei Build/Testinputs SHA256-identisch zum abschließenden Stand. Neun neue Fälle; echte Coroutine endet mit genau einem Modellaufbau unter wiederholten Inventarereignissen ohne UI-Neuöffnung. Source-Emulation ist kein FPS- oder vollständiger Live-Servernachweis; W1034 unverändert bekannt.
- Beta.20 ist noch NICHT im Spiel installiert: vollständige Prozessprüfung zeigt laufendes Wow.exe 18788 (Forever) und WowVoiceProxy.exe 7984. Nutzer vor Installation auf vollständiges Beenden hingewiesen. Spielprozesse werden nicht beendet und laufende Installation nicht ersetzt. Aktuell installierter Stand bleibt beta.19. Nach beendetem Spiel tools/Install-VerifiedCraftDeja.ps1 mit obigem Testbericht und dann aktuellem sauberen Quellcommit verwenden; Backup/Hashbericht automatisch.
- Release-Kandidat und DE/EN-Patchnotes werden lokal unter dist/packages bereitgestellt. Kein Upload/GitHub-Push und kein Merge nach main; vorhandene Änderungen erhalten. Nächster Live-Retest: Vorbereitung mehrfach im selben Abschnitt, AH-Kauf/Post ohne Neuöffnen, einmaliger Vergleich an Grenze sowie Bankhinweis/Zurückstellen. Echte Verbesserung dieses Nutzerablaufs ausdrücklich noch offen.


## beta.19 Release installiert und lokal paketiert — 16.11.2026, 06:15

- Tatsächlich installiert: 3.9.0-beta.19-alpha+b8ff69e, Profil release, Quellcommit b8ff69eee43574cb1feb84c39edda0e362de1b1c auf codex/multi-stage-routes. Funktionaler Codecommit f380cccb6d6a4d84a53eedd3c313e2a9d32260f3; Folgecommit korrigiert ausschließlich Windows-ZIP-Pfadnormalisierung im neuen Installationsskript. Alle final getesteten Addon-/Test-/Buildinputs unverändert.
- Nach vorherigem Nutzerhinweis drei vollständige Prozessprüfungen ohne Spielclient. Backup reports/install/verified-20261116-061524/CraftDeja-before-install.zip: alle 74 bisherigen Dateien SHA256-verifiziert und vor Ersatz gegen unveränderte Installation geprüft. Alle 73 neuen Payload-Dateien SHA256-identisch zum geprüften Release-Kandidaten und Installationsbuild; keine automatische Dev-Instrumentierung oder Dev-Runtime. WTF/SavedVariables nicht bearbeitet.
- Automatischer Installationsbericht reports/install/verified-20261116-061524-bericht.zip: installed_verified. Erster Versuch verified-20261116-061448 brach bereits bei der Kandidaten-ZIP-Pfadprüfung ab, bevor die Spielinstallation verändert wurde; vollständiger Fehlerbericht erhalten. Korrektur und erfolgreicher Wiederholungslauf belegt.
- Lokales Paket dist/packages/CraftDeja-3.9.0-beta.19-release.zip: 73 portable CraftDeja/-Archiveinträge, einzeln SHA256 gegen Build geprüft. Paket-SHA256 6B0D10D6D56F1CFB457D9BE40A875D071047408DFDD44BC49BC098F0719627AA. Daneben DE/EN-Patchnotes, Uploadhinweise und Manifest mit Quellcommit/Dateihashes. Frühere beta.17-/beta.18-Archive anhand bekannter Hashes unverändert bestätigt.
- Abschließende Suite: reports/tests/20261116-060955-1159db.zip, 563/0/0, 318 Dateien, 210.33s; alle 47 Quellhashes plus 319 erfasste Test-/Profilquellen und drei Build/Testinputs exakt geprüft. Native Quellemulation, keine vollständige Live-Abnahme. ZIP enthält Protokoll, Umgebung, Quellprüfsummen, native JSON-Ergebnisse und automatisch gerenderte Vergleichsbelege.
- Nächster Schritt im Spiel: /cdj version, Berufsfenster öffnen, /cdj route 75, frischer Auctionator-Scan, Routenangebote öffnen und wenige echte Crafts/Skillups mit stabiler manueller Kaufmenge prüfen. Danach Trainer und getrennt die Ruten-Twink-/Zwei-Spieler-Gildenfälle aus docs/MULTI_STAGE_ROUTES.md. Gildenfreigabe standardmäßig aus; tatsächliche Serverinteraktionen ausdrücklich noch offen. Keine allgemeine FPS- oder Globaloptimum-Zusage.
- Keine Veröffentlichung, kein GitHub-Push und kein Merge nach main in dieser Ausbaurunde; Main bleibt 711d463af4c17f1e711248bb409f1dd5fecfe303. Lokale Quellcommits sichern die Arbeit; Berichte/Backups und Pakete bleiben lokal.


## beta.19 — Mehrstufige Levelrouten, 16.11.2026

- Neuer Feature-Branch codex/multi-stage-routes, Basis 06e83789e72ace10d96b10b46542521c0f8a1d12; Ausgangsarbeitsbaum tatsächlich sauber. Originalauftrag: docs/tasks/MULTI_STAGE_ROUTE_REQUEST.md. Keine früheren Änderungen verworfen.
- /cdj route: vollständige gleiche Zielskill-Kandidaten mit eingefrorenem Bestand/Preisstand, reservierten Zwischenprodukten, einmaligen Lern-/Übergabekosten und getrennten offenen Zahlungen/wirtschaftlichen Nettokosten. Preisstaffeln und verfügbare Mengen; unbekannte Belege bleiben vorläufig. Begrenzte Coroutine-Suche, kein Globaloptimum; während nativer Serien/ungeklärter Käufe keine schwere neue Planung.
- Ein Lehrer-Klick fordert ein aktuell erneut geprüftes geplantes Angebot an; Erfolg nur mit Clientbeleg. Gemeinsamer kontoweiter Auftrag für bestätigte eigene Twinks; Runenruten-Voraussetzungen im Vergleich und bestehende native Vorbereitung erhalten.
- Gildenfreigabe standardmäßig aus; nur kanonische Metallruten/Salzstreuer, keine Bulk-Unteraufträge. Keine Bestands-/Golddaten im Protokoll. Bestätigte Konditionen/Zusage/frisch/online und streng günstigerer Vergleich erforderlich. Gespeicherte AH-Abwahl; Whisper nur Entwurf, Übergabe manuell plus tatsächlicher Bestandsbeleg.
- Finaler Windows/Camelot-Lauf mit Blizzard-UI, wowlua 0.13.14: Release-Build erfolgreich, 563/0/0, 318 Dateien, 210.33s. ZIP reports/tests/20261116-060955-1159db.zip, inklusive nativer JSON-Ergebnisse und gerenderter Referenz. Alle aufgezeichneten Quell-/Test-/Manifestprüfsummen gegen den abschließenden Stand geprüft. Automatisierte Quellemulation ist kein Live-Server- oder Release-Bundle-Ausführungsbeleg. W1034 unverändert bekannt.
- Kontrollierte Forever-Referenz Engineering 1–75: 396 Kupfer Zukauf + 40 Lernen = 436 offen/netto, gegen eigenständig geprüfte Pulver/Bolzen/Rohr-Alternative 476, Ersparnis 40. Silberrute gleicher Bestand: AH 1000/1000, Alt 100/400, bestätigte Gilde 30/330 (offene Zahlung/netto); Gilde spart 70 gegen Alt. Synthetische Preise, keine aktuellen Serverangebote. Details/Abnahmematrix/Limits/Live-Plan: docs/MULTI_STAGE_ROUTES.md.
- Spieler-Patchnotes nur neue Verbesserungen seit beta.18, DE/EN: docs/PATCHNOTES_beta19_DE_EN.md. Kein Merge nach main, kein Upload/keine Veröffentlichung. Lokale Release-Paketierung/abgesicherte Installation nach diesem Quellcommit wird separat dokumentiert.
- Offen: echte Auctionator-Angebotsansicht, tatsächliche Rang-/Traineraktionen, Twink-Übergabe und zwei Gildenclients nach Live-Plan prüfen. Weitere Rang-IDs ohne Beleg bleiben vorläufig; modellierte Lehrerbesuche und Suchbudget sind explizit begrenzt. Nichts davon als live bestanden markieren.


## beta.18 Release installiert und paketiert — 16.11.2026, 04:41

- Nach vorherigem Hinweis und tatsächlicher vollständiger Prozessprüfung bei beendetem WoW installiert: 3.9.0-beta.18-alpha+9a65820, Buildprofil release, Quellcommit 9a65820eee5db5cf0ee2e89ba5eea60ee7474c39, Branch codex/plan-cost-overview. Funktionaler Stand beta.18.
- Backup reports/install/beta18-release-20261116-044059/CraftDeja-before-beta18.zip: alle 74 bisherigen Dateien verifiziert, vor Ersatz nochmals gegen unveränderte Installation geprüft. Alle 73 installierten Payload-Dateien SHA256-identisch zum neuen Release-Build. Gegen gesicherten geprüften Build nur TOC-Buildmetadaten verändert. Keine automatische Entwicklungsinstrumentierung/Dev-Runtime; WTF/SavedVariables unverändert.
- Automatischer Installationsbericht reports/install/beta18-release-20261116-044059-bericht.zip, Ergebnis installed_verified. 38 Quellhashes passen weiterhin zur finalen 529/0/0-Suite (208.60s); neue DE/EN-Detailanzeige noch live zu bestätigen. Grundsatz Release-only für Spieler/Uploads in AGENTS.md ergänzt.
- Uploadkandidat dist/packages/CraftDeja-3.9.0-beta.18-release.zip mit 73 im Archiv geprüften Dateien, SHA256 BA35BFEA97F80005FEC685A7F31A196F66E9AA2CD9912114E44187A0392FC6A1. Eigene beta.18-DE/EN-Patchnotes und UPLOAD_HINWEISE_beta18.txt daneben. Beta.17-Uploadarchiv unverändert gegen ursprünglichen Hash geprüft; vorhandene beta.17-Uploadhinweise bleiben für dieses Paket gültig. Kein automatischer CurseForge-Upload und kein Merge nach main.
- Nächster Nutzercheck: 60–90s Leerlauf mit gleichem Addonset, dann Rezept-/Materialdetails öffnen und Berechnen. Eigenbestand senkt Zukauf, Gesamtmaterialwert bleibt vollständig; bei unbekanntem Bestand klare Schätzung. Neuer Kostenblock gilt für diese angezeigte Craft-Anzahl, nicht für eine vollständige Mehrrezeptroute. Produktanalyse/Abnahmeprioritäten in docs/PRODUCT_PLAN.md.


## beta.18 Kostenübersicht und Produktanalyse — 16.11.2026

- Ausstehende beta.17-Uploadnotizen auf codex/performance-refresh gesichert: 03d1b9bb749515f1cbe93b93c2ecd47edd50afaf, Remote bestätigt. Upload-ZIP und DE/EN-Patchnotes unverändert in dist/packages; kein CurseForge-Upload durch den Agenten.
- Neue Arbeit isoliert auf codex/plan-cost-overview, Basis 03d1b9b. Ziel: zuverlässiges, günstiges Forever-Leveln; kein unbelegtes Bestes-Addon-/Globaloptimum-Versprechen. Code und primäre Projektseiten geprüft. Priorisierte Analyse samt Abnahmebedingungen: docs/PRODUCT_PLAN.md.
- Erster implementierter Baustein beta.18: Rezeptdetails trennen Materialwert des angezeigten Plans, verwendeten eigenen Bestand, geschätzten Zukauf und Nettomaterialwert mit bestätigtem Händlererlös. Bei unbekanntem Bestand explizite Schätzung; Lern-/Rezept-/Voraussetzungskosten können extra sein. Post/Pendenzen und Packungsreste erklärt. Kein neues Kaufbudget, keine Änderung von Rankings/Kaufmengen/Spielaktionen.
- Kosten werden aus vorhandener Quote und Materialplanung berechnet: keine zusätzlichen Preis-/Inventarabfragen, keine neuen Timer/Scans. Details DE/EN, Gifte-Sonderpläne ohne Kostenblock unverändert. Produktion ab 300 und vollständige Mehrrezeptroute damit noch nicht erweitert.
- Neun neue fokussierte Tests: 9/0/0, reports/tests/20261116-043301-ae0b92.zip. Finaler Release-Build erfolgreich; komplette Windows/Camelot-Quellsuite 529/0/0, 313 Dateien, 208.60s, wowlua 0.13.14: reports/tests/20261116-043439-116912.zip. Quellhashes vollständig aufgezeichnet. Native Quellemulation bleibt von Ausführung des kompilierten Release-Bundles getrennt; keine neue Live-Bestätigung behaupten. W1034 unverändert bekannt.
- README-Version/Teststand und widersprüchliche alte Erwerbskostenangaben korrigiert. Produktziel-Roadmap: P0 Release-Betrieb, P1 Kostenklarheit (erster Baustein umgesetzt), danach vollständiger Zielskill-Vergleich bekannter Rezepte, mehrstufige Erwerbs-/Voraussetzungskosten, Zwischenprodukte, Budget/Preistiefe, Datenvertrauen und wiederaufnehmbare Mehrschritt-Aufträge.
- Installationsstatus separat anhand aktuellem Bericht prüfen; bis zur bestätigten Installation bleibt beta.17 Release im Spiel. Nächster Live-Check beta.18: gleiche Addons, 60–90s Leerlauf, Rezeptdetail mit Teil-/Vollbestand; Zukauf ändert sich mit Bestand, Materialwert nicht. Keine weitere Profession/Quelle als garantiert geprüft ausgeben.


## Uploadpaket beta.17 vorbereitet, Live-Release flüssig — 15.11.2026

- Nutzer bestätigt nach Installation des Release-Vergleichs keine Lags und keine Freezes. Das grenzt die automatische Dev-Instrumentierung als beteiligten Faktor stark ein; kein Beweis eines bestimmten Speicherlecks/GC-Mechanismus oder universeller FPS-Gewinne.
- Nutzer möchte anschließend Produktanalyse und neue Funktionen mit Schwerpunkt günstiges Berufsleveln; diese Arbeit wurde durch die konkrete Bitte um den aktuellen Uploadordner samt Patchnotes gesteuert. Analyse begonnen: Code/Notizen geprüft, veröffentlichte Wettbewerberfunktionen gesichtet. Noch keine neue Fachfunktion implementiert. Anschließend mit priorisiertem Produktplan fortsetzen; günstigste vollständige Route weiter nicht behaupten.
- Öffentliche CurseForge-Seite am 15.11.2026 gelesen: Hauptdatei beta.9. Neue DE/EN-Patchnotes beschreiben deshalb beta.10–17 kumulativ, nur belegte Funktionen/Grenzen. CURSEFORGE_CHANGELOG.txt aktualisiert; kein Laufzeitcode geändert, keine neue Testsuite erforderlich.
- Uploadfertige ZIP: dist/packages/CraftDeja-3.9.0-beta.17-release.zip; 14842198 Bytes; SHA256 8E38514C2EEF8E7C9E1E129F40CBEC75EF24B6000F946287040ACF66DB1BC27E. Alle 73 Dateien gegen installierten Release-Build und einzeln im ZIP geprüft. CraftDeja/CraftDeja.toc liegt korrekt im Archiv. Technische interne TOC-Kennung beta.17-alpha+48e75b3 bleibt unverändert, app.release beta.17.
- Daneben CraftDeja-3.9.0-beta.17-PATCHNOTES_DE_EN.txt und UPLOAD_HINWEISE.txt. Auf CurseForge als Beta für Forever 1.60.1 kennzeichnen; release ist das Buildprofil, keine stabile Produktfreigabe. Kein Upload, kein Merge nach main, keine erneute Spielinstallation durch den Agenten.


## beta.17 Release-Vergleich installiert — 15.11.2026, 21:48

- Auf ausdrücklichen Nutzerauftrag nach beendetem WoW installiert: 3.9.0-beta.17-alpha+48e75b3, Buildprofil release, app.release weiterhin 3.9.0-beta.17. Automatischer alpha/Commit-Zusatz ist die Compilerkennung dieses Feature-Branchs; gleicher fachlicher beta.17-Code. Installationsquellcommit 48e75b374c891933847ccf3b4766e08a2b006347, codex/performance-refresh.
- Vollständige Prozesssicht vor Backup, unmittelbar vor und nach Installation ohne Spielclient. Backup reports/install/beta17-release-20261115-214747/CraftDeja-dev-before-release.zip: alle 118 alten Dateien SHA256 im ZIP und unmittelbar vor Ersetzen gegen unveränderte Installation geprüft.
- Alle 73 installierten Release-Payload-Dateien SHA256-identisch mit aktuellem Release-Build; .wowlua-install separat geprüft. Gegen gesicherten geprüften Release-Kandidaten nur generierte Metadaten in CraftDeja.toc verändert, Bundle/Assets exakt gleich. Kein src/-Devbaum oder wowlua/runtime.lua übrig; TOC ohne Dev-Runtime/Dev-SavedVariable, Bundle ohne automatische __wl.prof/__wl.mon/__wl.perf-Instrumentierung.
- 38 Quellhashes passen zum Build-/Quelltestnachweis reports/tests/20261115-213837-0c6669.zip, 520/0/0, 221.77s. Kein neuer Testlauf: unveränderter Laufzeitcode. Grenzen der Quellemulation bleiben dokumentiert; Installation ist kein Live-FPS-Nachweis. Bekannte W1034 bleibt.
- Teilbarer automatischer Installationsbericht reports/install/beta17-release-20261115-214747-bericht.zip, Ergebnis installed_verified; Dev-Backup/Release-Kandidatenbackup separat im gleichen Verzeichnis. SavedVariables/WTF nicht geändert. Main unverändert, kein Merge/Releasepublish.
- Nächster Schritt: exakt dasselbe Addonset, Ort/Fenster und Freeloader-Einstellungen wie beim ruckelnden Dev-Stand. Nach Ladephase 60–90s Leerlauf ohne /cdj perf start; Freeze und nach 10s neu auftretende Peaks beurteilen. Grafik/scriptProfile/Addonset nicht gleichzeitig ändern. Wirkung des Release-Vergleichs und GC-/Heapursache ausdrücklich noch offen.


## Peak >100 / Speicherhypothese: Dev-Release-Vergleich vorbereitet — 15.11.2026

- Neue Beobachtung: mehr aktive Addons scheinen Ruckeln zu verstärken. Paar CraftDeja+Kela und anschließend kumulativ Companion/Loot Sparkles/Quest Tint, ForeverQuestMark/GearQuest, LFG Bulletin Board, RogueEnergyCombo, ForeverDungeonJournal jeweils flüssig. Weitere Addons dann ohne vollständige Liste aktiviert, Freeze wieder vorhanden. Kein einzelner Partner isoliert.
- Lokalen Freeloader-Code verifiziert: Peak >100 = vom Client CraftDeja zugeordnete Framezeit über 100ms, keine RAM-Prozentanzeige. Spitzenwert ca. 10s gehalten; daraus keinen zehnsekündigen Freezezyklus ableiten. Screenshot 9.4%, 3.34ms/f, 28FPS und KB/s-Striche enthält keine Speichertrendmessung. GC/Heapdruck plausibel, Speicher voll/Leak unbelegt.
- Installierter beta.17-dev+59bee85 sammelt zusätzlich zur optionalen /cdj-perf-Aufnahme ständig automatische wowlua-Funktions-/Handler-/Zeit-/Speicherstatistiken. Dieser gemeinsame Kostenfaktor wurde bisher nicht im kontrollierten Livevergleich entfernt. Keine weiteren Addons einzeln als Verursacher behaupten.
- Gleicher Quellcode als Release-Vergleich gebaut: dist/release/CraftDeja, automatische Compilerkennung 3.9.0-beta.17-alpha+a1362f0. Kein automatisches __wl.prof/__wl.mon/__wl.perf gefunden; TOC ohne Dev-Runtime/Dev-SavedVariable. 73 Dateien, 2757338 Lua-Bytes gegen 117/3005234 im Dev-Artefakt; Dateigrößen sind keine gemessenen Heap-/CPU-Werte.
- tools/Test-CraftDeja.ps1 unterstützt jetzt -Profile dev|release für Build/Benchmark (Default dev). Native test hat KEINEN Profilselektor; Metadaten trennen buildProfile und source-emulator testMode. Erster Versuch 213806-e02211 scheiterte nach Build am falschen test --profile, keine Tests als bestanden ausgegeben; nach Hilfeprüfung korrigiert.
- Release-Build erfolgreich und komplette Quellsuite 520/0/0, 312 Dateien, 221.77s: reports/tests/20261115-213837-0c6669.zip. Dies ist keine Ausführung des gebündelten Release-Artefakts und kein Live-FPS-/GC-Beleg. W1034 bleibt bekannt. Laufzeitquellen unverändert gegen beta.17; keine neue Fachkorrektur.
- Bericht/gesicherter Kandidat unter reports/performance/dev-release-ab-20261115-213935; teilbare ZIP gleichnamig. Details docs/PERFORMANCE_RUNTIME_AB.md. Spielinstallation bleibt beta.17-dev+59bee85; Release-Kandidat in dieser Untersuchungsrunde nicht installiert. Nächster gezielter Vergleich: abgesicherter Dev->Release-Wechsel bei gleichem Addonset/Ort/Fenster, dann 60–90s Leerlauf; keine gleichzeitige Änderung von Grafik, scriptProfile oder Addongruppen. Kein Merge/Releasepublish.


## Weitere Gruppenvergleiche / KelaGraphics noch nicht eindeutig isoliert — 15.11.2026

- Nutzer stellt klar: Screenshots vor Reload, alle Funktionsprüfungen danach. Frühere Interpretation von Erfordert-Neuladen als ungültiger Test war falsch; diese Meldung entwertet die später erfolgten Tests nicht.
- Freeze bleibt bei deaktiviertem Freeloader, später auch bei deaktiviertem Plater/Auctionator/TSM. Aus einer flüssigen Gruppe: Forever Companion/Loot Sparkles/Quest Tint hinzu -> kein Ruckeln; ForeverQuestMark/GearQuest hinzu -> kein Ruckeln; KelaGraphics hinzu -> Nutzer bestätigt Ruckeln.
- Anschließend angekündigt alle Addons außer KelaGraphics zu aktivieren; neueste Meldung alles an, Ruckler wieder da. Kela-aus für diesen letzten Stand ist aus dem angekündigten Ablauf angenommen, nicht aus Screenshot/Runtime-Liste verifiziert. Kela ist damit nicht als alleiniger Partner bewiesen; mehrere Kombinationen oder ein gemeinsamer Zustand bleiben möglich.
- KelaGraphics 0.53.3 lesend geprüft: Telemetrie-Ticker standardmäßig 0.25s nur bei benötigter Aktivität, adaptive Grafik/CVars. Keine direkte CraftDeja-Referenz oder globale UpdateAddOnMemoryUsage/UpdateAddOnCPUUsage/collectgarbage-Aufrufe in dessen Lua gefunden. Das ist kein Freispruch; aktive Features/Settings im Client sind unbekannt. Andere lokale Addons enthalten globale Memory-/CPU-Abfragen, teils nur Slash/Tooltip/Click; daraus keinen periodischen Verursacher ableiten.
- Nächster kontrollierter Paarvergleich: ausschließlich CraftDeja + KelaGraphics, alle übrigen Addons aus, nach Reload gleicher Ort 60–90s. So lässt sich prüfen, ob Kela mit CraftDeja allein hinreichend ist oder die frühere Gruppe einen weiteren Partner benötigt. Falls Paar flüssig bleibt, weitere Partner/Mehrfachinteraktion offen. beta.17-Code/Installation und 520/0/0 unverändert; kein neuer Fix ohne reproduzierten Auslöser.


## Drei-Wege-Test: Freeze nur mit CraftDeja plus übrigen Addons — 15.11.2026

- Nutzer bestätigt: alle übrigen Addons ohne CraftDeja kein Freeze; nur CraftDeja kein Freeze; alle einschließlich CraftDeja Freeze. Damit ist ein zusammensetzungsabhängiger Effekt unter diesen Bedingungen belegt, kein einzelner Verursacher und keine generelle Entlastung von CraftDeja.
- Lokales Freeloader/Core.lua und UI.lua lesend geprüft: sichtbares Hauptfenster ruft Tick per OnUpdate; CPU-Neuattribution bei aktivem Scriptprofiling, optionaler Speicherscan jede dritte Messung (bei 3s Rate ca. 9s). Schließen des Hauptfensters stoppt dessen Sampling-OnUpdate. Tatsächliche Speichermessung nicht als aktiv behaupten; Screenshots zeigen KB/s-Striche. Ein messbedingter Effekt mit dem instrumentierten CraftDeja-Dev-Build bleibt Hypothese, kein bewiesener Fix.
- Nächster einzelner Vergleich: alle bisherigen Addons einschließlich CraftDeja aktiv lassen, Freeloader-Hauptfenster vollständig schließen, 60s am selben Ort/Fensterzustand beobachten. Bei Verschwinden erneut öffnen und Wiederkehr prüfen. Andernfalls Freeloader als Addon deaktivieren und neu laden; danach gezielte Gruppenhalbierung mit CraftDeja dauerhaft aktiv. Keine unnötigen Spielkäufe oder Codeänderungen.
- beta.17-Code/Installation und 520/0/0 unverändert; nur Übergabe aktualisiert. Partner und technische Ursache weiterhin offen.


## beta.17 A/B-Leerlauf: CraftDeja allein ohne Ruckeln — 15.11.2026

- Nutzervergleich: erster beigefügter Log nur CraftDeja aktiv, kein Ruckeln; zweiter mit allen Addons. Gleiche beta.17/dev-Version, jeweils etwa 30s. Ein anderes Addon oder Zusammenspiel ist damit plausibel, einzelner Verursacher noch nicht isoliert.
- Nur CraftDeja: 2598 gemessene OnUpdate, insgesamt 69.104ms, Maximum 0.266ms; 4 Events, insgesamt 0.198ms. Alle Addons: 2622 OnUpdate, insgesamt 76.625ms, Maximum 0.305ms; 420 Gegenstandsinfos, OnEvent insgesamt 11.313ms, Maximum 0.057ms. Keine Refresh-/Entscheidungs-/Rezeptlesungszeilen in beiden CPU-Abschnitten, keine gemeldeten Fehler. Messbereich sind ausgewählte App-Funktionen/Eventframe; keine globale FPS-/Freeze-Erfassung.
- Zusätzlich gepostete /wl-mon-Werte sind kumulativ (u.a. 7478 Iteminfos, 154 ADDON_LOADED). Die zwei OnUpdate-Einträge SystemCheck/Run sind verschachtelte Wrapper desselben Eventframes; gleiche 35.5ms-Maxima nicht addieren und nicht als zwei unabhängige Freeze-Ursachen ausgeben. Weniger/mehr Events allein beweist keinen problematischen Event-Loop.
- Nächster Vergleich: alle bisherigen übrigen Addons aktiv, CraftDeja deaktiviert, gleicher Ort/Fensterzustand, etwa 60s nach Laden beobachten. Bleibt der Freeze, tritt er auch ohne CraftDeja auf. Falls er verschwindet, Zusammenspiel weiter prüfen. Danach Addons gruppenweise halbieren, Abhängigkeiten zusammen halten, je Runde gleiche Bedingungen und neu laden; bestätigen durch gezieltes Aus/Ein des letzten Kandidaten.
- Kein neuer Laufzeitfix aus diesen Daten nötig/belegt. Installierte beta.17 und automatisierter 520/0/0-Nachweis unverändert; Untersuchung des fremden Addons/Zusammenspiels offen.


## beta.17 Live-Rückmeldung: AH unauffällig, Freeze im Leerlauf — 15.11.2026

- Nutzer meldet im AH-Ablauf keine Auffälligkeit; kurzer Freeze im Leerlauf zunächst etwa alle 6s, danach 10s. Als beobachteten Bereich 6–10s behandeln, keine exakte periodische Ursache behaupten.
- Neue 30.001s-Aufnahme beta.17/dev: 2222 OnUpdate-Callbacks, längster gemessener OnUpdate 12.769ms; 5 Refreshs (max 10.400ms), 2 Entscheide (max 0.164ms), 10 probability-Aufrufe. 40 renderNextStep, insgesamt 95.527ms, maximal 6.419ms. Aufzeichnungsaufwand eingeschlossen.
- Diese Aufnahme enthält AUCTION_HOUSE_SHOW, TRADE_SKILL_SHOW, vier Listenupdates, 421 Iteminfos sowie 10/11 Zauberstart/-erfolg-Ereignisse. Sie ist kein kontrollierter reiner Leerlauf und nicht mit dem 262-Rezept-Fall der vorherigen Aufnahme gleichzusetzen. Screenshot 35.7%, 4.20ms/f belegt CPU-Anteil, keinen bestimmten Freeze-Auslöser.
- Keine der alten 171ms-Refreshspitzen in dieser Aufnahme. Die standardmäßige CraftDeja-Aufnahme erfasst ausgewählte Funktionen und den App-Eventframe, nicht sämtliche Addon-/Dev-Runtime-Callbacks und keine globale Framepause. Kein Beweis gegen andere CraftDeja-Pfade oder für ein anderes Addon.
- Codeprüfung: App-Perioden 1s/3s, SystemCheck 0.25s; Inventory nur dirty/eventgetrieben. Generierte wowlua-Dev-Runtime profiliert zusätzlich und führt Frame-/Trend-/optionale sichtbare Konsolenarbeit aus. Dev-Overhead ist eine offene Hypothese, keine bewiesene Ursache des 6–10s-Freezes; Runtime nicht verändern oder ausschalten ohne Vergleich.
- Nächster Schritt: eine 30s-Aufnahme ausschließlich dort im Leerlauf, wo der Freeze vorkommt; Fensterzustand unverändert lassen, nichts öffnen/kaufen/craften. /cdj perf start, auf Freeze warten, nach 30s /cdj perf show. Ergänzend /wl prof CraftDeja top 10 sort max und /wl mon CraftDeja sind aus der tatsächlich installierten Runtime verifizierte Befehle für weitere Funktions-/Callbackdaten. Bis dahin kein neuer Laufzeitfix aus Vermutung.
- Nur Befund/Übergabe aktualisiert; beta.17-Code und Installation bleiben am geprüften Stand 59bee85403f8de8dbfaec7a7d0b9f43522ce9050. Bestehende 520/0/0 gelten für diesen unveränderten Code. Kein neuer Testlauf erforderlich.


## Beta.17 installiert und geprüft — 15.11.2026, 20:32

- Installiert für den fortgesetzten CPU-/Lag-Live-Test: 3.9.0-beta.17-dev+59bee85, Quellcommit 59bee85403f8de8dbfaec7a7d0b9f43522ce9050, codex/performance-refresh. Nutzerhinweis zum Beenden erfolgt; vollständige CIM-Prozesssicht vor Backup, unmittelbar vor und nach Installation ohne laufenden WoW-Client. WowUp-CF und wowlua als Werkzeuge ausgeschlossen.
- Backup reports/install/beta17-20261115-203201/CraftDeja-before-beta17.zip: alle 118 beta.16-Dateien per SHA256 im Archiv und unmittelbar vor Ersatz gegen das unveränderte Ziel geprüft. Alle 117 beta.17-Payload-Dateien SHA256-identisch mit neuem Build; .wowlua-install zusätzlich geprüft. Gegen gesicherten Testbuild nur generierte TOC/runtime-Buildkennungen verändert, normalisierte Inhalte identisch.
- Automatischer Bericht reports/install/beta17-20261115-203201-bericht.zip, Ergebnis installed_verified. 38 Quellhashes passen weiterhin zum finalen 520/0/0-Testnachweis 20261115-202609-aaf84c. Kein erneuter Test nötig: ausschließlich Installation/Übergabe nach geprüftem Code. Main und WTF/SavedVariables unverändert.
- Live-Stand: Nutzer meldet beta.16 besser, aber noch Ruckler; die 30s-Aufnahme belegt verbleibende teure Auswahlen, keine allgemeine Auctionator-Endlosschleife. beta.17-Livewirkung ausdrücklich OFFEN. Nächster Schritt: gleicher AH-Ablauf und kleinere manuelle Menge zunächst ohne Diagnose; danach 30s /cdj perf start und /cdj perf show. Zeitpunkt der Spitze nach Berufsöffnung, Scan, Angebot oder Leerlauf unterscheiden. Kein Kauf erforderlich.


## Beta.17 — Folgeprüfung nach Live-Aufnahme, 15.11.2026

- Nutzer meldet beta.16 besser, verbleibendes Ruckeln. Screenshot: CraftDeja 10.9%, 3.89ms/f; kein kontrollierter Vergleich. 30s-CPU-Aufnahme: 9 Refreshs, max. 171.212ms; 216 selectionAt, 63984 probability; 363 Gegenstandsereignisse. Messoverhead enthalten, keine konkrete Auctionator-Endlosschleife bewiesen.
- Weitere nachgewiesene Arbeit korrigiert: unmögliche Skill-/Zugangs-/Statuskandidaten vor Wahrscheinlichkeit ausschließen, ungeprüfte Quellen gesondert erhalten; Gegenstandsinteresse per Rezepttabelle indizieren statt vollständiger Suche je Metadatenereignis. Index nach Rezeptlesung invalidiert. Keine neue Drossel oder Mengenänderung.
- Identische synthetische gemischte 262-Rezept-Fixture: 8908 -> 1088 Wahrscheinlichkeitsauswertungen; native Windows/Camelot/wowlua 0.13.14-Zeit 35.421267 -> 9.928720ms je Entscheidung (unoptimiert 34.950167 -> 9.915473ms), sieben Samples. Nicht die echte Katalogzusammensetzung, kein Spiel-FPS-Beleg. 480 differenzielle Auswahlvergleiche bestehen.
- Finale suite beta.17: Build bestanden, 520/0/0, 312 Dateien, 207.86s. reports/tests/20261115-202609-aaf84c.zip. Gesamtbericht reports/performance/beta17-20261115-202609.zip mit Live-CPU-Auszug, Roh-ZIPs, Vergleich und 38 Quellprüfsummen. W1034 bleibt bekannt.
- Branch codex/performance-refresh, Basiscommit 243cf9803e7b783161bd33d8565de7c2b7481fc1; Quellsicherungscommit mit git log bestimmen. Vorhandene drei lokale Installationsübergaben beta.16 vollständig erhalten und mitgeführt. Details, verworfener Versuch und Grenzen: docs/PERFORMANCE_BETA17.md.
- Aktuell zur Installation vorbereitet; bestätigten Installationsbericht separat beachten. Offen bleibt die tatsächliche Wirkung von beta.17 im Client. Nächster Schritt: gleicher AH-Ablauf, kleine manuelle Menge; zunächst ohne Diagnose, dann 30s /cdj perf start und /cdj perf show. Kein Kauf nötig, Spitzen nach Phase unterscheiden. Kein Merge nach main.


## Beta.16 installiert für CPU-/Lag-Live-Test — 15.11.2026, 20:12

- Neuer ausdrücklicher Nutzerauftrag hebt die vorherige installationsfreie Performance-Runde auf: geprüfte beta.16 jetzt lokal installieren und AH/Lagspikes im Spiel testen. Kein Merge nach main.
- Installiert: 3.9.0-beta.16-dev+243cf98, Quellcommit 243cf9803e7b783161bd33d8565de7c2b7481fc1, Branch codex/performance-refresh. Ausschließlich Forever/Interface/AddOns/CraftDeja; SavedVariables/WTF nicht verändert.
- Vollständige CIM-Prozesssicht vor Backup, unmittelbar vor und nach Installation: kein WoW-Spielprozess; nur WowUp-CF. Spiel nicht selbst beendet oder gestartet.
- Backup reports/install/beta16-20261115-201216/CraftDeja-before-beta16.zip: alle 117 alten Dateien im ZIP per SHA256 verifiziert und unmittelbar vor Installation erneut mit dem unveränderten Ziel verglichen.
- Alle 38 Quellhashes passen zum automatisierten Freigabenachweis reports/tests/20261115-195119-54e166.zip (517/0/0, 183.59s). Kein neuer Testlauf, Laufzeitcode unverändert.
- Alle 117 installierten Payload-Dateien SHA256-identisch zum neuen Build; zusätzliche .wowlua-install-Verwaltungsdatei geprüft. Gegen gesicherten Testbuild nur generierte Commit-/Buildmetadaten in TOC/runtime.lua verändert, normalisierte Inhalte identisch. Bekannte W1034 bleibt.
- Teilbarer automatischer Installationsbericht: reports/install/beta16-20261115-201216-bericht.zip; Ergebnis installed_verified. Backup und getesteter Buildsnapshot separat im selben lokalen Verzeichnis. Main unverändert.
- Offen: tatsächliche CPU-/Lagwirkung im Client. Erst ohne Diagnose normalen AH-Ablauf/kleinere manuelle Kaufmenge prüfen; für eine gezielte 30s-Aufnahme /cdj perf start, nachher /cdj perf show, CPU-Abschnitt kopieren. Diagnose selbst verursacht Overhead. Kein Kauf nötig. Detaillierter Vergleichsplan: docs/PERFORMANCE_BETA16.md. Mot-Gebühr ist unter beta.15 bereits live bestätigt.


Stand: 15.11.2026. Dies ist ein Arbeitsstand aus Dateien und sichtbarem Gespräch, kein vollständiges Chat-Transkript.
Vor Änderungen aktuellen Code und diese Notizen prüfen. Kein Gedächtnis ersetzt Versionskontrolle.

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

## Mot-Livebeleg bestätigt — 15.11.2026, Screenshot 19:10

- Nutzerbild zeigt `CraftDeja 3.9.0-beta.15` und `7771: 200 trainer 1794766159 1794766291`.
- Damit ist die gespeicherte Lerngebühr für Rezept 7771 (Umhang - Schwacher Schutz, Rezeptgegenstand 6345) mit 200 Kupfer und Herkunft trainer im echten Client belegt. Sie passt zum zuvor ausgegebenen Mot-Angebot `available 135913 200 nil`.
- Beobachtungszeitpunkt 1794766159, Diagnosezeit 1794766291: der Beleg war bei der Abfrage 132 Sekunden alt. Es wird kein neuer Schreibvorgang exakt im Moment der Chatabfrage behauptet.
- Der konkrete Nil-Link-/API-Layout-Fall ist damit live bestätigt. Dies belegt weder alle Trainer/Rezepte noch eine vollständige wirtschaftliche Route oder die Anzeige aller Detailansichten. Das Fehlen von Mot in der separaten Referenzquellenliste wurde hier nicht korrigiert.
- Automatisierter beta.15-Testnachweis bleibt 505/0/0 (213.08s), reports/tests/20261115-184607-d24132.zip; geprüfte Installation: reports/install/beta15-20261115-185829-bericht.zip. Nur Dokumentation/Übergabe geändert, kein neuer Testlauf oder erneute Installation nötig.
- Trainerfix-Quellcommit: 106c61fa7b838096449dec6b18570d82e08a1ee7. Kein Merge nach main und kein Addon-Release. Nächster Schritt: normale Nutzung; weitere konkrete Abweichungen getrennt mit Belegen untersuchen. Für diesen Gebührenbeleg ist kein weiterer Diagnosebefehl nötig.

## Beta.15 installiert — 15.11.2026 (Installationsrunde vor der Live-Rückmeldung)

- Nutzer hat direkte Installation neuer geprüfter CraftDeja-Versionen freigegeben: vorher Hinweis zum vollständigen Beenden von WoW, tatsächlichen Prozessstatus prüfen, keine zusätzliche Bestätigung. Dauerhafte Regel in AGENTS.md gespeichert.
- WoW vor und nach Installation vollständig beendet; WowUp-CF nicht als Spielclient behandelt. Quellcommit 106c61fa7b838096449dec6b18570d82e08a1ee7, feature/acquisition-costs.
- Backup: reports/install/beta15-20261115-185829/CraftDeja-before-beta15.zip. Alle 117 bisherigen Dateien einschließlich wowlua-Verwaltungsdatei im Archiv per SHA256 verifiziert; Installation vor dem Ersetzen erneut unverändert geprüft.
- Installiert: 3.9.0-beta.15-dev+106c61f (app.release 3.9.0-beta.15), ausschließlich Forever/CraftDeja. Alle 116 Payload-Dateien SHA256-identisch mit neuem Build; zusätzliche .wowlua-install als Installer-Verwaltungsdatei geprüft.
- Gegen den gesicherten automatisiert geprüften Build nur generierte Commit-/Buildkennungen in CraftDeja.toc und wowlua/runtime.lua verändert; normalisierte Inhalte identisch. Alle 18 Quellhashes des Windows-Testberichts 20261115-184607-d24132.zip passen weiterhin. Teststand 505/0/0, 213.08s; W1034 bleibt bekannt.
- Automatischer teilbarer Installationsbericht: reports/install/beta15-20261115-185829-bericht.zip; Ergebnis installed_verified. Berichte/Backup bleiben lokal. Kein Merge nach main und kein Upload/Release.
- Nächster Schritt: WoW starten, /cdj version zeigt beta.15; Mot-Trainerfenster mit Angebot 7771 öffnen und frischen learningCosts[7771]-Beleg auf 200 Kupfer / trainer / aktuellen Zeitstempel prüfen. Live-Erfassung bleibt bis zur tatsächlichen Rückmeldung offen.

## Beta.15 — Korrekturrunde vor der Installation, 15.11.2026

- Neue Nutzer-Chatdiagnose: `1 Umhang - Schwacher Schutz available 135913 200 nil`. Bei der verwendeten Ausgabe bedeutet dies Serviceindex, Name, Status, Icon-ID, 200 Kupfer, nil-Link. Der aktuelle Client liefert kein Rangfeld zwischen Name und Status.
- Konkrete beta.14-Ursache: Acquisition.lua interpretierte available als Rang und 135913 als Status; der Fallback lehnte deshalb ab. Die bisherigen Tests benutzten nur die ältere name/rank/status-Form. Ausbleibende Ausgabe des alten GetSpellInfo-Befehls deutet zusätzlich auf fehlende globale API; das ist nicht separat live bewiesen.
- Beta.15 erkennt beide Layouts anhand bekannter Statuswerte und Typen. Bei ranglosen Angeboten wird C_Spell.GetSpellInfo mit name/spellID bevorzugt, Legacy bleibt abgesichert verfügbar. Keine erfundenen Ränge; gleiche Namen sind ohne Rangfeld mehrdeutig, auch bei verschiedenen Legacy-Rängen. Abweichende Spell-IDs/Overrides, doppelte Angebote und unklare Daten werden abgelehnt.
- NPC/Rezept/Gegenstand-Beziehung, aktuelle Gebühr, exakte Namen, vorrangige Links und native Craft-Sperre bleiben unverändert. Keine zusätzlichen Timer, Käufe oder Quellenlistenänderungen.
- 20 neue Forever-API-Regressionen. Mit beta.14-Code 70 bestanden / 8 fehlgeschlagen / 0 übersprungen (3 Dateien, 7.14s): reports/tests/20261115-184454-006099.zip. Mit Korrektur fokussiert 78/0/0 (6.77s): 20261115-184533-2afad6.zip.
- Finaler beta.15-Windows/Camelot-Lauf mit Blizzard-UI, wowlua 0.13.14: Build erfolgreich, 505 bestanden, 0 fehlgeschlagen, 0 übersprungen (309 Dateien), 213.08s. ZIP: reports/tests/20261115-184607-d24132.zip. ZIP-Protokoll geprüft; alle 18 aufgezeichneten Quellprüfsummen stimmen exakt. W1034 bleibt bekannt.
- Entwicklungsversion src/Start.lua und wowlua.json: 3.9.0-beta.15. Ausgangscommit 1186209b0f3caa66265d627a1aee4aa9db6b5f78 auf feature/acquisition-costs; vorhandene vier lokale Übergabeänderungen aus der Installations-/Live-Runde vollständig erhalten und mitgeführt.
- Im Spiel bleibt beta.14 installiert. Beta.15 wurde in dieser Runde NICHT installiert; kein Merge nach main, kein Addon-Release. Live-Erfassung bei Mot weiterhin offen. Nächster Schritt: beta.15 separat bei geschlossenem WoW mit Backup installieren und den frischen Beleg für Rezept 7771 prüfen. Keine weiteren alten GetSpellInfo-Diagnosen nötig.

## Installierter Stand beta.14 — 15.11.2026

- Auf ausdrücklichen Nutzerauftrag installiert; WoW vor und nach der Installation beendet. WowUp-CF als Addonmanager von Spielprozessen unterschieden; kein Spiel gestartet oder beendet.
- Quellstand: 1186209b0f3caa66265d627a1aee4aa9db6b5f78 auf feature/acquisition-costs. Installierte TOC: 3.9.0-beta.14-dev+1186209; app.release: 3.9.0-beta.14.
- Backup reports/install/beta14-20261115-150654/CraftDeja-before-beta14.zip: alle 116 ursprünglichen Dateien per SHA256 im Archiv geprüft. Ursprünglicher Testbuild zusätzlich separat gesichert.
- Dokumentierter wowlua-install-Befehl erfolgreich (Exit 0), ausschließlich _forever_/Interface/AddOns/CraftDeja. Alle 116 Payload-Dateien bytegenau identisch mit neuem Build; zusätzliche .wowlua-install ist die geprüfte wowlua-Verwaltungsdatei.
- Gegen den gesicherten Testbuild unterscheiden sich nur generierte Commit-/Buildkennungen in CraftDeja.toc und wowlua/runtime.lua. Nach Entfernen genau dieser Metadatenzeilen ebenfalls identisch. Code und Assets unverändert; alle 18 Quellprüfsummen aus dem 485/0/0-Windowsbericht stimmen weiterhin.
- Automatischer teilbarer Installationsbericht: reports/install/beta14-20261115-150654-bericht.zip (Bericht, vollständiges Protokoll, Metadaten und Dateiprüfsummen). Ergebnis installed_verified. Backup und Berichte bleiben lokal.
- Main unverändert. Kein Merge, kein Release/Upload. Kein neuer Testlauf: unveränderter getesteter Laufzeitcode. Bekannte W1034 bleibt.
- Automatisierte Prüfung und Installation bestanden; Live-Prüfung der Lerngebühr bei Mot Dawnstrider noch offen. Nächster Schritt: im Spiel beta.14 bestätigen, bei Mot das ungelernte Angebot 7771 öffnen und einen frischen learningCosts[7771]-Beleg (200 Kupfer / trainer / aktueller Zeitstempel) prüfen. Nichts kaufen oder lernen erforderlich.

## Fortsetzungspunkt vor der Installation — beta.14, 15.11.2026

- feature/acquisition-costs, Ausgangscommit 3ca5bbcc2aee639f91575f4b58a2eaf666a004ee; Arbeitsbaum zu Beginn sauber. app.release und wowlua.json: 3.9.0-beta.14. Aktuellen Sicherungscommit mit Git bestimmen.
- Ursache Mot-Fall: beta.13 benötigt Spell-/Enchant-Link zur Rezept-ID und verwirft Gebühr bei nil. Gemeldet: NPC 11071, Rezept 7771, Rezeptgegenstand 6345, 200 Kupfer.
- Implementiert: enger, belegter NPC/Rezept/Gegenstand-Fallback mit exaktem Clientnamen/Rang und Ambiguitätssperren (doppelte Angebote/Spellidentitäten, fehlende Daten). Aktuelle Gebühr statt Festwert, exakte Links vorrangig; andere unbelegte Nil-Link-Fälle unbekannt. Siehe docs/ACQUISITION_COSTS.md.
- Finaler Windows/Camelot-Gesamtlauf mit Blizzard-UI und wowlua 0.13.14: Build bestanden, 485/0/0, 308 Dateien, 204.91s. Bericht reports/tests/20261115-140332-96c718.zip; alle 18 aufgezeichneten Quellhashes stimmen exakt mit finalem Code überein. 24 neue Regressionen. W1034 bleibt bekannt.
- Noch offen: tatsächliche erfolgreiche Gebührenzuordnung im Mot-Trainerfenster nach separat beauftragter Installation bestätigen. Automatisierte Fixtures beweisen keine Live-Erfassung. Keine Spielinstallation, kein Addon-Release und kein Merge nach main in dieser Runde.
- Nächster Schritt: gezielter Live-Retest dieses Angebots; weitere Nil-Link-Angebote nur anhand eigener Belege ergänzen. CONTINUE.md enthält die aktuelle Übergabe; darunter sind frühere Stände als Historie erhalten.

## Vorheriger Fortsetzungspunkt — beta.13 (historisch), 15.11.2026

- Tatsächlicher Arbeitsordner C:\Users\Tim\Projects\CraftDeja; Branch feature/acquisition-costs, Ausgangscommit f26799d1a383d3c4e6280bc9c36aa3fb32c34001. Version in Start.lua und wowlua.json: 3.9.0-beta.13. Aktuellen Sicherungscommit immer mit Git bestimmen.
- Vorhandener Windowsbericht reports/tests/20261115-010908-b537ed.zip geprüft: Build bestanden, 461/0/0, 307 Dateien, 212.88s, wowlua 0.13.14 mit Blizzard-UI. Alle 18 aufgezeichneten Quellprüfsummen stimmen exakt überein. Kein neuer Lauf für diese Dokumentations-/Sicherungsrunde erforderlich.
- Acquisition.lua und Integration implementieren begrenzte einmalige Rezeptkosten; vollständige Werkzeug-/Reise-/Rangkosten und globales Routenoptimum bleiben offen.
- Offener Nutzer-Livebericht: Mot Dawnstrider, Rezept 7771, Rezeptgegenstand 6345, Trainerlink nil, Lerngebühr 200 Kupfer. Exakte Linkbeobachtung in beta.13 kann diese Gebühr nicht zuordnen. Keine Trainerkorrektur in dieser Runde.
- Beta.14 wurde noch nicht ausgeliefert oder installiert. Main und Spielinstallation bleiben in dieser Runde unverändert; kein Release.
- wowlua 0.13.14 liegt unter C:\Users\Tim\.wowlua\bin\wowlua.exe. Testskript ergänzt den Sitzungs-PATH. W1034 bleibt bekannt.
- Lokales Backup: reports/backups/beta13-before-handoff-20261115-134230/ (Arbeitsbaum, geprüftes Git-Bundle, Windowsbericht, Ausgangsstatus).
- Nächste fachliche Aufgabe: sichere Trainerzuordnung für diesen konkreten nil-Link-Fall untersuchen, separat korrigieren und breit testen. CONTINUE.md ist die aktuelle Übergabe; darunter folgen historische Entwicklungsstände.

## Ziel und Produktentscheidungen

- Tim entwickelt CraftDeja für WoW Forever 1.60.1 / Interface 16001; DE und EN.
- Hauptziel: möglichst geringe Goldkosten beim Berufsleveln. Kleine Anzeige mit genau einer klaren nächsten Aktion.
- Große grüne primäre CTA; kurze konkrete Texte. Auftrag ändern klein und grau. Weitere Details in Tooltips/Ansichten.
- Arbeitsstätten konkret nennen: Kochstelle, Amboss, Schmiede, Schmelzofen, Alchemielabor usw., anhand der tatsächlichen Rezeptanforderung.
- Werkzeuge, Voraussetzungen und Ruten als Arbeitsschritte berücksichtigen; ein vorhandener Schritt bedeutet nicht, dass seine Erwerbskosten bereits in der Rezeptbewertung stecken.
- Automatische Planmenge unter 300. Eigene Stückzahlen für Gifte und Produktion ab 300 erhalten.
- Größere fachliche Testsuiten statt ständig einzelner Kleinsttests. Qualität vor Tempo.
- Goblinstil bewahren. Beschreibung und Patchnotes DE/EN. Goblinbild zuerst, nicht riesig. Demo-Einblendungen EN, Originalspielaufnahme DE.

## Historischer Stand bis beta.12 (aktueller Fortsetzungspunkt siehe oben)

- Entwicklungsversion app.release und wowlua.json: 3.9.0-beta.12. Öffentlich veröffentlichte Addon-ZIP weiterhin beta.9.
- Öffentliches Quellrepository: https://github.com/DejaBansh/CraftDeja ; im aktuellen Arbeitsdurchlauf frisch geklont.
- Aktuelles Nutzerprojekt auf dem Gaming-PC: C:\Users\Tim\Projects\CraftDeja. Anderer PC historisch: C:\Users\gv_co\Projects\CraftDeja-Aktuell\CraftDeja.
- Spielordner: C:\Program Files (x86)\World of Warcraft\_forever_\Interface\AddOns\CraftDeja.
- Gaming-PC aktuell: Branch fix/local-recipe-trainers, Basis f744a01; beta.12 angewandt, vollständig auf Windows getestet und im Spiel bestätigt; Sicherungscommit/Push jetzt auszuführen. origin https://github.com/DejaBansh/CraftDeja.git ; erster veröffentlichter Commit 19d881608c377e26c74415ed1b3f12ae7f2d5b52. setup/wowlua und dc914c0 gehören zum älteren PC-Verlauf.
- Nicht zum alten Projekt C:\Users\gv_co\Projects\CraftDeja mit 3.8.0 zurückwechseln.
- Gaming-PC: Git 2.56.0.windows.4, wowlua 0.13.14; Build und 302 Tests erfolgreich. Früherer PC: wowlua 0.13.12. UTF-8 ohne BOM für JSON/Tests beachten.
- Addon-ZIP CraftDeja_3.9.0-beta.9_Logo_CurseForge.zip: einzelner CraftDeja/-Hauptordner, geprüfter Logo-Pfad Art/Logo.tga, CRC bestanden.
- Die Release-TOC trägt generierten Versionssuffix -alpha; app.release ist 3.9.0-beta.9. Das vor der nächsten Veröffentlichung bewusst vereinheitlichen.
- Logo in der generierten TOC geprüft. Manifestfeld addon.icon-texture verwenden; IconTexture unter toc-extra verursacht E4002. Im veröffentlichten wowlua.json korrigiert.
- Die alte Root-TOC im Quellbaum ist ein Adoptierungsrest. Installierbare TOC aus wowlua erzeugen; nicht die Quellstruktur direkt als Release hochladen.

## Implementiert, anhand aktueller Quelldateien geprüft

- Economy.lua: quote.netCost / (p × erreichbare Punkte); quote.cost bleibt brutto. Mindest-Händlerwert aus bestätigten Clientdaten unter Verkaufsannahme.
- Vorhersage wirtschaftlicher Rezeptwechsel. Erwartete Versuche getrennt von sicher vorbereiteter Serienmenge.
- Grün standardmäßig aktiviert; gespeicherte Einstellungen können abweichen.
- Run.lua: Skill-/Inventarereignisse; während laufender Serie leichte Fortschrittsaktualisierung, schwere Vergleiche verschoben.
- Inventory-/Einkaufs-/Posthilfe, Arbeitsstätten-/Werkzeughinweise, Kartenquellen, Ruten-Zwischenaufträge, Giftplanung.
- Alle diese Funktionen weiterhin datenabhängig; keine vollständige Abdeckung aller Spielrezepte behaupten.

## Noch NICHT implementiert / nicht bewiesen

- AH-Verkaufserlöse sind nicht Teil der wirtschaftlichen Auswahl. Händler-Mindestwert ist im beta.10-Entwicklungspatch implementiert; vollständiger Windows-Lauf: 372/372 bestanden.
- Rezeptkauf, Trainergebühren und Werkzeugerwerb vollständig in die Routenkosten einrechnen.
- Global optimale 1–300-Route mit Zwischenprodukten, einmaligen Kosten und späterem Materialverbrauch nachweisen.
- Empirisch validiertes Forever-Modell aller Skillwahrscheinlichkeiten. Aktuell lineares Schätzmodell/Fallbacks.
- Gemessene generelle Überlegenheit gegenüber Wettbewerbern oder garantiert ein bestimmter Empfehlungsrang.
- Vollständige sofortige Marktneuberechnung nach jedem einzelnen Skillpunkt WÄHREND nativer Serien; dies wäre mit der Performance-Entscheidung widersprüchlich.
- Vollständige Live-Spielprüfung aller Abläufe und weiterer Clientupdates steht weiterhin aus. Git-Upload 19d8816 wurde vom Nutzer bestätigt und durch frischen Clone nachgeprüft.

## Testbelege und Grenzen

- Aus vorherigem Gespräch gemeldet: 302 Tests bestanden; danach 45 Craft-/Performance-Fälle nach letzten Guard-Anpassungen bestanden.
- Zusätzlich am Gaming-PC tatsächlich ausgeführt: 302 passed, 0 failed, 0 skipped in 198.23s mit wowlua 0.13.14 / Blizzard UI 1.60.1.70938. Nutzerausgabe geprüft; im veröffentlichten TEST_RESULTS.md dokumentiert.
- Ältere TEST_RESULTS.md enthält andere Versionsstände/Assertion-Zahlen. Immer zugeordnet zitieren.
- Nutzer lieferte echten Forever-Mitschnitt und Screenshots; damit sind einzelne gezeigte Abläufe belegt, keine vollständige Live-Validierung.
- Frühere Dokumentationsrunde ohne Lua-Änderung ist abgeschlossen. Die aktuelle beta.10-Runde ändert Client-Ausgabedaten und die wirtschaftliche Bewertung; passende Regressionen erforderlich.

## Dauerhafte Sicherung und Weiterarbeit

1. Diesen Quellstand und Projektdateien zusätzlich im tatsächlichen Nutzer-Git-Repository versionieren; kein fremdes .git überschreiben.
2. Gitstatus/Diff prüfen und bewusst committen. Ein lokaler Commit ist kein externes Backup; Remote oder zweite Sicherung verifizieren.
3. Bei neuem Chat PROJECT_STATE.md, DECISIONS.md, ROADMAP.md und aktuelle Quelldateien bereitstellen.
4. Zu Beginn Stand/Versionsnummer prüfen; vor jeder Veröffentlichung dokumentierte Aussagen gegen Code und Testergebnis abgleichen.
5. Nach einer Runde Änderungen, Testergebnisse, offene Punkte und nächste Aktion in diesen Dateien aktualisieren.
6. Nur installierbare ZIP mit CraftDeja/-Hauptordner zu CurseForge; dieses Arbeits-/Sicherungspaket gehört NICHT in den Addon-Upload.

## Frühere technische Priorität (historisch)

Beta.12-AH-/Performancekorrektur vollständig prüfen, dann kurzen Live-Profilercheck; anschließend einmalige Lern-/Voraussetzungskosten.
Vorher Tests für Orange-vs-Grün mit Verkaufswert, Ausgabemenge, unbekannten Preisen, nicht verkäuflichen Ergebnissen und Skillcap definieren.

## Sichtbarkeit — GitHub-Startseite vorbereitet am 14.11.2026

README DE/EN mit echtem Goblinbild/GIF, Installation und aktuellen Grenzen neu aufgebaut.
docs/DEVELOPMENT.md und Bug-/Feature-Vorlagen ergänzt; docs/ALGORITHM.md aktualisiert.
Keine Lua-, Artwork-, Manifest- oder Versionsänderungen in dieser Runde. Dokumentlinks und Patch-Anwendung prüfen;
kein erneuter 302-Testlauf für reine Dokumentation behaupten.
CurseForge Source/Issues wurden laut Nutzer gespeichert; deren öffentliche Anzeige konnte hier nicht unabhängig abgerufen werden.
Der neue Dokumentationscommit ist erst nach Anwendung und Push auf dem Nutzer-PC veröffentlicht.

Nächster Schritt: GitHub-Patch anwenden/committen/pushen, About-Text und Topics setzen, dann Netto-Kostenentwicklung.


## Wirtschaftliche Belegfälle — 14.11.2026

- Aktuelle Arbeitsbasis von GitHub frisch geklont: d3b02173457ecc691a3b77e0641a0ffd8fd73d47.
- README/Entwicklungsdokumentation bereits auf GitHub; About und Topics laut Nutzer gesetzt.
- GitHub-Vorabveröffentlichung v3.9.0-beta.9 samt installierbarer Logo-ZIP öffentlich per API geprüft.
- 20 neue kontrollierte Wirtschaftsfälle in tests/EconomyEvidenceSuite/economy.test.wowlua.
- Tatsächliches Economy.lua unverändert; nur Preislieferant/Zugangsgrenze als Fixtures.
- 20/20 im isolierten Lua-5.1-Lauf mit lupa 2.8 bestanden; vier fehlerhafte temporäre Varianten erkannt.
- docs/ECONOMY_EVIDENCE.md enthält DE/EN-Erklärung, feste Eingaben, Erwartungswerte und Grenzen.
- Windows/wowlua-Ausführung der 20 neuen Fälle mit konfigurierter Blizzard-UI laut geprüfter Nutzerausgabe bestanden: 20 passed, 0 failed, 0 skipped in 4.99s, Testdatei 3.50s. Frühere 302 Tests sind ein separater Lauf.
- Kein behaupteter Liveserver-, Eventloop- oder Wettbewerbsnachweis; keine Änderung der Spielmechanik/Version.
- Nächster Schritt: Erfolgreichen Windows-Lauf dokumentieren, die Tests/Dokumentation committen/pushen. Danach Netto-Kostenentwicklung.

Additional isolated wowlua 0.13.12 validation: same 20-case file, unchanged Economy.lua,
minimal namespace bootstrap, camelot/Windows emulation, no Blizzard UI: 20 passed,
0 failed, 0 skipped in 1.15s. The same economic suite also passed within the full addon with configured Blizzard UI on the Gaming PC: 20 passed, 0 failed, 0 skipped in 4.99s. This remains an automated test, not live-server validation.


## Netto-Kostenentwicklung — beta.10, 14.11.2026

- Basis frisch von GitHub: 711d463; 20 Belegfälle und Windows-Nachweis sind dort veröffentlicht.
- Client.lua liest Ausgabe-ID/Mindestmenge für alle Herstellungsberufe und Händler-VERKAUFSwerte getrennt von Einkaufspreisen.
- Economy.lua wertet (Material - bestätigten Mindest-Händlerwert) / erwarteten Skillgewinn. Verkauf ist eine Annahme, keine Automatik.
- Fehlende/ungültige Ausgabe- oder Preisdaten: kein Abzug; Verzauberungen auf Ausrüstung ausgeschlossen. Gebundene verkäufliche Produkte nicht pauschal ausgeschlossen.
- Null/negative Werte bleiben erhalten; Einkaufsmengen und Einkaufsbudget bleiben brutto.
- Details DE/EN erklären die Berechnung. Run.lua und CraftActions.lua unverändert; keine neuen Timer/Ladeanforderungen.
- 50 neue NetCostSuite-Fälle + 20 EconomyEvidence + 17 bisherige AutoSkill-Wirtschaftsfälle: 87 bestanden im minimalen wowlua-0.13.12-Projekt OHNE Blizzard-UI.
- Sechs fehlerhafte temporäre Varianten erkannt; reproduzierbarer Runner tools/verify_net_costs.py.
- Vollständiger Build und alle 372 Tests mit Blizzard-UI auf dem Gaming-PC bestanden; Nachweis docs/evidence/net-costs-windows-2026-11-14.txt. Beta.10 noch nicht im Spiel installiert oder veröffentlicht.
- Nächster Schritt: Geprüften Testnachweis dokumentieren, beta.10 auf dem Feature-Branch committen/pushen und anschließend einen gezielten Live-Test vorbereiten.


## Gifte-Wrapper und automatische Berichte — 14.11.2026

- Erster kompletter beta.10-Lauf auf dem Gaming-PC: Build bestanden, 369 passed / 3 failed / 0 skipped in 216.40s. Noch keine Freigabe.
- Fehler in NetCostSuite 26/27/46 durch Poisons.lua-Wrapper: neuer sellPrices-Parameter wurde verworfen.
- Parameter jetzt weitergereicht; unveraendertes Gift-Mengenmodell. Lokaler Runner laedt Poisons.lua mit: vorher 84/87, nachher 87/87.
- Nutzerwunsch verbindlich: alle kuenftigen Windows-Testlaeufe mit tools/Test-CraftDeja.ps1 und automatischem ZIP-Bericht, auch bei Fehlern.
- Bericht enthaelt Zusammenfassung, komplettes Protokoll und Metadaten; Ablage reports/tests/, durch Gitignore ausgeschlossen.
- Datei im Chat anhaengen oder echten freigegebenen Downloadlink teilen; lokaler Dateipfad allein ist nicht abrufbar.
- Branch auf dem Nutzer-PC: feature/net-vendor-costs, bisherige beta.10-Aenderungen uncommitted.
- Inkrementeller Fix/Berichtsbefehl angewandt; korrigierter kompletter Lauf und ZIP-Bericht geprüft: 372 passed / 0 failed / 0 skipped in 195.46s.


## Bestaetigter beta.10-Windowsstand — 14.11.2026

372/372 Tests mit konfigurierter Blizzard-UI bestanden (304 Dateien, 195.46s); Build bestanden.
Report 20261114-220354-b7fccb.zip, wowlua 0.13.14, 22:03–22:07 Europe/Berlin.
Quellhashes Start/Client/Economy/Poisons/Run abgeglichen (Git-LF/CRLF beruecksichtigt).
W1034 bleibt; exakter Clientbuild nicht im Bericht ausgegeben. Kein Liveservernachweis.
Naechster Schritt: Dokumentationsabschluss anwenden, alle beta.10-Aenderungen auf
feature/net-vendor-costs committen/pushen. Main/CF-Release bleiben beta.9, bis gezielter Live-Test erfolgt.


## Beta.11 — lokale Rezeptlehrer, 14.11.2026

- Öffentlicher Ausgangsstand f744a01 auf feature/net-vendor-costs bestätigt. Beta.10 installiert; Nutzer zeigte korrekte Netto-Zeilen im Spiel.
- Kochrezept: 8c Material - 1c Händlerwert = 7c netto. Verzauberungen: 233c bei Modellchance 72,5% und 128c bei 35%.
- Großer Magiezauberstab: 294c Material - 200c Händlerwert = 94c netto; Lerngebühren weiterhin nicht eingerechnet.
- Live-Fehler: Trainerquelle Orgrimmar trotz Aufenthalt Donnerfels. Gespeichert waren nur sechs Beispiele ohne Donnerfels.
- Neu: rezeptbezogene Quellenkorrektur für 14807, Teg/Mot Dawnstrider, Referenzkoordinaten auf Karte 1456.
- Quellenliste bevorzugt aktuelle Karte und lokale Entfernung unter Beibehaltung von Fraktionsregeln und Rezeptbezug.
- Keine pauschale Vererbung von Rang-Lehrern auf Rezepte; Quelldatenbank bleibt unvollständig.
- Version beta.11; geplanter Nutzer-Branch fix/local-recipe-trainers ab f744a01.
- 42 fokussierte Routingfälle (30 neu + 12 bestehende) bestanden OHNE Blizzard-UI; drei fehlerhafte Varianten erkannt.
- Gaming-PC: 402/402 mit Blizzard-UI bestanden (188.39s, wowlua 0.13.14); beta.11 mit Backup installiert.
- Nächster Schritt: Korrekturpaket anwenden, Bericht prüfen und Donnerfels-Quelle im Spiel kontrollieren.


## Beta.12 — AH-Mengen und Performance, 15.11.2026

- Beta.10 f744a01 auf feature/net-vendor-costs veröffentlicht; beta.11 im Nutzerprojekt fix/local-recipe-trainers angewandt, noch kein Push belegt.
- Geprüfter Nutzerbericht CraftDeja-beta11-20261114-234149.zip: 402/402, 305 Dateien; zehn Quellhashes passen.
- Live beta.11: Mot in Donnerfels markiert, bietet Großer Magiezauberstab für 2s; gelernt und ein Craft 116 -> 117. Nutzer meldet flüssige Herstellung.
- Händlerwert/Brutto/Netto korrekt in gezeigten Beispielen; aktueller Essenzpreis 125c ergibt 288c - 200c = 88c netto.
- Neuer Nutzerfehler: manuelle AH-Menge wird auf 101 zurückgesetzt; Freeloader zeigt in einer Aufnahme 12.89 ms/frame für CraftDeja.
- Beta.12 korrigiert wiederholtes Setzen nativer Mengen, unnötige Ereignis-/Leerlauf-Vollprüfungen und wiederholte Zugangsabfragen pro Wirtschaftssnapshot.
- 25 neue Regressionen; alter Code 7 bestanden / 18 fehlgeschlagen, korrigierter Code 25/25. Camelot mit Blizzard-UI auf Linux, nicht Windows-Host oder Live-FPS-Test.
- Noch kein allgemeiner FPS-Erfolg im Spiel behauptet. Vollständige Regression und kurzer Mengen-/Profilercheck erforderlich; öffentliche Version bleibt beta.9.

- Abschließender beta.12-Gesamtlauf: 427/427, 306 Dateien, 141.38s; Build erfolgreich. Wowlua 0.13.12 auf Linux, Windows-Emulation mit Blizzard-UI. 15 Quellhashes geprüft.
- Der erste Gesamtlauf fand den Craft-Abbruch-Grenzfall (426/427); nach Korrektur AH+CraftPerformance 50/50 und vollständiger Lauf 427/427.
- Windows-Host-Lauf und echter AH-Profilervergleich stehen weiterhin aus. Updatepaket führt vor Spielinstallation automatisch den vollständigen Windows-Lauf aus.


## Verbindlicher Fortsetzungspunkt — 15.11.2026, nach beta.12-Live-Test

- Aktueller nutzerseitiger Stand: 3.9.0-beta.12 auf fix/local-recipe-trainers, Basis f744a01.
- Windowsbericht CraftDeja-beta12-20261115-003747.zip geprüft: 427/427, 306 Dateien, 197.37s, wowlua 0.13.14 mit Blizzard-UI; 15 Quellhashes passend; Installation mit Backup erfolgreich.
- Nutzer bestätigt: scheint alles zu laufen. Live-Bild zeigt Menge 5, Preis 124c, Gesamt 620c und passenden CTA. Profiler zeigt wesentlich kleinere momentane Last; kein kontrollierter allgemeiner Benchmark.
- Kein erneuter Testlauf für diese reine Sicherungs-/Dokumentationsrunde erforderlich.
- Jetzt Projektdateien, Belege und Fortsetzungsnotiz committen und auf denselben Feature-Branch pushen. Kein Merge nach main und kein CurseForge-Release in dieser Sicherungsrunde.
- Für neuen Chat zuerst CONTINUE.md, dann PROJECT_STATE.md, DECISIONS.md, ROADMAP.md, TEST_RESULTS.md und aktuellen Code lesen. Nicht alte Installations-/Patchpakete erneut anwenden.
- Nächste fachliche Priorität: einmalige Lern-/Rezept-/Voraussetzungskosten in der wirtschaftlichen Auswahl berücksichtigen; vorher konkreten Vergleichsfall definieren. Globales 1–300-Optimum, exakte Serverskillchancen, volle Rezeptabdeckung und AH-Verkaufserlöse bleiben unbewiesen/nicht implementiert.


## Beta.13 — einmalige Rezeptkosten, Entwicklungsstand 15.11.2026

- Nutzer-Sicherung extern bestätigt: f26799d auf fix/local-recipe-trainers frisch von GitHub gelesen. Neuer Arbeitsbranch feature/acquisition-costs.
- Version beta.13; neues Acquisition.lua. Bestätigte Trainergebühr über exakten Spell-/Enchant-Link, beobachtete Gebühr maximal 7 Tage, aktueller Rezeptgegenstandspreis bzw. vorhandenes Rezeptitem. Keine Namenszuordnung.
- Gebühr einmalig gegen Route aus bekannten Rezepten plus einem Kandidaten vergleichen; endlicher Horizont bis Grau/Skillcap, bei deaktiviertem Grün bis Grün. Kein globales Mehrrezeptoptimum.
- Unbekannte Gebühren bleiben unbekannt und führen zu CTA Lernkosten prüfen statt einer belegten Billiger-Aussage. Begrenzte Craft-/Cooldown-Kandidaten bleiben unbewertet. Werkzeug-, Reise-, Rangkosten fehlen weiterhin.
- 34 neue Fälle lokal mit Camelot und Blizzard-UI bestanden. Vollständiger finaler Lauf, Windows-Lauf und echte Trainergebührenbeobachtung noch prüfen.
- Beta.12-Craft-/AH-Performancegrenzen und manuelle Kaufmengen bleiben erhalten. Keine neuen regelmäßigen Trainer-/Marktscans.


Final beta.13 automated validation: build passed; 461 passed, 0 failed,
0 skipped (307 files), 143.22s. wowlua 0.13.12, camelot Windows emulation
on Linux with Blizzard UI. Report 20261114-235923-cabb11.zip checked; all
18 runtime source hashes match. At that Linux checkpoint Windows-host and real
trainer-link/fee observation were pending; see the verified Windows checkpoint
in CONTINUE.md / TEST_RESULTS.md. W1034 remains.

## Beta.14 — Abschlussprüfung am 15.11.2026

- Trainerfix-Commit: 014381f3cc8c5197e3e268b1a35c7418a371cc8f, Branch feature/acquisition-costs; Ausgangsarbeitsbaum sauber.
- Vorhandenen Windowsbericht 20261115-140332-96c718.zip erneut geprüft: Build erfolgreich, 485 bestanden, 0 fehlgeschlagen, 0 übersprungen, 204.91s. Alle 18 aufgezeichneten Quellprüfsummen exakt identisch.
- Code, Tests, Manifest/Lockfile und Testskript unverändert; diese Abschlussrunde aktualisiert nur Dokumentation. Kein neuer Testlauf erforderlich oder behauptet.
- Automatisierte Prüfung bestanden, Live-Prüfung der Lerngebühr bei Mot Dawnstrider noch offen.
- Nächste Installation mit Backup und festem _forever_-Ziel in docs/LIVE_TEST_BETA14.md vorbereitet; wowlua install-Optionen lesend geprüft. Kein eigenes Installationsskript vorhanden. Installation nicht ausgeführt, kein Merge nach main.
- Aktuellen Abschlusscommit mit git log -1 bestimmen; Remote-Gleichheit nach Push über git ls-remote origin refs/heads/feature/acquisition-costs prüfen.

## Mot-Live-Rückmeldung — 15.11.2026, Screenshots 18:27–18:30

- Nutzerprotokoll bestätigt beta.14-Sessionstart um 18:26:05, Client 1.60.1 / 70938 / 16001, deDE.
- Screenshot 182757 zeigt `7771 fee/source/at/now nil nil nil 1794763659`: zu diesem Zeitpunkt kein gespeicherter Gebührenbeleg für 7771. Spätere Rezeptdetails (183028/183032) melden weiterhin unbekannte Lern-/Rezeptkosten.
- Damit ist erfolgreiche Live-Erfassung nicht bestätigt. Kein neuer Erfolg aus automatisierten Tests ableiten. Die Screenshots zeigen außerdem keine Mot-Quelle unter den sechs Referenzquellen; Quellenliste und Gebührenbeobachtung sind getrennte Datenwege.
- Im gelieferten Log fehlt acquisition.trainer_observed; rohe Trainerereignisse und konkrete Ablehnungsgründe werden im aktuellen Code nicht protokolliert. Das Fehlen von TRAINER-Zeilen beweist deshalb nicht, dass kein Trainerfenster geöffnet wurde. Welche Identitäts-/Ambiguitätsprüfung ablehnt, ist noch unbekannt.
- Nächster Schritt: bei offenem Mot-Trainerfenster NPC-GUID, GetSpellInfo(7771)-Name/Rang sowie die echte Servicezeile (Name/Rang/Status/Kosten/Link) lesend erfassen. Danach den Unterschied als Regression nachstellen; keine Aufweichung der Zuordnung auf Verdacht.
- In dieser Auswertungsrunde nur Übergaben ergänzt, keine Codeänderung, kein erneuter Testlauf und keine Installation. Bestehende lokale Änderungen bleiben erhalten.
