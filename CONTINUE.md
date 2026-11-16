# CraftDeja — hier fortsetzen / resume here

## beta.21 Release installiert — 16.11.2026, 19:12

- Nach Nutzerhinweis und vollständiger Prozessprüfung installiert: 3.9.0-beta.21-alpha+2d5b5f3, Profil release, Commit 2d5b5f36c9e44bb51800c3aaa5de3462fd6b474e auf codex/bank-flow. Gegenüber geprüftem Quellcommit ec0a1883ef91d0ff558018fb8d946a33b8f33824 nur Übergabedokumentation verändert; sämtliche 374 Quell-/Test-/Inputhashes aus 589/0/0 weiterhin identisch. Kein erneuter Testlauf bei unverändertem Addoncode.
- Vollständiges Backup reports/install/verified-20261116-191154/CraftDeja-before-install.zip: 74 vorhandene Dateien SHA256-verifiziert, vor Ersatz unverändert geprüft und abschließend Archiv erneut geprüft. Alle 73 installierten Payload-Dateien identisch zum geprüften Release-Kandidaten/Installationsbuild. Keine automatische Dev-Instrumentierung/Dev-Runtime; WTF/SavedVariables unverändert.
- Automatischer Installationsbericht reports/install/verified-20261116-191154-bericht.zip: installed_verified. WoW vor Backup, vor Ersatz und nach Installation vollständig beendet. Main unverändert, kein Push, keine Veröffentlichung.
- Nächster Schritt: /cdj version prüfen; Händleroption aus/an, Bank mit TSM, genaue Teilmengen (8 Stoff → 7 behalten/1 einlagern), Fortsetzung zur Herstellung und spätere Entnahme live prüfen. Auftragserhalt beim Berufsaufruf vor/nach Bank beachten. Live-Abnahme offen, Plan docs/BANK_FLOW.md. Frühere Nicht-installiert-Angaben unten beschreiben den vorherigen Stand. Das portable Paket mit ec0a188 bleibt unverändert archiviert; tatsächlich installierter Build steht hier.
## beta.21 — bestätigte Bankbewegungen und Händleroption, 16.11.2026

- Aktueller Feature-Branch codex/bank-flow, Basis d57fe6875ce81cf35a88b80ec5c755219d04d168; vorher sauber. Originalauftrag docs/tasks/BANK_FLOW_REQUEST.md, Analyse und Live-Test docs/BANK_FLOW.md. Keine Veröffentlichung, kein Push, kein Merge nach main.
- beta.20 hatte nur Bankempfehlung und Detailsknopf, keine ausführende Bewegung. Unveränderte Basis reproduziert den Stillstand: reports/bank-flow-baseline/beta20/reports/tests/20261116-183822-0efa7f.zip, 0/1/0 (erwarteter Fehler: Bank action stayed on the details-only step).
- beta.21: expliziter Einlagerungs-/Entnahmeklick, vorhandene Stapel vor freien kompatiblen Plätzen, exakte Teilmengen, Bestätigung beider Bestände, konkrete Restmengen/Status für Platzmangel, Sperre, Ablehnung, geschlossene Bank und ausstehenden Nachweis. Keine blind wiederholten Mengen; verspätete Bestätigung während Craftserie löst keinen schweren Inventarcapture aus. Bankzugriff unabhängig von sichtbarem Blizzard-BankFrame, persönliche Bankgrenzen aus Forever-API geprüft; TSM live weiterhin offen.
- Gespeicherter DE/EN-Schalter unter Allgemein: Beim Händler automatisch öffnen. Standard an; aus unterdrückt Wiederöffnung eines geschlossenen Guides auch bei Updates/Folgepoll. Manuelle Anzeige, Berufsaufruf, Händlererkennung und bestätigte Einkäufe bleiben möglich. Berufsaufruf setzt denselben Auftrag fort.
- Finale breite Prüfung: reports/tests/20261116-183835-968304.zip, Build bestanden, 589/0/0, 320 Dateien, 290.54s, wowlua 0.13.14, Windows/Camelot/Blizzard-UI. Alle 50 Laufzeitquellen, 321 Test-/Profilquellen und drei Inputs SHA256-identisch. Native Source-Emulation, keine Live-Abnahme des kompilierten Bundles.
- 17 neue Regressionen; drei vollständige echte Modulabläufe über Händlerbeschaffung, Bankeinlagerung, native Herstellung, spätere Entnahme und Zielabschluss: Option an, aus sowie Teilentnahme bei vollen Taschen. UI-Belege separat reports/tests/20261116-183335-c8011c.zip: 16/0/0 mit gerendertem Bankknopf/DE-EN-Einstellungen (vor ergänzter direkter Reproduktionsregression).
- Aktuell NICHT installiert: vollständige Prozessprüfung fand Wow.exe und WowVoiceProxy.exe. Installiert bleibt beta.20-alpha+f7aa05e. Erst nach vollständig beendetem WoW mit tools/Install-VerifiedCraftDeja.ps1, erfolgreichem finalem Test-ZIP und sauberem Quellcommit installieren; Script prüft Backup/Build/Payload und erzeugt Bericht. Keine Änderung an WTF/SavedVariables.
- Nächster Schritt: Release beta.21 mit persönlicher Bank/TSM live prüfen: Händleroption aus/an plus Reload, Berufsaufruf vor/nach Bank, 8 Stoff → 7 behalten/1 einlagern, Stapel/Teilkapazität/Schließen/Reopen, Herstellung und spätere Entnahme. Schutzmeldung oder weiterer benötigter Klick ehrlich erfassen. Kein Nachweis einer neuen FPS-Verbesserung.


- Finaler lokaler Quellcommit: ec0a1883ef91d0ff558018fb8d946a33b8f33824. Release 3.9.0-beta.21-alpha+ec0a188 gebaut; alle 73 Payload-Dateien einzeln SHA256 gegen portable ZIP geprüft, keine Dev-Runtime/automatische Instrumentierung. Paket: dist/packages/CraftDeja-3.9.0-beta.21-release.zip; Manifest und DE/EN-Patchnotes daneben. Gesamtbericht: reports/bank-flow-beta21.zip (Analyse, finale Tests, gültige beta.20-Reproduktion, UI-Belege und Release-Manifest). Kein Upload/Push. Spielinstallation wegen laufendem WoW unverändert.

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


Stand: 15.11.2026, beta.17 installiert und automatisiert geprüft; Live-Ergebnis beta.17 offen. beta.16 subjektiv besser, Restspitzen belegt.

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

## Arbeitsbasis (Stand vor der Installation; Installation oben bestätigt)

- Projekt: C:\Users\Tim\Projects\CraftDeja
- Repository: https://github.com/DejaBansh/CraftDeja
- Branch: feature/acquisition-costs. Trainerfix: 014381f3cc8c5197e3e268b1a35c7418a371cc8f. Ausgang der Abschlussrunde ist dieser Commit; Arbeitsbaum war sauber. Der folgende Abschlusscommit ändert nur Dokumentation.
- Aktuellen Sicherungscommit mit git log -1 feststellen und mit git ls-remote origin refs/heads/feature/acquisition-costs vergleichen. Nicht aus älteren Notizen ableiten.
- Entwicklungsversion: 3.9.0-beta.14 in src/Start.lua und wowlua.json. Root-TOC beta.4 bleibt historischer Altbestand; installierbare TOC wird generiert.
- Kein Merge nach main, keine Installation ins Spiel, kein Addon-Release in dieser Runde. Beta.14 ist ein geprüfter Quellstand auf dem Feature-Branch; keine installierte/live bestätigte Version behaupten.
- Bei Arbeitsbeginn AGENTS.md, diese Datei, PROJECT_STATE.md, DECISIONS.md, ROADMAP.md, TEST_RESULTS.md und aktuellen Gitstatus lesen. Keine alten Pakete erneut anwenden.

## Änderung und Ursache

- Nutzerfall: Mot Dawnstrider (NPC 11071), Rezept 7771, Rezeptgegenstand 6345, Trainerlink nil, Lerngebühr 200 Kupfer.
- Beta.13 las die Gebühr, leitete die Rezept-ID aber ausschließlich aus Spell-/Enchant-Links ab und verwarf deshalb diesen Fall.
- Beta.14 ergänzt einen bewusst begrenzten Fallback für die konkret belegte NPC/Rezept/Gegenstand-Beziehung. Zusätzlich nötig: Creature-NPC-GUID, unveränderte Katalogbeziehung, available/unavailable-Angebot, exakter Clientname und Rang via GetSpellInfo, keine doppelten Angebotszeilen oder kollidierenden Katalog-Spellidentitäten.
- Mehrdeutige/fehlende Daten werden abgelehnt, andere unbelegte Nil-Link-Angebote bleiben unbekannt. Keine Namensähnlichkeit, kein Indexraten und keine festgeschriebenen 200 Kupfer: gespeichert wird die aktuelle gültige Angebotsgebühr. Exakte Links bleiben vorrangig.
- Keine neuen Timer, keine Käufe/Trainerfilteränderungen. Native Craft-Busy-Sperre bleibt vor sämtlichen Trainer-/Spellabfragen erhalten.

## Testnachweise

- Finaler Windows/Camelot-Lauf über tools/Test-CraftDeja.ps1, wowlua 0.13.14, konfigurierte Blizzard-UI, Build bestanden: 485 bestanden, 0 fehlgeschlagen, 0 übersprungen, 308 Dateien, 204.91 Sekunden.
- Teilbare ZIP: reports/tests/20261115-140332-96c718.zip. Enthält Bericht, vollständiges Protokoll und Metadaten. Alle 18 aufgezeichneten SHA256-Quellprüfsummen gegen den finalen Code geprüft: exakt gleich.
- 24 neue Nil-Link-Regressionen; zusammen mit bisherigen Erwerbskostenfällen 58 Tests. Fokussierter Zwischenstand 58/58 (6.15s); erster Gesamtzwischenstand 485/485 (201.24s). Finaler Lauf oben erfolgte nach Vereinheitlichung des gespeicherten Herkunftswerts auf trainer und ersetzt die Zwischenstände als Freigabenachweis.
- Erster fokussierter Versuch hatte zwei Typfehler in den neuen Testfixtures (Datei kompilierte nicht); korrigiert. Dieser Bericht ist keine erfolgreiche Suite: 20261115-135846-dc5d9d.zip. Sämtliche Rohberichte bleiben lokal unter reports/tests/.
- W1034 in UnifiedUI.lua:37 bleibt bekannt. Automatisierte API-Fixtures sind kein erfolgreicher Liveserver-/Trainerfenster-Nachweis.

## Offen und nächster Schritt

- Offener Live-Retest: Nach gesondert beauftragter Installation bei Mot tatsächlichen Namen/Rang, NPC-GUID und erfolgreiche Erfassung der 200-Kupfer-Gebühr für Rezept 7771 prüfen. In dieser Runde wurde nichts installiert. Fehlende/abweichende Clientdaten bleiben sicher unbekannt.
- Weitere Trainer/Rezepte nur mit konkreten Belegen ergänzen. Kein allgemeiner Nil-Link-Resolver und keine vollständige Quellenabdeckung behaupten.
- Beta.13-Routenvergleich bleibt begrenzt auf einen unbekannten Kandidaten plus bekannte Rezepte; Werkzeug-/Reise-/Rangkosten, AH-Verkaufserlöse und globales Optimum bleiben offen. Skillwahrscheinlichkeiten sind Modellschätzungen.

## Dauerhafte Übergabe

DE/EN, konkrete grüne CTA, kleiner grauer Auftrag-ändern-Button, automatische Levelmengen unter 300 und Gift-/Produktionssonderfälle erhalten. Keine schweren Vollscans während nativer Serien. Spielaktionen benötigen Nutzerklick.

wowlua: C:\Users\Tim\.wowlua\bin\wowlua.exe (0.13.14); tools/Test-CraftDeja.ps1 ergänzt den Sitzungs-PATH. Frühere lokale Sicherung: reports/backups/beta13-before-handoff-20261115-134230/.
Bei Abschluss diese Datei mit Änderungen, Testnachweisen, offenen Fehlern und nächstem Schritt aktualisieren. Commit/Push mit Remote-Ref vergleichen; Berichte/Backups nicht automatisch veröffentlichen.

## Abschlussprüfung — 15.11.2026

Automatisierte Prüfung bestanden, Live-Prüfung der Lerngebühr bei Mot Dawnstrider noch offen.
Alle 18 Quellprüfsummen aus 20261115-140332-96c718.zip erneut gegen die aktuellen Dateien geprüft: exakt identisch. Code, Tests, Manifest/Lockfile und Testskript sind gegenüber 014381f unverändert; deshalb kein neuer Testlauf in dieser reinen Dokumentationsrunde.
Der konkrete nächste Schritt samt Backup und festem Forever-Ziel ist in docs/LIVE_TEST_BETA14.md vorbereitet. Vorhandenes Testskript tools/Test-CraftDeja.ps1; Installation über das per --help geprüfte wowlua install. Nicht ausgeführt. Main und Spielinstallation bleiben unverändert.

## Mot-Live-Rückmeldung — 15.11.2026, Screenshots 18:27–18:30

- Nutzerprotokoll bestätigt beta.14-Sessionstart um 18:26:05, Client 1.60.1 / 70938 / 16001, deDE.
- Screenshot 182757 zeigt `7771 fee/source/at/now nil nil nil 1794763659`: zu diesem Zeitpunkt kein gespeicherter Gebührenbeleg für 7771. Spätere Rezeptdetails (183028/183032) melden weiterhin unbekannte Lern-/Rezeptkosten.
- Damit ist erfolgreiche Live-Erfassung nicht bestätigt. Kein neuer Erfolg aus automatisierten Tests ableiten. Die Screenshots zeigen außerdem keine Mot-Quelle unter den sechs Referenzquellen; Quellenliste und Gebührenbeobachtung sind getrennte Datenwege.
- Im gelieferten Log fehlt acquisition.trainer_observed; rohe Trainerereignisse und konkrete Ablehnungsgründe werden im aktuellen Code nicht protokolliert. Das Fehlen von TRAINER-Zeilen beweist deshalb nicht, dass kein Trainerfenster geöffnet wurde. Welche Identitäts-/Ambiguitätsprüfung ablehnt, ist noch unbekannt.
- Nächster Schritt: bei offenem Mot-Trainerfenster NPC-GUID, GetSpellInfo(7771)-Name/Rang sowie die echte Servicezeile (Name/Rang/Status/Kosten/Link) lesend erfassen. Danach den Unterschied als Regression nachstellen; keine Aufweichung der Zuordnung auf Verdacht.
- In dieser Auswertungsrunde nur Übergaben ergänzt, keine Codeänderung, kein erneuter Testlauf und keine Installation. Bestehende lokale Änderungen bleiben erhalten.
