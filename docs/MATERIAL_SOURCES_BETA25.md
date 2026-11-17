# beta.25 — Materialwahl und Rangwechsel

## Geprüfte Annahmen

Die frühere Empfehlung zum Kupferbarrenkauf beweist keinen Vergleich mit eigenem Kupfererz: Economy.quote wählte bisher das preisgünstigste Reagenz einer Gruppe, während RouteModel zusätzliche Herstellungsanbieter nur auf anderen Charakteren erfasste. Die eigene berufübergreifende Verhüttung war in diesem Pfad nicht enthalten. RouteCosts bewertet verbrauchten Eigenbestand zudem mit seinem geschätzten Materialwert. Das ist ein Opportunitätswert und keine sofortige Goldausgabe oder garantierter AH-Verkaufserlös.

Eine Friedensblume auf der Bank hat allein durch den Lagerort keinen anderen aktuellen Stückpreis als dieselbe Friedensblume im AH. Historische persönliche Einkaufspreise werden hier nicht zuverlässig gespeichert. Ein behaupteter Unterschied von einem Kupfer kann deshalb für identische eigene Ware nicht nachträglich bestätigt werden. Die neue Auswahl unterstützt sowohl **gleiche Zutat aus eigenem Bestand oder neuer AH-Kauf** als auch **vom nativen Rezept ausgewiesene alternative Zutaten**, einschließlich eines Preisunterschieds von einem Kupfer.

Der neue Screenshot bestätigt Ingenieurskunst75/75 und den alten Guidezustand „Ziel erreicht“. Im Code prüfte RouteRuntime das erreichte Routenziel vor dem Rangbedarf. Auch ein manuelles Teilziel konnte vor rank_full ausgewertet werden. Beides ist korrigiert.

## Implementierung

- Kurzer Vergleich im Guide, wenn ein aktueller AH-Preis unter dem bekannten Händlerpreis liegt. Gleichstand wird nicht als Preisvorteil bezeichnet. Beim Kauf bleiben Mengen-, Preislimit- und native Bestätigungsprüfungen bestehen.
- Materialquellenwahl für eigene Zutaten aus Taschen und gespeicherten Bankdaten, für zulässige native Reagenzalternativen und für bekannte eigene Herstellungswege aus anderen Berufen. Keine Wahl beliebiger, nicht vom Client zugelassener Ersatzstoffe.
- AH-Wahl reserviert den alten Bestand. Nur zusätzlich erhaltene Mengen stehen dem Abschnitt zur Verfügung; ein bloßer Bank→Taschen-Transfer ist kein neuer Erwerb. Bestätigte Käufe/Post bleiben in der bestehenden Belegrechnung; frisch bestätigte Käufe erzeugen keine erneute Eigenbestand-Frage.
- Auswahl pro Rezeptabschnitt beziehungsweise Produktionsauftrag, im Charakter gespeichert; „Materialwahl ändern“ erlaubt die bewusste Rückkehr. Andere Rezepte/Abschnitte erhalten eigene Entscheidungen. Während Kaufbestätigung, nativer Vorbereitung oder Craftserie kein Umschalten. Klicks gegen geänderte Preise/Mengen werden neu angezeigt statt ausgeführt.
- Alternative Eigenreagenzien werden bei Teilbestand nur für die daraus mögliche Serie geplant. Der Guide kauft nicht automatisch teurere zusätzliche Alternativzutaten nach. Native Reagenzienbelegung wird über die reale Professions-Transaktion gesetzt und überprüft; ohne passende native API keine vermeintlich sichere Vorbereitung. Nutzer bleibt für den originalen Herstellknopf zuständig.
- Eigene Zwischenprodukte: nur gelerntes, bestätigtes Rezept, native Zutaten und feste Ausbeute; vorhandener Beruf und Skill, aktuelle Referenzbeobachtung, Bestand und Voraussetzungen prüfen. Andere aktuelle Zutaten des Elternauftrags bleiben reserviert. Erst Beruf öffnen, dann native Serie vorbereiten; nach Produktion ausdrücklich zum ursprünglichen Auftrag zurückkehren. Kein automatischer geschützter Craft-Aufruf.
- Kupfer ist zusätzlich als Entdeckungshinweis hinterlegt: Erzbesitz plus Bergbauberuf erlaubt das Öffnen zur Prüfung, beweist aber weder gelerntes Schmelzen noch Ausbeute. Unbekannte/gesperrte Wege werden nicht vorbereitet. Andere Herstellungswege benötigen bereits native aufgezeichnete Rezeptdaten. Kein vollständiger Herstellungsgraph und keine frei rekursive Verwertung.
- Ranglimit vor Zielabschluss: bei75/75,150/150,225/225 zuerst geeigneten bekannten Rang-Lehrer anzeigen; Charakterstufen-Sperren erhalten. Ein am Ranglimit endender Auftrag setzt nach bestätigter Erhöhung der nativen Skillgrenze sein Ziel auf die neue Grenze. Echte Teilziele unterhalb der Grenze bleiben abgeschlossen. Der Ingenieurs-Gesellenlehrer Franklin Lloyd in Unterstadt ergänzt die vorhandene Referenzliste; Standort76/74 ist Referenz, keine neue Live-Bestätigung.
- Rang kaufen nur bei eindeutiger tatsächlich geöffneter Service-ID, unverändertem Preis/NPC, ausreichendem Gold und Nutzerklick. Bereits gestartete Anfrage sperrt weitere Anfragen. Unbekannte beziehungsweise linklose Rangidentitäten werden nicht aus Namen geraten; in diesen Fällen native Lehrerliste benutzen. Keine automatische Lehrer-Klickserie.

## Technische Nachweise und Grenzen

Native Reagenzien-APIs anhand der installierten Blizzard-UI für Forever1.60.1.70938 geprüft: Blizzard_ProfessionsTransaction.lua (OverwriteAllocation/GetAllocations) und Blizzard_ProfessionsRecipeSchematicForm.lua (native Auswahl/AllocationModified-Ereignis). Keine neuen permanenten Timer oder OnUpdate-Schleifen. Konversionsindex wird nur bei geändertem aufgezeichnetem Berufsdatensatz aufgebaut; laufende Serien behalten die vorhandenen gezielten Updates.

Franklin Lloyd: vorhandene unabhängige Standortreferenz aus TrainerNavigation; Rangmitgliedschaft als Referenz anhand des veröffentlichten NPC-/Rangprofils (https://www.wow-professions.com/npc/classic/franklin-lloyd), kein Beweis einer Forever-Livebeobachtung. Allgemeine Regel zum Rangwechsel auch im offiziellen Classic-Handbuch: https://us.media.blizzard.com/manuals/wow/wow-classic-manual-enUS.pdf. Native Beobachtungen haben Vorrang vor Referenzen.

Neue MaterialSourceSuite enthält23 Regressionen: Ein-Kupfer-Preisvorteil, Bank/Taschen/AH-Wahl, Reservierung/Bankbewegung, Alternativreagenz und Teilbestand, fehlende/veraltete Preise, stale Klicks, ausstehender Kauf, bestätigte Kupferverhüttung, unbekanntes Rezept, variable Ausbeute, native Belegung, vollständige native Verhüttung und Rückkehr, Wiederherstellung der Auswahl, Produktion ab300, Rang/Teilziel/Level/Angebotswechsel/Mehrdeutigkeit. Testergebnisse und finale Quellhashes: TEST_RESULTS.md und automatische ZIP-Berichte.

Bestehende Bank-/Stations-/Werkstatt-Fixtures modellieren ausdrücklich die bereits bestätigte Nutzung ihrer vorgegebenen Zutaten; ihre alten Fachprüfungen bleiben erhalten. Die neue Suite prüft die eigentliche Nutzerwahl separat mit realen Modulen und nativen API-Fixtures. Intermediate Fehlversuche bleiben lokal dokumentiert, sind keine Releasefreigabe. Alle Ansichten sind Camelot-/WoWLua-Quellemulation, keine Live-Client-Bilder oder FPS-Belege.

## Kurzer Live-Test

1. `/cdj version` auf beta.25 prüfen. Aktuelle AH-Preise erfassen; bei einer unter Händlerpreis angebotenen Zutat den kurzen Vergleich im Guide prüfen.
2. Zutaten in Taschen/Bank behalten und „Eigenbestand verwenden“ wählen. Fehlende Bankmengen entnehmen; nicht erneut für denselben Abschnitt fragen. Über „Materialwahl ändern“ AH wählen: der ursprüngliche Bestand bleibt reserviert, ein interner Banktransfer zählt nicht als neuer Kauf. Neu gekaufte Post abholen und korrekt weiterherstellen.
3. Ein natives Rezept mit echten austauschbaren Zutaten öffnen: teurere vorhandene Alternative wählen, native Reagenzienauswahl und begrenzte Teilserie kontrollieren. Falls keine solche Alternative im aktuellen Forever-Rezept existiert, keine künstliche Ersetzung erwarten.
4. Mit bekanntem Bergbau/Kupferschmelzen und eigenem Erz den Verhüttungsweg wählen. Bergbau öffnen, feste native Ausbeute prüfen, vorbereiten und originalen Herstellknopf drücken. Zum Ingenieursauftrag zurückkehren; Barrenbestand verwenden. Gleichen Fall mit AH-Wahl prüfen: Erz bleibt unangetastet.
5. Bei Ingenieurskunst75/75 den lokalen Rang-Lehrer anzeigen lassen, Referenzangebot bei Franklin Lloyd prüfen und nächsten Rang lernen. Erst die native Erhöhung auf150 darf den Auftrag weiterführen. Unzureichende Charakterstufe, fehlendes Gold und unbekanntes Angebot müssen verständlich blockieren.

Tatsächliche Marktpreise des Nutzers und vollständige Live-Abnahme wurden durch die Simulation nicht bestätigt. Gespeicherte Bankdaten können veraltet sein; Bank öffnen aktualisiert sie. Es gibt keinen automatischen Verkauf des zurückbehaltenen Bestands und keinen behaupteten garantierten Handelsgewinn.
