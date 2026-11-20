# Ingame-Abnahme für „Nächster Schritt“ und Zielbestände

Entwicklungsstand vom 20.11.2026 auf Basis von beta.25. Für die Abnahme in WoW Forever
1.60.1 das lokale Paket mit Release-Profil aus [TEST_RESULTS.md](../TEST_RESULTS.md)
verwenden. Die automatisierte Prüfung verwendet WoWLua/Camelot mit nachgestellten
Ereignissen von AH, Post, Händler und Beruf.

| Reproduktion | Ursache und Änderung | Nachweis |
|---|---|---|
| Guide schließen, AH öffnen | Der erzwungene Refresh löschte den Schließzustand. Ein separater Sichtbarkeitswunsch erlaubt das Öffnen beim nativen Berufsbesuch oder per Klick. Zustand und Mengen aktualisieren unabhängig davon. | Fehler auf Ausgangscode reproduziert. Sichtbarkeit mit und ohne Auftrag samt erneuter Berufsöffnung in UndercityFlowSuite. |
| Produktionsmenge erreicht | `production_done` fiel in die Rezeptwahl. Der Guide zeigt jetzt „Fertig“. Die Auftragsübersicht übernimmt den tatsächlichen Abschlusszustand des Plans. | Fehler auf Ausgangscode reproduziert. Native Skillstrecke erreicht 70 erst nach fünf bestätigten Vorgängen. Auffülltests prüfen tatsächlichen Zielbestand und Fertig-Zustand. |
| Händlerbestätigung verspätet, Fenster geschlossen. Nach Teilserie abbrechen. | Kaufbestätigung muss den Taschenbestand aktualisieren, auch wenn der Händler inzwischen geschlossen ist. Der Guide zeigt die laufende Bestätigung. Der native Serienabschluss stößt eine gezielte Fortschrittsaktualisierung an und behält das gespeicherte Ziel. | VendorSuite, BankFlowSuite und UndercityFlowSuite prüfen späte Bestätigung, Schutz vor Doppelkauf und Restmenge nach Unterbrechung. |
| Ziel 20, Taschenbestand 12 | Die Zielrechnung saß im Gifteplaner. Gemeinsame Berechnung liefert acht offene Einheiten. Der bestätigte Kauf- bzw. Herstellungsweg rundet nach Angebotsstapel oder fester Ausbeute. | StockRefillSuite prüft 12/20/25, unterschiedliche Ziele, Fünferstapel, Mehrfachausbeute, verspätete Daten, Wartezustand für Giftbestand, Gold, Platz und erneuten Besuch. |

## Durchgehende Abnahme in Unterstadt

Voraussetzungen: Ingenieurskunst 65/75, Kupferrohr gelernt, Schmiedehammer vorhanden,
ein zugänglicher Amboss und ein niedrigeres Teilziel als 75. Für den Vergleich sollte der
aktive Plan Kupferrohr wählen und der Fluxus beim Händler günstiger sein als im AH.
Im Test sind zehn Kupferbarren und fünf Stück Schwacher Fluxus nötig. Live kann eine
abweichende Rezeptwahl oder Skillchance die Mengen ändern. Preise und Angebote im Client
vor der Kaufbestätigung prüfen.

| Station | Klickfolge | Erwartung |
|---|---|---|
| Start und Sichtbarkeit | Nach dem Einloggen zuerst AH oder Post öffnen. Danach Ingenieurskunst öffnen, „Guide schließen“ drücken und das AH nochmals öffnen. Zurück zu Ingenieurskunst. | AH und Post blenden den Guide nicht ein. Beim tatsächlichen Öffnen des Berufs erscheint er. Der Button zeigt jeweils „Guide öffnen“ bzw. „Guide schließen“. Nach dem Schließen bleiben Inventarupdates oder die Rückkehr zum AH wirkungslos. Beim nächsten Besuch im Berufsfenster ist der Guide wieder da. |
| Plan | In Ingenieurskunst `/cdj dashboard` öffnen. Ziel 70 eintragen, „Route planen“ drücken und Kupferrohr als ersten Abschnitt prüfen. Falls eine Materialwahl erscheint, für diese Variante AH für Barren wählen. Guide sichtbar lassen. | Bei fünf garantierten Skillpunkten sind fünf Kupferrohre geplant. Das sind zehn Barren und fünf Fluxus vor Abzug vorhandener Zutaten. Der laufende Plan behält Ziel 70 bei. |
| AH | AH öffnen, Preise erfassen und über den Guide suchen. Erst vier Barren kaufen, dann sechs. Vor jedem Kauf Auctionators endgültiges Angebot bestätigen. | Vier bestätigte Einheiten werden nicht erneut vorgeschlagen. Sechs fehlen. Nach bestätigten zehn Einheiten erscheint die Postaufgabe. |
| Post | AH schließen, Briefkasten öffnen und Anhänge abholen. Bei mehreren Sendungen zuerst nur eine öffnen. | Solange die Barren noch nicht im Taschenbestand sind, bleibt der Guide bei der Post. Nach vier verbuchten Barren sind sechs offen. Nach der letzten Lieferung folgt Fluxus. |
| Händler | Bei Daniel Bartlett (4561) das Händlerfenster öffnen. Den benannten Kauf von fünf Fluxus bestätigen. | Beim offenen Händler steht Artikelname, Menge und Preis. Bis zur Taschenbestätigung bleibt der Kauf gesperrt. Danach führt der Guide zum Amboss oder direkt zum Beruf, wenn der Amboss bereits in Reichweite ist. |
| Beruf und Herstellung | Eventuell „Beruf öffnen“, danach „Herstellung vorbereiten“. Am Amboss den originalen Herstellknopf drücken. Nach zwei bestätigten Skillpunkten die Serie nativ abbrechen. | Der Plan bleibt bei Ziel 70. Nach Abbruch und bestätigtem Bestand fehlen noch drei Herstellungen. Erneut vorbereiten und den originalen Herstellknopf drücken. Erst beim tatsächlich erreichten Skill 70 steht „Fertig“. |
| Bankvariante | Mit einem neuen entsprechenden Plan vier Barren auf der persönlichen Bank anrechnen lassen. Bei der Materialwahl Eigenbestand wählen. Bank öffnen und die angezeigte Menge entnehmen. | Die vier Bankbarren zählen nicht als neu gekaufte Post und werden nicht nochmals im AH verlangt. Der Guide fordert die Entnahme an, bis sie in den Taschen bestätigt ist. Ein geschlossenes Guidefenster bleibt beim Bankbesuch geschlossen. |

Beim Schritt „Post abholen“ müssen die Anhänge im Briefkasten selbst genommen werden.
Bei der Rückkehr zum Beruf öffnet der erste Klick das Berufsfenster. Der nächste bereitet
die dort erneut geprüfte Menge vor. Der letzte Klick ist der originale WoW-Herstellknopf.

## Zielbestände

1. Einen laufenden Berufsauftrag abschließen. Im Hauptfenster die Zielbestandsübersicht auf
   „Route“ oder den Reiter „Zielbestände“ öffnen. `/cdj stock` springt direkt zum Reiter.
   „Zielbestand auffüllen“ aktivieren. Ein Ziel gilt für fertige Gegenstände in den Taschen.
   Zutaten berücksichtigen weiterhin die vorhandene Materialwahl und Lagerorte.
2. **Kaufbare Ware:** Mit zwölf Einheiten Erfrischendem Quellwasser in den Taschen
   „Gegenstand hinzufügen“ öffnen und nach „Quellwasser“ suchen. Alternativ bei offenem
   Händler „Händlerware auswählen“ verwenden. Zeile anklicken, rechts Ziel 20 eingeben
   und mit Enter oder „Ziel speichern“ bestätigen.
   Rechts stehen Taschen 12, Ziel 20 und Fehlen 8. Den Guide schließen und den Händler erneut
   öffnen. Der Guide bleibt geschlossen. „Guide-Schritt öffnen“ zeigt den Kauf mit aktuellem
   Preis und der tatsächlichen Stapelgröße. Bei Fünferstapeln werden zehn Stück angeboten.
   Zweimaliges Ansprechen während der Bestätigung darf keinen zweiten Kauf auslösen.
3. **Herstellung:** Kochkunst und Alchemie nacheinander öffnen, falls der Reiter dazu
   auffordert. Zielbestände mit leerem Suchfeld erneut öffnen. Gelernte Verbrauchsgüter aus
   beiden Berufen erscheinen mit Symbol, auch wenn Zutaten fehlen. Einen Trank oder ein
   Essen wählen, rechts bei mehreren Bezugswegen das gewünschte Rezept auswählen und Ziel 20 speichern.
   Bei zwölf Stück in den Taschen fehlen acht. Mit „Auffüllauftrag vorbereiten“ oder am
   passenden Reagenzienhändler fortfahren. Die Herstellungen werden auf die feste Ausbeute
   gerundet. Nach Bestätigung der Zutaten und dem originalen Herstellklick zeigt der Guide
   erst nach bestätigt ausreichendem Taschenbestand „Fertig“.
4. **Gifte:** Als Schurke mit nativ freigeschalteten Giften den Beruf einmal öffnen.
   Vorhandene Giftziele sollen im Reiter erscheinen. Mit zwölf Stück und Ziel 20 fehlen acht.
   Den passenden Gifthändler öffnen, damit der sichtbare Guide die nötige Aktion anbietet.
   „Zusätzlich herstellen“ öffnet den separaten Gifte-Planer. Dort eingetragene 20 sind ein
   einmaliger Auftrag über 20 zusätzliche Stück. Ziel 20 im Reiter bleibt gespeichert.
5. **Darstellung und Wiederaufnahme:** Bei 1920 × 1080 und 3440 × 1440 mit UI-Skala
   65 % und 100 % lange Namen, eine Liste mit mindestens zehn Zielen und den Fehlbestandsfilter
   prüfen. Zielmenge ändern, scrollen, Fenster erneut öffnen und `/reload` ausführen.
   Mengen bleiben erhalten. Ziel 0 entfernt den Eintrag. Bankbestand wird beim fertigen
   Gegenstand nicht abgezogen.
6. **Auftragsbearbeitung und Optionen:** Im Guide bei „Materialquelle wählen“ auf
   das Zahnrad klicken. Unter „Zielbestände“ stehen die Versionszeile und „Zurück zum
   Guide“. Nach der Rückkehr ist „Eigenbestand verwenden“ beim selben Schritt wieder
   anklickbar. Der Detailknopf nutzt die gesamte Breite. Auftragsbearbeitung über
   das Werkstattpult unter „Auftrag & Angebote“ öffnen.

Die Namenssuche nutzt bekannte Clientnamen aus Taschen, gelernten Rezepten, Händlern und
verfügbaren Referenzen. Ein Gegenstandslink lässt sich ebenfalls einfügen.
Unterstützung ergibt sich aus der Gegenstandsklasse des Clients. Bei Herstellung werden ein
gelerntes Rezept, bestätigte Zutaten und eine feste Ausbeute verlangt. Beim Händler werden
aktuelle unbegrenzte Goldangebote und deren feste Stapel verwendet. Das Projekt führt u.a.
Quellwasser (159) und leere Phiolen (3371) in den Händlerreferenzen. Die Kaufdaten im Spiel
haben Vorrang. Ein aktiver Routen-, Produktions- oder Giftauftrag behält Vorrang.

Wenn ein Schritt sporadisch hängenbleibt, `/cdj log` öffnen, Aufzeichnung einschalten und den
Log unmittelbar vor der Abnahme leeren. Nur den betroffenen Übergang nachstellen und danach
`/cdj log` erneut öffnen. Version, Schritt davor/danach, tatsächliche Taschenmenge und den
kopierten Log senden. Besonders relevant sind `event.*`, `task.plan`, `material`,
`craft.interrupted`, `craft.completed` und `stock.plan`.
