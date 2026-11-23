# Beschaffung und Herstellungsserien · Ablaufentwurf

Stand 23.11.2026. Live-Beleg aus Beta.25, deDE, Client 1.60.1 Build 71037. Codeprüfung am Beta.26-Arbeitsstand 6daffa3fc5c27449e07a441cb6a75dccc178b5f0. Der lokale Kandidat beta.27 setzt die nachstehenden Bedienwege um. Die ursprünglichen Abnahmeszenarien folgen darunter.

## Bedienung in beta.27

- Beim geöffneten Händler oder AH im Guide **Rezepte bis Skill 300 prüfen** wählen. Die separate Suche nutzt die vorhandene Routenbewertung. Sie zeigt den aktuellen Lernschritt bereits während der Suche. Reicht die Datenlage nur für einen Teilweg, nennt sie dessen Endskill, sobald ein solcher Teilweg vorliegt.
- Den offenen Händlerbestand mit den noch fehlenden Rezepten vergleichen. Die Summe umfasst den aktuellen Bedarf und Rezepte der besten Route, die auf mindestens zwei unterschiedlichen, ähnlich günstigen Rezeptfolgen liegen. Als ähnlich gelten hier Kandidaten mit vergleichbarer Beleglage und höchstens 15 % Kostenabstand zum besten Ergebnis. Jede Anschaffung einzeln bestätigen. Für optionale Rezepte wird kein Geld vorgemerkt.
- Bei einem bekannten, höchstens sieben Tage alten, am zugeordneten Händler beobachteten Rezeptpreis im AH ein Exemplar bis einschließlich 115 % prüfen. Ist der Händler bereits für ausstehende Zutaten eingeplant, muss das AH den Händlerpreis unterbieten. Der Guide berechnet keine Reisezeiten. Einzelauktionen brauchen einen identischen aktuellen Sofortkauf. Als Handelsware klassifizierte Rezepte verwenden die Auctionator-Bestätigung. Ungeklärte Einzelkäufe lassen sich nach manueller Post-/Taschenprüfung freigeben.
- Bei grünem Rezept den Abschnittsbedarf oder die doppelte geschätzte Menge wählen. Der Guide nennt den geschätzten Aufpreis und zeigt beide Zutatenmengen im Tooltip. Produktionsaufträge und Rezepte mit nativer Versuchsbeschränkung behalten ihre Stückgrenzen.
- Bei Handwerksserien können vorhandene Zutaten für eine geschätzte Serie vorbereitet werden. Am Ziel muss der Spieler selbst stoppen. Bei einer nachweislich physischen Ausgabe wie einem Zauberstab ist die native Mengenwahl möglich. Echte Zielverzauberungen benötigen weiterhin ein Ziel.
- Beim Rezeptkauf unterscheidet der Guide Taschen, Lager, ausstehende Post und das Lernereignis. Bei einem unbewerteten Pflichtslot in einer Rute nennt er die betroffene Zutat. Die genaue Ursache des ursprünglichen Silberruten-Hängers ist weiterhin live zu prüfen.

## Kochkunst und Zauberstab

Log #13135 zeigt für Rezept 7828 bei 219/225 genau 33 mögliche, 30 geschätzte und 6 vorbereitete Versuche. #12988 bestätigt für 213/225 die Übergabe von 12 an den Originalbutton. Economy.lua summiert in expectedCraftAttempts die erwarteten Versuche je Skillstufe. CraftActions.lua begrenzt in craftBatchInfo die native Serie auf den Abstand zur nächsten Grenze unter der Annahme, dass jeder Versuch gelingt. Beim Zauberstab ist die Ursache der tatsächlichen Einkaufsmenge noch offen. Auch die pauschale Verzauberkunst-Behandlung in craftNext für physische Rezeptausgaben prüfen.

- Den Materialbedarf bis zum nächsten echten Rezept-, Ziel- oder Rangwechsel einmal pro Abschnitt bestimmen. Händler, AH und Herstellungsansicht nutzen denselben Restbedarf. Bestände, bestätigte Bestellungen und Post nur einmal anrechnen. Bei Teilkäufen offene Mengen fortschreiben.
- Für einen Punkt bei konstant 25 % Chance vier Versuche als Erwartungswert anbieten. Bei einem Holz und zwei Essenzen je Versuch und leerem Vorrat sind das vier Holz und acht Essenzen. Nach einem Fehlversuch mit den übrigen drei Versuchen am Herstellungsort bleiben. Vor einem weiteren Einkauf erst den vorhandenen Rest prüfen.
- Im Guide Schätzmenge und native Serie getrennt benennen. Bei ausreichendem Bestand eine geschätzte Serie vorbereiten. Vor Umsetzung in Forever prüfen, ob eine laufende native Serie beim tatsächlichen Erreichen des Ziels zuverlässig und zulässig beendet werden kann. Falls nur der Spieler stoppen kann, die längere Serie mit sichtbarem Hinweis auf möglichen Mehrverbrauch anbieten und die sichere Menge als Alternative erhalten. Explizite Stückaufträge bleiben auf die bestellte Menge begrenzt. Keine schweren Vollscans pro Cast.

## Runenverzierte Silberrute

Den Zutatenbedarf aus dem gelernten Rutenrezept lesen und alle Slots samt Mengen anzeigen. Vorhandene wiederverwendbare Werkzeuge getrennt behandeln. Fehlt ein Preis, den betroffenen Gegenstand konkret nennen und verfügbare Bezugswege anzeigen. Keine Preisannahme treffen. Nach Teilkauf, Post und Banktransfer nur die offenen Mengen ändern. Erst nach bestätigtem Rutenausgang und erfüllter Werkzeuganforderung zum ursprünglichen Rezept zurückkehren. Der aktuelle RodPreparation-Code kennt getrennte Wartezustände für Preis, Bestand und Werkzeug. Welcher Zustand live blockierte, ist im angehängten Ereignisfenster nicht belegt.

## Rezeptkauf und Wege

Drei getrennte Nachweise führen: vom Händler angeboten, Rezeptgegenstand erhalten, Rezept gelernt. Nach bestätigtem Eingang den Händlermarker entfernen und bei erfüllten Voraussetzungen „Rezept lernen“ anbieten. Erst nach bestätigtem Lernen weiterplanen. Bleibt der Lernschritt gesperrt, konkrete Voraussetzung nennen. Ein Kaufklick allein ist kein Nachweis.

Beim Händlerbesuch die Rezeptbeschaffung für den aktiven Beruf vom aktuellen Skill bis **300** betrachten, auch wenn der nächste Herstellungsabschnitt am Ranglimit endet. Der aktuelle Auftrag behält sein Ziel. Für die Einkaufsvorschau spätere Ränge, Lernvoraussetzungen und mögliche Rezeptwechsel berücksichtigen. Ein heute kaufbares, erst später lernbares Rezept kann mitgenommen werden. Schon gelernte, eingelagerte, gekaufte oder per Post ausstehende Exemplare abziehen. Unklare Bestände kennzeichnen.

Für den ganzen Einkaufsstopp zwei Wege vergleichen: heute bündeln oder später beschaffen. Dazu Rezeptpreise, erwartete Materialkosten der jeweiligen Skillroute und den zusätzlichen Reiseaufwand betrachten. Einen gemeinsamen Rückweg für mehrere Rezepte nur einmal zählen. Führt die spätere Route ohnehin zu diesem Händler, entfällt der Vorteil eines vermiedenen Sonderwegs. Bei gleichem Preis und plausibel benötigtem Rezept den Kauf jetzt empfehlen, wenn er eine eigene Rückreise spart. Ist ein Weg sowohl günstiger als auch kürzer, ihn bevorzugen. Bei einem echten Zielkonflikt Mehrpreis und eingesparten Weg nebeneinander zeigen und die Wahl lassen. Minuten nur mit belastbarer Wegschätzung ausweisen. Ein unbekannter Preis oder ein unbekannter Reiseweg zählt nicht als null.

Ein teures Rezept, das nur eine unsichere Alternativroute braucht, als optional anzeigen und aus der vorbelegten Kaufsumme herauslassen. Beim geöffneten Händler Angebote, Verfügbarkeit, Kaufvoraussetzungen, Budget und Taschenplatz prüfen. Beim zusätzlichen Händler unterwegs auch Erreichbarkeit und Umweg prüfen. Der Vorschlag nennt pro Rezept den voraussichtlichen Skillbereich und Preis, für den gesamten Stopp die Summe und den erwarteten Reisevorteil. Änderungen an Preisen oder gelernten Rezepten dürfen die Vorschau beim nächsten relevanten Planungsanlass aktualisieren. Während einer laufenden Herstellungsserie keinen Vollscan auslösen.

### Handelbare Händlerrezepte im Auktionshaus

Beim AH-Besuch die bis Skill 300 eingeplanten, noch fehlenden Rezeptgegenstände anhand ihrer Item-ID in die Einkaufsliste aufnehmen. Gilt nur für handelbare Rezeptgegenstände. Bezugspreis ist der bekannte, für diesen Charakter geltende Preis eines zugänglichen Händlers für ein Exemplar. Liegt ein kaufbares Angebot für ein Exemplar bei höchstens 115 % dieses Preises, den AH-Kauf als nächste Kaufaktion vorbereiten. Die 15 % sind als inklusive Obergrenze für den endgültigen Kaufpreis festgelegt. Die allgemeine AH-Preistoleranz aus Shopping.lua darf diesen Deckel nicht nochmals erhöhen.

Vor der Spielerbestätigung das aktuelle Angebot und den tatsächlich zu zahlenden Gesamtbetrag in Kupfer prüfen. Ein bestätigter oder noch in der Post liegender Kauf deckt den Bedarf. Oberhalb der Grenze bleibt der Händler vorgesehen. Ohne belastbaren Händlerpreis die Preise als unklar kennzeichnen und die Wahl offenlassen. Befindet sich der Spieler bereits beim lieferfähigen Händler, ist ein dort günstigerer Direktkauf weiterhin sinnvoll.

## Abnahme

1. Kochkunst 219/225 mit 33 Fischen. 30 Versuche prognostiziert, Serienwahl und erwarteter Materialverbrauch verständlich. Frühes Ziel, ausbleibender Skillpunkt und Abbruch prüfen.
2. Grüner Zauberstab, ein Punkt offen. Holz beim Händler, Essenzen aus dem AH, Teilkauf und Post. Nach einem Fehlversuch mit Vorrat direkt weiterherstellen.
3. Rute mit teils vorhandenen Zutaten, fehlendem Preis und verzögertem Taschenevent. Nach Herstellung genau einmal zum Elternauftrag zurückkehren.
4. Rezeptkauf mit verspätetem Taschenevent, Schließen des Händlerfensters und späterem Lernen. Beim selben Händler zwei geplante Rezepte bestätigen, ein bereits vorhandenes überspringen. Händler abseits der Route und unbekannte Wegdaten gesondert prüfen.
5. Ziel des laufenden Auftrags 75, Vorschau bis 300. Zwei später benötigte Rezepte beim selben Händler sparen gemeinsam einen Rückweg. Beide als Mitnahme anbieten, den Rückweg einmal zählen und den aktuellen Herstellungsauftrag unverändert fortsetzen. Gegenproben: ohnehin geplanter Rückbesuch, teure unsichere Alternativroute, günstigeres entferntes Angebot, ausverkauftes Rezept und bereits bestätigter Kauf.

6. Händlerpreis 1000 Kupfer. AH-Angebote zu 980, 1150 und 1151 Kupfer prüfen: Die ersten beiden vorbereiten, beim dritten den Händler vorsehen. Zusätzlich einen Preissprung nach dem Scan, einen bereits bezahlten Posteingang und einen fehlenden Händlerpreis prüfen.

WoWLua soll jeweils den sichtbaren Guide-Schritt, offene Mengen und die Zahl der Handelswege prüfen. Native Serienunterbrechung, verzögerte Rezeptkäufe und tatsächliche Laufwege brauchen zusätzlich eine Forever-Abnahme.
