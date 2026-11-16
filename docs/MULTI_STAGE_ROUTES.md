# Mehrstufige Levelrouten / Multi-stage leveling routes — beta.19

## Bedienung

Berufsfenster öffnen, dann **/cdj route** (oder **/cdj routen**). Ziel ist standardmäßig die Grenze des aktuellen Berufsrangs; `/cdj route 75` setzt ein Ziel vor. Der Menüpunkt „Levelroute“ öffnet dieselbe Ansicht. „Route planen“ beginnt einen gespeicherten Auftrag. „Route beenden“ kehrt zur bisherigen Planung zurück. Giftplanung und manuelle Produktionsaufträge starten keine Levelroute.

Zunächst frischen Auctionator-Scan abschließen. **Routenangebote prüfen** sucht die noch benötigten AH-Gegenstände über die bestehende Auctionator-API. Entscheidende Suchergebnisse/Angebote öffnen, damit die vorhandene Warenansicht Preisstaffeln und Mengen liefert. Die Suche kauft nichts und ersetzt keinen laufenden Kaufauftrag. Einzelauktionen ohne beobachtbare Mengentiefe bleiben vorläufig; keine erfundene Marktliquidität.

Der Guide behält genau die nächste Aktion. Routen-/Kosten-/Lehrer-/Lieferantendetails sind aufklappbar. Ein vorgeschlagener erster Rezeptwechsel nach Preisänderungen muss übernommen werden; offene Kaufvorgänge verschieben die Neuberechnung. Normale manuelle Kaufmengen werden nicht zurückgesetzt.

**Noch offene Zahlungen** und **wirtschaftliche Nettokosten** sind getrennt. Verbrauchter Eigenbestand hat einen Wert, obwohl dafür kein neuer Einkauf anfällt. Bei fehlendem Nachweis zeigt die Gesamtkostenanzeige unbekannte Werte und Gründe statt eines scheinbaren Nullpreises. Tatsächliche Skillups und Taschenänderungen lösen eine Restplanung aus, keine Buchung geschätzter Erfolge.

## Reproduzierbarer Ingenieurskunstvergleich 1–75

Automatisierte Referenz: `tests/RouteCoreSuite/reference.test.wowlua`. Echte IDs, Zutaten und Skillbereiche aus `app.catalog[202]`; Ausgabeidentitäten als explizite Forever-Referenzdaten im Test. **Preise, Gebühren, Verkaufserlöse und Zugangsbestätigungen sind kontrollierte Fixtures, keine Live-Marktdaten.** Im echten Modell werden Referenzen nicht als eingelesene Clientbelege ausgegeben.

Start 1, Ziel 75, Ranggrenze 75, leerer Bestand, grüne Rezepte zulässig. Preisstand 1000, ausreichende beobachtete Tiefe 10.000 Stück je Material. Kupferpreise pro Stück: Rauer Stein 2, Kupferbarren 5, Leinenstoff 1, Schwaches Flussmittel 1, Raues Sprengpulver 100, Kupferbolzen 100, Kupferrohr 20. Lerngebühr 10 je verwendetes Rezept, Händlererlös konservativ 0. Vorhandene Wahrscheinlichkeitsfunktion; erwartete Versuche je zusammenhängendem Abschnitt auf ganze Crafts aufgerundet.

| Abschnitt | Rezept | erwartete ganze Crafts |
|---|---|---:|
| 1–30 | 3918 Raues Sprengpulver, Ausgabe 4357 ×2 | 33 |
| 30–45 | 3922 Eine Handvoll Kupferbolzen, Ausgabe 4359 ×1 | 15 |
| 45–60 | 3923 Raue Kupferbombe, Ausgabe 4360 ×2 | 15 |
| 60–75 | 3924 Kupferrohr, Ausgabe 4361 ×1 | 15 |

Rohstoffe: 33 Stein = 66 Kupfer; 60 Kupferbarren = 300; 15 Stoff = 15; 15 Flussmittel = 15; vier Lerngebühren = 40. **Zukauf 396, Lernen 40, gesamte offene Zahlung und Netto 436 Kupfer.** Die 15 Bomben verbauen 30 selbst hergestellte Pulver und 15 Bolzen. Dafür weder zusätzlich einkaufen noch Verkaufserlös buchen. Restpulver hat in dieser Fixture keinen Erlös.

Unabhängige vollständige Alternative: Pulver 1–30 (33 Crafts), Bolzen 30–50 (21 Crafts), Rohre 50–75 (25 Crafts): Materialeinkauf 446 + Lernen 30 = **476 Kupfer**. Gleicher Start/Ziel/Preisstand, **40 Kupfer Nettoersparnis** der gewählten Route gegenüber genau dieser Alternative. Gleiche gewählte Abschnitte ohne Wiederverwendung würden 4.936 Kupfer kosten; das ist ein separater Buchungsnachweis, kein Ersatz für den Vergleich verschiedener Rezepte.

Der Test prüft diese Beträge als Regression und erzeugt auf Wunsch eine aus den ausgeführten Ergebnissen gerenderte Belegabbildung. Native JSON-Ergebnisse enthalten Testlaufzeiten. Emulierte Gesamtlaufzeit und Coroutine-Aufrufzahlen sind keine tatsächlichen Ingame-Framezeiten oder FPS-Gewinne.

## Silberrute: AH / eigener Schmied / Gilde

Referenz: Schmiederezept **7818 → Item 6338**, eine Rute, Zutaten **1 Silberbarren 2842 + 2 Rauer Schleifstein 3470**. Preisfixture: fertige Rute AH 1.000 Kupfer, Barren 200, Schleifstein je 50. Alle drei Zutaten bereits vorhanden, wirtschaftlicher Wert insgesamt 300.

| verfügbare Quelle | weitere Zahlung | Nettokosten | Ersparnis gegenüber günstigster anderer verfügbarer Quelle |
|---|---:|---:|---:|
| AH, eigener Schmied ebenfalls verfügbar | 1.000 | 1.000 | keine |
| eigener Schmied, Gilde ohne Zusage | 100 Versand/Übergabe | 400 | 600 gegenüber AH |
| Gildenschmied, bestätigt/online/frisch | 20 Gesamttrinkgeld + 10 Übergabe = 30 | 330 | 70 gegenüber eigenem Schmied |

Gleichstand bevorzugt AH. Ohne aktuellen AH-Vergleich und ohne weitere bestätigte Alternative wird kein günstigerer Herstellerweg bewiesen. Bei fehlendem Rezept-/Bestands-/Übertragungs-/Preisnachweis bleibt er Option. Vorhandene Twink-Vorräte werden nur einmal reserviert, mit Datum und gesondert bestätigten Übergabekosten. Alte BoE-Gegenstände werden ohne Bindungsbeleg vorsichtig nicht als übertragbarer Altbestand behandelt. Neu hergestellte BoE-Ausgaben dürfen übertragbar sein.

Runenruten werden anhand echter, eindeutiger Clientvoraussetzungen als einmalige Werkzeugkette einbezogen. Die Beschaffung der Metallrute führt nach tatsächlichem Taschenzugang zur bestehenden nativen Runenruten-Vorbereitung zurück. Kein geschätztes Item wird als geliefert verbucht.

## Trainer

Nur exakt zugeordnete, eindeutige Angebote der gewählten Route: spätere, jetzt verfügbare Rezepte stehen in derselben Liste mit Gesamtgebühr. Gesperrte Angebote zeigen den gemeldeten Skillbedarf. Unbeteiligte oder doppelte Angebote werden ausgeschlossen. Ein Klick fordert **höchstens ein** nach NPC, ID, Preis und Gold erneut geprüftes Rezept an. Erst `learned` aus der Client-API oder das exakt passende `used`-Angebot bestätigt Erfolg. Kein Timer klickt weitere Dienste an.

Bekannte erste Rang-IDs: Engineering **4037**, Enchanting **7412**, jeweils 75→150. Nur exakter Angebotlink kann Ranggebühr und Mitlernen belegen. Weitere Ränge und Rangbücher verwenden vorhandene Trainer-/Buchhinweise; ohne ID/Gebühr bleibt die Zielüberschreitung ausdrücklich vorläufig. Keine Rang-ID aus ähnlich klingendem Namen erraten.

## Gilde, Privatsphäre und gespeicherte Aufträge

„Gildenrezepte teilen“ ist **standardmäßig ausgeschaltet**. Aktivierung registriert den Präfix `CDJRoute1` und nutzt ausschließlich `GUILD`. Nachrichten enthalten nur Beruf, Skill, gelernte freigegebene Rezept-/Ausgabe-ID, Mindestmenge und Bestätigungszeit. **Keine Taschen-, Bank-, Goldbestände oder privaten Preiskonditionen.** Empfang prüft aktuelle Gilde, Mitgliederliste, kanonische Rezept-/Item-/Berufsbeziehung, Wertebereiche und Nachrichtenlimits. Opt-out sendet `OFF`, entfernt Daten; Gildenwechsel trennt den Cache. Status und Alter werden angezeigt.

Freigabeliste: Silberrute 6338/7818, Goldrute 11128/14379, Echtsilberrute 11144/14380, Arkanitrute 16206/20201, Salzstreuer 15846/19567. Kupferrute 6217 ist als Werkzeug zulässig, hat aber keinen freigegebenen Herstellerspruch und wird nicht als erfundener Schmiedecraft geteilt. **Erze, Barren, Bolzen, Pulver, Stoffe und alle Gilden-Unteraufträge dafür sind ausgeschlossen.** Zutaten eines erlaubten Werkzeugs kommen aus eigenem Bestand oder AH; keine rekursive Gildenbeschaffung.

Nur bestätigte Konditionen, Zusage, Online-Status und frische Daten erlauben eine Gildenempfehlung. „Eigene Materialien + Gesamttrinkgeld“ und „Festpreis pro Ausgabepaket“ sind getrennt. Gesamttrinkgeld und Übergabekosten werden im Routenledger je Herstellerauftrag einmal angesetzt. Neue Konditionen werden lokal eingegeben, nicht automatisch ausgehandelt.

Whisper öffnet nur einen Entwurf; der Spieler sendet ihn. Materialübergabe wird ausdrücklich vorbereitet und nach beobachteter Taschenabnahme ausdrücklich bestätigt. Diese Abnahme **beweist nicht die Identität des Empfängers**; sie ist zusammen mit der Spielerbestätigung ein manueller Übergabebeleg. Erhalt wird erst mit tatsächlichem fertigem Gegenstand in Taschen bestätigt. Kein automatisches Handeln, Versenden, Lernen oder Herstellen.

„Gilden-Craft überspringen und im AH kaufen“ steht in Lieferantendetails und bei einem aktiven Gildenschritt auch als zweite Guide-Aktion bereit. Der pro Gegenstand gespeicherte AH-Wunsch überlebt Preisänderung, Charakterwechsel und Reload; nur ausdrückliches Zurücksetzen entfernt ihn. Ein fehlendes Angebot löscht diese Wahl nicht. Bereits übergebene Materialien werden nicht als weiter vorhanden angenommen.

## Abnahmematrix

Die automatisierten Belege verwenden die echten Module; beobachtete API-Antworten, Inventar und Marktpreise sind definierte Fixtures. Der abschließende Bericht nennt die tatsächlichen Ergebnisse.

| Auftragsfall | Regression / Nachweis in RouteCoreSuite |
|---|---|
| 1 Gesamtziel, Zwischenprodukte, Gleichstand | `core`: outputs/reuse; `reference`: Engineering 1–75, ties |
| 2 Preisstaffeln/Mengen/fehlende Daten | `core`: quantity tiers, provisional; `integration`: changed depth and live quote |
| 3 Bestand/Post/einmalige Reservierung/Skillfortschritt | `core`: stock and fees; `integration`: incoming mail, progress |
| 4 Mitlernen, gesperrte/unbeteiligte/mehrdeutige Angebote | `safety`: trainer route, route rank |
| 5 Schmiede-Twink gegen AH/Gleichstand | `reference`: silver rod; `core`: supply |
| 6 Bestandswert, Versand, alte Daten/Übertragbarkeit | `reference`: silver rod; `safety`: transfer proof, supply proof, remote stock |
| 7 Gildenpreis/Zusage/online/Alter/Opt-out/Gildenwechsel | `core`: supply; `safety`: protocol, stale supply |
| 8 Ruten/Salzstreuer und rekursives Bulk-Verbot | `safety`: whitelist; `core`: bulk subcontract |
| 9 Gespeicherter AH-Wunsch | `integration`: shared account order and AH choice; `safety`: saved AH override |
| 10 Fertige Rute, gleicher Auftrag, native Vorbereitung | `integration`: received rod, own-alt craft plan; `reference`: prerequisite chain; bestehende RodSuite/Native-Craft-Tests |

Die komplette Suite umfasst zusätzlich die bisherigen Gift-, Produktions-, Material-/Post-, Kaufmengen-, Trainer- und Performance-Regressionen. Zwei echte Spieler, tatsächlicher Versand und alle Serverantworten werden damit nicht live bewiesen; dafür gilt der folgende Live-Testplan.

## Suchgrenzen und Aufwand

Verglichen werden vollständige Routen desselben Snapshots, kein uneingeschränktes globales Optimum. Die Suche nutzt vollständige Startkandidaten, maximal 512 Knoten kurzer Wechselketten (bis vier Abschnitte), danach eine begrenzte Beam-Suche (live Breite 6, maximal 4.000 Ledger-Erweiterungen). Identische vollständige Kandidaten werden dedupliziert. Der Vergleich berücksichtigt Materialreste; Gleichstand bevorzugt keinen zusätzlichen Zwischenproduktcraft, dann weniger modellierte Lehrerbesuche. Die Besuchszahl ist eine Abschätzung anhand benötigter Lernzeitpunkte; die tatsächliche Zusammenfassung wird im offenen Lehrerfenster entschieden.

Preis-/Bestandszustände der Eingaben werden eingefroren. Auswahl austauschbarer Reagenzien erfolgt im Snapshot nach beobachteten Kosten; kein kombinatorisch vollständiger Austausch aller Reagenzvarianten. Skillwahrscheinlichkeiten bleiben das bestehende Modell. Stets als Erwartung anzeigen, nie garantierte Craft-Anzahlen.

Coroutine-Arbeit erfolgt nur bei aktivem Auftrag und Datenänderung, mit begrenzten Fortsetzungen je Frame. Während nativer Serien oder ungeklärter Käufe keine neue schwere Modellbildung. Im Leerlauf ohne Aufgabe ist das zusätzliche Laufzeitfenster verborgen. Gildenwarteschlange nur auf ausdrückliche Aktivierung, begrenzt und anschließend ruhend; keine permanenten Berufs-/Inventar-/Routenscans. Release-Paket enthält keine automatische wowlua-Dev-Instrumentierung.

## Abnahme und offene Live-Prüfung

Die gezielten Regressionen decken die zehn angeforderten Fallgruppen mit kontrollierten Daten ab: gleiche Ziele/Teile/Bindungen, Preisstufen/fehlende Preise, Bestand/Post/Restskill, spätere Trainerrezepte, Alt-/AH-Vergleich, wirtschaftlicher Altbestand einschließlich Versand, Gildenkonditionen/Alter/Scope, Bulk-Sperre, persistente AH-Abwahl und tatsächliche Lieferung/Runenruten-Voraussetzung. Der abschließende Ergebnisstand steht in TEST_RESULTS.md; bestehende Einkaufs-, Gift-, Produktions-, Trainer-, Rod- und Performancesuiten werden vollständig mitgeprüft. Ein bestandener Modul-/Integrationsfall ersetzt keine Zwei-Client-Liveprüfung.

Kurzer Live-Test mit Release-Build:

1. Gleiches Addonset wie beim flüssigen beta.18-Vergleich, 60–90 Sekunden Leerlauf, keine Performanceaufnahme aktivieren. Neues Routenfenster DE/EN auf abgeschnittene Texte prüfen.
2. Engineering öffnen, Ziel 75 setzen, gemeinsamen Auctionator-Scan durchführen, Routenangebote öffnen. Datum/Menge/Staffeln prüfen; ein knappes Billigangebot und danach teure Restmenge vergleichen. Fehlende Daten müssen „vorläufig“ bleiben.
3. Eine Kaufmenge manuell verkleinern. Preis-/Inventarereignisse und offenen Dialog abwarten: kein Zurücksetzen, kein doppelter Kauf. Wenige echte Crafts mit Skillup/ohne Skillup; Restbedarf kontrollieren.
4. Lehrer öffnen: zukünftige jetzt lernbare ausgewählte Rezepte plus Gesamtgebühr, gesperrte/unnötige ausgeschlossen. Einzeln lernen und nur tatsächlichen Erfolg abhaken. Rang 75→150 nur bei exakt zugeordnetem Angebot testen.
5. Schmiede-Twink einmal mit offenem Beruf und Bestand einlesen. Beim Verzauberer gleiche Rutenmenge gegen AH vergleichen, Übergabekosten explizit bestätigen. Twink wechseln, fehlendes Material besorgen, native Herstellung selbst starten. Rute übertragen; auf dem Verzauberer tatsächlichen Zugang und bestehende Runenrute prüfen.
6. Zweiter Spieler mit demselben Build, gleiche Gilde: Freigabe erst jetzt aktivieren. Nur freigegebene Rute/Salzstreuer sichtbar, keine privaten Bestände; offline/Opt-out/Gildenwechsel prüfen. Whisperentwurf selbst senden, Konditionen bestätigen, Materialübergabe und Wareneingang prüfen.
7. Nach Anfrage/Zusage AH-Abwahl testen; Preisupdate, `/reload` und Charakterwechsel. AH bleibt gewählt, auch ohne Angebot; keine Gilden-Unteraufträge für Barren oder Pulver. Freigabe danach bei Bedarf wieder ausschalten.

## Primärreferenzen

- [Raues Sprengpulver 3918](https://www.wowhead.com/forever/spell=3918/rough-blasting-powder), [Kupferbolzen 3922](https://www.wowhead.com/forever/spell=3922/handful-of-copper-bolts), [Raue Kupferbombe 3923](https://www.wowhead.com/forever/spell=3923/rough-copper-bomb).
- [Silberrute 7818](https://www.wowhead.com/forever/spell=7818/silver-rod), [Goldrute 14379](https://www.wowhead.com/forever/spell=14379/golden-rod), [Echtsilberrute 14380](https://www.wowhead.com/forever/spell=14380/truesilver-rod), [Arkanitrute 20201](https://www.wowhead.com/forever/spell=20201/arcanite-rod), [Salzstreuer 19567](https://www.wowhead.com/forever/spell=19567/salt-shaker).
- [Engineering Rang 2, 4037](https://www.wowhead.com/forever/spell=4037/engineering), [Enchanting Rang 2, 7412](https://www.wowhead.com/forever/spell=7412/enchanting). Referenzdaten sind keine aktuelle Servergebühr; Gebühren werden live beobachtet.
