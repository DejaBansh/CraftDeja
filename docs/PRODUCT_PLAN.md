# CraftDeja: Produktanalyse und nächste Funktionen

Stand: 16.11.2026. Basis: geprüfter beta.17-Code, flüssiger Live-Release-Vergleich,
aktueller Feature-Branch codex/plan-cost-overview. Produktziel des Nutzers:
ein besonders zuverlässiger Begleiter für möglichst günstiges Berufsleveln.
Das ist ein Entwicklungsziel, kein bereits belegtes Ranking auf CurseForge.

## Was heute belastbar vorhanden ist

- Nettokosten pro erwartetem Skillpunkt, Mehrpunktrezepte, geschätzte gelbe/grüne
  Skillchancen, begrenzte Vorausschau auf Rezeptwechsel (Economy.lua).
- Einmalige beobachtete/gequotete Rezeptkosten gegen einen zusätzlichen
  unbekannten Kandidaten und bekannte Alternativen (Acquisition.lua).
- Bestand, Einkaufen, bestätigte Post, Händler, Werkzeuge, native Craft-Serien
  und Fortschritt; separate Gift-/Produktionsregeln. Käufe und native
  Herstellung behalten ihre vorgesehenen Nutzeraktionen.
- Quellen mit Fraktions-/Zugangsschutz; API-/Clientdaten bleiben beweispflichtig.
- Reproduzierbare Tests und Quellhashes. 520/0/0 als beta.17-Basis;
  Quellemulation ist kein umfassender Liveservertest.
- Live-Rückmeldung: Release-Build ohne automatische Dev-Instrumentierung
  läuft im Nutzervergleich ohne die zuvor beobachteten Freezes. Der konkrete
  GC-/Heapmechanismus und allgemeine FPS-Gewinne sind damit nicht bewiesen.

## Größte Lücke: vollständige Route statt lokalem Rezeptpreis

`selectionAt` bewertet einzelne nächste Skillgewinne; `decide` prüft folgende
Skillstände, bis ein günstigerer Kandidat auftaucht. `learningAssessment`
begrenzt den Vergleich auf eine Erwerbung plus bereits bekannte Rezepte.
Eine globale Minimalroute mit mehreren neu gelernten Rezepten,
Zwischenprodukten, Werkzeugen und endlichem Materialbestand wird nicht gelöst.

Mathematisches Beispiel, synthetische Preise: Ziel zwei Skillpunkte, Rezept A
kostet 100 Kupfer, bringt einen Punkt und hat zunächst Chance 1, danach 0.5.
B kostet 210 Kupfer, bringt zwei Punkte bei Chance 1. Lokal ist A mit 100 pro
Punkt günstiger als B mit 105; zweimal A kostet im Erwartungsmodell insgesamt
300, B erreicht das Ziel für 210. Dieses vereinfachte Beispiel beschreibt eine
Grenze lokaler Bewertung, keine gemessene Einsparung und keinen realen Preisfall.

Für die nächste Routenstufe eignet sich dynamische Programmierung über
Skillstände bei festem Satz bekannter Rezepte. Mehrfaches Lernen braucht
zusätzlichen Zustand und begrenzte Suche; eigener Bestand/Alternativzutaten
und Zwischenprodukte benötigen ebenfalls eigene Ressourcenmodelle.

## Prioritäten und messbare Abnahme

| Priorität | Funktion | Nutzen | Abnahme / Grenze |
|---|---|---|---|
| P0 | Ausschließlich Release-Pakete für Spieler, expliziter Diagnosemodus | Keine Wiederholung der dauerhaften Dev-Kosten | Paketprüfung auf fehlende automatische Instrumentierung, installierbare ZIP-Layout-/Hashprüfung; Dev bleibt Entwicklerwerkzeug |
| P1 | Materialwert, eigener Bestand, geschätzter Zukauf, Nettomaterialwert getrennt anzeigen | Spieler verstehen Goldbedarf und reale Verbrauchskosten | beta.18 erster implementierter Baustein, DE/EN-Rezeptdetails; keine Kaufmengen-/Rankingänderung |
| P2 | Zielskill-Routenvergleich mit bekannten Rezepten | Ganzes Ziel bewerten statt nur nächsten Skillpunkt | Gegen unabhängige vollständige Enumeration kleiner Graphen; obiges Gegenbeispiel, Mehrpunkt-/Cap-/Negativkostenfälle; noch keine 1–300-Garantie |
| P3 | Einmalige Lern-/Rezept-/Rang-/Werkzeugkosten über mehrere Schritte | Keine scheinbar billigen Umwege durch teure Voraussetzungen | Jede Gebühr einmal, explizites Unknown, fraktions-/skillgeprüfte Verfügbarkeit; Werkzeug-/Materialverbrauch nicht doppelt zählen |
| P4 | Kaufen oder Zwischenprodukt selbst herstellen | Reale Materialwege günstiger wählen | Abhängigkeitsgraph mit Zyklusprüfung, Stückzahlen/Mindestausgabe, Bestand, alternative Zutaten; zunächst begrenzte Rezepte |
| P5 | Budgetmodus und Mengenpreise | Route muss mit verfügbarem Gold und Angebot ausführbar sein | Aktuelles Budget, bestätigte Post/Pendenzen, Händlerpacks, AH-Preistiefe, Preisänderungen; Durchschnitts-/Minimalpreis nicht als sicheres Kaufangebot darstellen |
| P6 | Datenvertrauen und Preisalter im Plan | Gute Empfehlung von ungeprüfter Datenannahme unterscheiden | Pro Quelle beobachtet/referenziert/geschätzt, Zeitstempel und klare Aktualisierungsaktion; fehlende Gebühren nicht null |
| P7 | Mehrschritt-Aufträge und sichere Wiederaufnahme | Weniger Fensterwechsel, weniger verlorene Aufträge | Persistente Aufgabe statt automatischer Spielaktionen; Wiederaufnahme nach Logout/Abbruch/Preisänderung, manuelle Mengen respektieren |
| P8 | Freiwillige Skillchance-Kalibrierung | Schätzmodell mit echten Forever-Versuchen verbessern | Anzahl Versuche/Skillups, Unsicherheit und Clientbuild sichtbar; kleine Stichproben ersetzen Modell nicht, kein automatischer Datenupload |
| P9 | Preis-/Routenvarianten mit erklärtem Unterschied | Spieler können günstig, wenig Zukauf und wenig Umwege vergleichen | Gleiche Datengrundlage und Ziel; abweichende Optimierungsziele nicht als dieselbe globale Billigroute verkaufen |

AH-Wiederverkauf/Profit-Prognosen kommen nach diesen Grundlagen. Verkaufspreis,
Gebühren, Verkaufswahrscheinlichkeit und gebundenes Gold sind unsicher. Ein
vermeintlich garantierter Gewinn würde Vertrauen kosten und ist kein Ersatz für
günstiges Leveln. Kein Offline-Crafting oder Kauf-/Cast-Automatismus ohne die
vom Client vorgesehenen Eingaben.

## Bereits integrierter erster Baustein: beta.18

`materialPlan.costs` verwendet ausschließlich die ohnehin ermittelte Quote,
Craft-Anzahl und Materialplanung. Keine neue API-Abfrage, kein Timer, kein
zusätzlicher Rezept- oder Inventarscan. Die Anzeige erscheint in Rezeptdetails:

- vollständiger Materialwert mit den verwendeten Zutatenpreisen;
- Wert des tatsächlich verwendeten eigenen Bestands (nicht des ganzen Lagers);
- geschätzter Einkaufswert fehlender Zutaten vor einem späteren Verkauf;
- bei unbekanntem Bestand eine ausdrücklich unvollständige Schätzung;
- angerechneter Händlererlös und Nettomaterialwert unter Verkaufsannahme.

Lern-/Rezept-/Voraussetzungskosten können zusätzlich anfallen. Die Zahlen gelten
für die angezeigte Craft-Anzahl, nicht für alle zukünftigen Rezepte. Bestätigte
Post oder laufende Käufe können Fehlmengen bereits abdecken; Packungen können
Reste hinterlassen. Diese Übersicht ist kein zweites Kaufbudget. Die bisherigen
Kauf-/Craftregeln und die wirtschaftliche Rezeptwahl bleiben unverändert.
Giftsonderpläne ohne diesen Kostenblock und Produktion ab 300 werden durch die
neue Anzeige nicht umdefiniert. Ein allgemeiner Mehrrezept-Kostenblock folgt erst
mit der jeweiligen Planungsunterstützung.

Neun fokussierte Tests prüfen echten Materialplan, Teil-/Voll-/Nullbestand,
unbekannten Bestand, bestätigte Mindestausgabe, unbekannten Erlös, Verzauberungen,
negative Nettowerte, Cap und tatsächliche DE/EN-Detailanzeige. Der Zählerfall
belegt: keine zusätzlichen Preis- oder Inventarabfragen. Vollständigen finalen
Nachweis und Installationsstatus in TEST_RESULTS.md und CONTINUE.md nachlesen.

## Einordnung des Wettbewerbs

Primäre Projektseiten am 16.11.2026 gelesen:

- [CraftSim](https://www.curseforge.com/wow/addons/craftsim): Retail-orientierte
  Professionssimulation und Crafting-Queue. Funktionsbeispiel, kein Nachweis
  einer gleichartigen Forever-Levelroute oder kompatiblen API.
- [TradeSkillMaster](https://www.curseforge.com/wow/addons/tradeskill-master):
  breiter Wirtschaftsbegleiter für Crafting, AH und Verkauf. CraftDeja sollte
  passende Daten nutzen und den Einstieg erleichtern, statt diese Suite zu kopieren.
- [Skillet-Classic](https://www.curseforge.com/wow/addons/skillet-classic):
  alternatives Berufsfenster mit Warteschlange/Einkaufshilfe. Kein eigener
  Vergleichstest gegen CraftDeja durchgeführt.
- [CraftDeja](https://www.curseforge.com/wow/addons/craftdeja): gelesene Seite
  zeigt beta.9 als Hauptdatei. Moderations-/Cacheverzögerungen sind möglich;
  vorbereitetes beta.17-Paket ist nicht automatisch veröffentlicht.

Abgeleitete Positionierung: nachprüfbar günstiges Forever-Leveln mit einem
klaren nächsten Schritt, vollständigen Kosten und geringer Hintergrundlast.
Downloadzahlen oder Funktionslisten beweisen keine beste Levelroute.

## Reihenfolge der nächsten Auslieferungen

1. beta.17-Uploadpaket mit vorhandenen Patchnotes erhalten; Nutzer veröffentlicht.
2. beta.18-Kostenübersicht breit prüfen und Release-Paket separat bereitstellen.
3. P2-Routenvergleich zunächst als optionale Vorschau mit unabhängigem Oracle.
4. Erst nach Belegfällen die Wahl des nächsten Rezeptes durch diese Route steuern.
5. Danach P3/P4, anschließend Budget-/Mengenpreisoptimierung und Mehrschrittaufträge.

Veröffentlichungen benötigen zutreffende DE/EN-Beschreibung, nachvollziehbare
Beispiele und den passenden Test-/Clientstand. README und Übergaben müssen dem
Code folgen; veraltete beta.11-Angaben oder Aussagen, Trainergebühren seien
grundsätzlich nicht berücksichtigt, werden in dieser Runde konsistent korrigiert.
