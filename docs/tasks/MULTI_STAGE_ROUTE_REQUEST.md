# Codex-Auftrag für CraftDeja

Setze die nächste Ausbaustufe meines WoW-Forever-Addons CraftDeja um. Beginne direkt im lokalen Projekt und arbeite bis zu einer integrierten, getesteten Funktion mit installierbarem Release-Build.

## Arbeitsbasis

Der neueste CraftDeja-Stand liegt lokal auf meinem Rechner und wurde noch nicht auf GitHub hochgeladen. Verwende diesen lokalen Stand als Grundlage. Prüfe Git-Status, Branch, Commit und offene Änderungen. Lies AGENTS.md, CONTINUE.md, PROJECT_STATE.md, DECISIONS.md und ROADMAP.md, soweit vorhanden. Leite einen eigenen Feature-Branch vom aktuellen lokalen Stand ab und erhalte die vorhandenen lokalen Änderungen.

## Ziel

CraftDeja soll mehrere Rezeptwechsel bis zu einem gemeinsamen Skillziel planen und die Route mit den geringsten erwarteten Netto-Goldkosten unter den verglichenen Routen empfehlen. Berücksichtige aktuelle Auctionator-Preise, vorhandene Materialien, später benötigte Zwischenprodukte, einmalige Lerngebühren, Berufslehrerbesuche, die Berufe meiner eigenen Twinks und teilnehmende Gildenmitglieder.

Nutze Ingenieurskunst von Skill 1 bis 75 als ersten durchgängigen Referenzfall. Verwende echte Forever-Rezepte aus den vorhandenen Projektdaten und halte die Planung für andere Berufe nutzbar. Plane standardmäßig bis zur Grenze des aktuellen Berufsrangs. Unterstütze ein gewähltes Ziel darüber hinaus, soweit Ränge und Zugang anhand vorhandener Daten planbar sind.

## 1. Rezeptketten über mehrere Skillabschnitte planen

- Vergleiche vollständige Routen mit identischem Startskill, Zielskill, Ausgangsbestand und Preisstand. Nutze die vorhandenen Skillchancen für die erwarteten Craft-Mengen.
- Plane hergestellte Teile als Bestand für spätere Schritte ein. Bei Ingenieurskunst können beispielsweise Kupferbolzen und Raues Sprengpulver früh Skillpunkte bringen und später als Zutaten für Kupferbomben dienen. Ermittle den späteren Bedarf, berücksichtige die Ausgabemenge pro Craft und ziehe vorhandene Teile ab.
- Empfehle das Skillen mit einem Zwischenprodukt nur bei einer erwarteten Netto-Ersparnis für die gesamte Route bis zum selben Ziel. Vergleiche ausdrücklich mit einer Route, die mit anderen Rezepten skillt und die fehlenden Teile zukauft. Bei Gleichstand hat die Route ohne den zusätzlichen Herstellungsschritt Vorrang. Unter ansonsten gleichwertigen Routen darf die mit weniger Lehrerbesuchen gewinnen.
- Verrechne Rohstoffe und Lerngebühren jeweils einmal. Später verbaute Teile ersetzen einen Zukauf. Für dieselben Teile fällt kein Verkaufserlös an. Für verkaufbare Überschüsse gelten die bestehenden Regeln für belegbare Erlöse.
- Zeige getrennt, wie viel Gold der Spieler ab jetzt für Einkäufe, Lerngebühren und gegebenenfalls Versand oder Trinkgeld benötigt und wie hoch die erwarteten wirtschaftlichen Nettokosten inklusive des Werts verbrauchter Vorräte sind. Plane nach tatsächlichen Skillups und Bestandsänderungen mit dem verbleibenden Bedarf weiter.

## 2. Aktuelle Auctionator-Preise und verfügbare Mengen verwenden

- Nutze einen frischen Auctionator-Scan als gemeinsame Preisbasis. Prüfe vor dem Kauf bei preisentscheidenden Materialien und Rezeptgegenständen die aktuellen AH-Angebote. Berücksichtige verfügbare Stückzahlen und Preisstufen bereits in der Rezeptwahl. Ein günstiger Stückpreis gilt nur für die Menge, die zu diesem Preis verfügbar ist.
- Verwende den bestehenden Auctionator- und AH-Kaufablauf. Zeige, wann die Preise erfasst wurden. Wenn relevante Preise fehlen, veraltet sind oder die Angebote die benötigte Menge nicht decken, kennzeichne den Vergleich als vorläufig und biete eine Preisaktualisierung an. Fehlende Preise dürfen keinen Nullpreis erzeugen.
- Bewerte bei Preisänderungen den offenen Teil der Route neu. Berücksichtige vorhandene Materialien, gelernte Rezepte, bestätigte Käufe und ausstehende Post gemäß bestehender Bestandslogik. Lass offene Kaufdialoge und manuell eingegebene Kaufmengen stabil. Zeige nachvollziehbar an, wenn neue Preise einen Routenwechsel sinnvoll machen.

## 3. Berufslehrerbesuche bündeln

- Leite aus der gewählten Route ab, welche Rezepte beim geöffneten Berufslehrer gelernt werden sollen. Zeige auch Rezepte zum Mitlernen an, die erst deutlich später hergestellt werden, sofern der Lehrer sie jetzt anbietet und alle Lernvoraussetzungen erfüllt sind.
- Zeige vor dem Lernen die ausgewählten Rezepte und die Gesamtgebühr an. Biete nach ausdrücklichem Nutzerklick „Geplante Rezepte lernen“ an, sofern der Sammelvorgang im Forever-Client zuverlässig unterstützt wird. Prüfe nach jedem Lernvorgang das aktuelle Angebot erneut und hake nur bestätigte Erfolge ab. Falls der Sammelvorgang nicht zuverlässig unterstützt wird, führe den Spieler mit einzelnen Lernschritten durch dieselbe Liste.
- Plane den nächsten Berufsrang im selben Besuch ein, wenn er für das Skillziel gebraucht wird und bereits lernbar ist. Zeige bei noch gesperrten Rezepten die fehlende Voraussetzung und den nächsten sinnvollen Besuch. Rezeptbücher vom Händler oder aus dem AH erhalten eigene Beschaffungsschritte.

## 4. Berufe und Vorräte meiner Twinks einbeziehen

- Behandle meine eigenen Charaktere als zusätzliche Bezugsquelle für übertragbare Zutaten, Zwischenprodukte und Werkzeuge. Nutze die vorhandene charakterübergreifende Bestandslogik. Ergänze sie um den zuletzt bestätigten Berufsskill, die tatsächlich eingelesenen und gelernten Rezepte sowie den Prüfzeitpunkt je Charakter.
- Vergleiche die vollständigen Herstellungskosten auf dem Twink mit dem aktuellen AH-Kaufpreis für dieselbe benötigte Menge des fertigen Gegenstands. Berücksichtige Ausgabemengen, vorhandene und übertragbare Vorräte, nötige Zukäufe zu aktuellen Auctionator-Preisen und gegebenenfalls Versandkosten. Dieselben Vorräte dürfen innerhalb der Route nur einmal verplant werden.
- Empfehle das Umloggen nur, wenn der Twink den Gegenstand nachweislich herstellen und übergeben kann und dieser Weg voraussichtlich netto günstiger ist als der direkte Kauf. Bei Gleichstand bleibt der direkte Kauf die Empfehlung, sofern er verfügbar ist. Bei unklarem Rezeptstatus, veraltetem Bestand, fehlendem Preis oder ungeklärter Übertragbarkeit bleibt der Vergleich vorläufig. Wenn die Rohstoffe vorhanden sind, kann der zusätzliche Einkaufsbetrag null sein. Ihr Wert bleibt im Nettovergleich erhalten.
- Speichere den laufenden Auftrag charakterübergreifend. Führe über den bestehenden Guide durch den Ablauf: auf den passenden Twink wechseln, Rezept und Bestand bestätigen, fehlende Rohstoffe besorgen, herstellen, übertragen und auf dem Hauptcharakter mit demselben Auftrag fortfahren. Prüfe nach dem Wechsel die relevanten Daten erneut und aktualisiere die Empfehlung, wenn sich Preise, Bestand oder Herstellbarkeit geändert haben.
- Nutze als Referenzfall Verzauberkunst auf dem Hauptcharakter und Schmiedekunst auf einem Twink. Vergleiche den Kauf der fertigen Metallrute im AH mit der Herstellung auf dem Schmiede-Twink. Sobald die Metallrute auf dem Verzauberer angekommen ist, soll der bestehende Schritt zur Runenrute weiterlaufen.

## 5. Gildenmitglieder für ausgewählte wichtige Crafts einbeziehen

- Beschränke die Gildenfunktion auf eine explizite Liste wichtiger Werkzeuge und Engpässe, die für den aktuellen Auftrag tatsächlich benötigt werden. Starte mit übertragbaren Metallruten für die Runenruten-Kette und Salzstreuer (Salt Shaker). Verwende die bestätigten Forever-Item- und Rezept-IDs und sichere die Zuordnung mit Tests ab. Ein fehlender AH-Preis, eine hohe Ersparnis oder die Verwendung als Zwischenprodukt macht einen Gegenstand allein nicht für die Gildenfunktion geeignet.
- Schließe Massenmaterialien für den Gildenweg aus, etwa Barren, Erze, Bolzen, Sprengpulver und Stoffe. Diese Sperre gilt sowohl direkt als auch für alle Teilrezepte eines freigegebenen Crafts. Konkreter Fall: Wenn mein Twink Bergbau hat, darf CraftDeja weder den Kauf von Kupfererz mit anschließendem Einschmelzen durch ein Gildenmitglied vorschlagen noch Kupferbarren als Gildenauftrag anlegen. Fehlende Standardmaterialien beschafft der Spieler über den bestehenden AH- und Bestandsablauf. Die eigene Twink-Planung bleibt davon getrennt.
- Gildenmitglieder, die mitmachen wollen, installieren CraftDeja und aktivieren „Rezepte mit der Gilde teilen“. Tausche gelernte Rezepte und Berufsskills per Addon-Nachrichten innerhalb der aktuellen Gilde aus. Zeige passende Hersteller, Online-Status und Zeitpunkt der letzten Bestätigung. Taschen-, Bank- und Goldbestände bleiben privat.
- Vergleiche den Gilden-Craft mit dem AH-Kauf und der Herstellung auf eigenen Twinks für dieselbe benötigte Menge. Rechne mit aktuellen Auctionator-Angeboten, dem Wert eigener verwendeter Vorräte und den bestätigten Konditionen des Herstellers. Bei „eigene Materialien plus Trinkgeld“ rechne Materialien und vereinbartes Trinkgeld ein. Bei einem Festpreis für fertige Ware inklusive Material rechne den Festpreis ein. Berücksichtige gegebenenfalls Übergabe- oder Versandkosten.
- Empfehle den Gildenweg nur bei niedrigeren erwarteten Nettokosten als die günstigste verfügbare Alternative. Ohne bestätigte Konditionen oder Zusage zeige ihn als anfragbare Option. Kennzeichne Offline-Hersteller und ältere Daten mit dem jeweiligen Status.
- Zeige bei jedem vorgeschlagenen Gildenschritt direkt die zweite Aktion „Gilden-Craft überspringen und im AH kaufen“, auch nach einer Anfrage oder Zusage. Die Auswahl übernimmt den fertigen Gegenstand in den bestehenden AH-Einkaufsablauf und schließt den Gildenweg für diesen Gegenstand im laufenden Auftrag aus. Merke dir die Auswahl auch nach Preisupdates, Neuberechnungen, Charakterwechsel oder Reload. Der Spieler kann die Auswahl bewusst zurücksetzen. Rechne bereits übergebene Materialien und bestätigte Käufe anhand des tatsächlichen Bestands ein. Fehlt ein aktuelles AH-Angebot, zeige „AH-Angebot prüfen“ und halte den gewählten AH-Weg fest.
- Öffne auf Klick einen vorbereiteten Whisper mit Gegenstand und Menge, den der Spieler selbst abschickt. Führe nach bestätigter Zusage durch Materialbeschaffung, Übergabe und Erhalt. Prüfe die Übertragbarkeit. Setze nach bestätigtem Erhalt denselben Levelauftrag fort und entferne den Gegenstand aus der Einkaufsliste.

## Bedienung und Abnahme

- Behalte den grünen Knopf für genau die nächste Aktion sowie Deutsch und Englisch bei. Zeige Route, Kostenvergleich, Lehrerbesuche und gegebenenfalls Twink- oder Gildenauftrag in aufklappbaren Details. Bestehende Gift-, Produktions-, Einkaufs- und Runenrutenabläufe müssen weiter funktionieren.
- Prüfe mindestens diese Fälle:
  1. Eine Zwischenprodukt-Route spart bis zum selben Zielskill netto Gold und wird gewählt. Bei gleichen oder höheren Nettokosten gewinnt die Alternative.
  2. Die Preisstufen für die tatsächlich benötigte AH-Menge kehren eine Empfehlung um. Fehlende Preise und zu geringe Angebotsmengen werden korrekt behandelt.
  3. Vorhandene Teile, bestätigte Käufe und ausstehende Post werden einmal verrechnet. Schnellere oder langsamere Skillups führen zu einer korrekten Restplanung.
  4. Ein erst später benötigtes Rezept wird beim Lehrer schon zum Mitlernen angeboten. Gesperrte und für die Route unnötige Rezepte bleiben aus dem Kauf. Lerngebühren werden einmal verrechnet.
  5. Der Schmiede-Twink spart bei der Metallrute netto Gold und CraftDeja empfiehlt den Wechsel. Ist das AH gleich teuer oder günstiger, empfiehlt CraftDeja den Kauf.
  6. Vorhandene Twink-Rohstoffe senken den zusätzlichen Einkaufsbetrag, während ihr Wert im Nettovergleich erhalten bleibt. Bei unbestätigten Rezept-, Bestands- oder Transferdaten wird keine gesicherte Ersparnis ausgewiesen.
  7. Ein Gildenschmied ist bei einer freigegebenen Metallrute nach Zusage und bestätigten Kosten günstiger als AH und Twink und wird empfohlen. Prüfe auch teurere oder gleich teure Angebote, fehlende Konditionen, ältere Offline-Daten, deaktivierte Freigabe und einen Gildenwechsel.
  8. Metallruten und Salzstreuer kommen als Gilden-Crafts infrage. Kupferbarren bleiben selbst dann ausgeschlossen, wenn der Bergbau-Twink und billiges Kupfererz eine Ersparnis nahelegen. Ein freigegebenes Werkzeug darf keinen Gilden-Unterauftrag für Barren oder andere Massenmaterialien erzeugen.
  9. Der Spieler lehnt den Gilden-Craft ab und kauft den fertigen Gegenstand über den normalen AH-Ablauf. Der Gilden-Craft taucht für diesen Gegenstand nach Preisänderung, Reload oder Charakterwechsel im selben Auftrag erst nach bewusstem Zurücksetzen wieder auf.
  10. Nach Herstellung und Übergabe per Twink oder Gildenmitglied oder nach einem bestätigten AH-Kauf setzt der Hauptcharakter denselben Auftrag fort. Die Metallrute verschwindet aus der Einkaufsliste und die Planung der Runenrute läuft weiter.
- Führe die gezielten Tests und die bestehenden Regressionstests nach den Projektregeln aus. Erstelle einen installierbaren Release-Build. Wenn du den Live-Client nicht prüfen kannst, liefere einen kurzen Ingame-Testablauf mit den konkret offenen Prüfungen.
- Dokumentiere zum Abschluss Branch, Commit, Build und Testergebnisse. Zeige einen nachvollziehbaren Routenvergleich für Ingenieurskunst und einen Kostenvergleich für die Metallrute über AH, Twink und Gilde. Gib jeweils den noch nötigen Einkaufsbetrag und die erwartete Netto-Ersparnis gegenüber der günstigsten verfügbaren Alternative an.

Kein Merge nach main und keine Veröffentlichung.
