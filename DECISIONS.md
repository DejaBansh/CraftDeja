# CraftDeja — geltende technische Entscheidungen

Stand: 17.11.2026. Dauerhafte Gründe und Grenzen; aktuelle Ergebnisse stehen in TEST_RESULTS.md.
Die vollständige Entscheidungshistorie bleibt im [Archiv](docs/archive/2026-11-17-handoff/DECISIONS.md).

- **Kompakter Guide und Optionen.** Beide Ansichten verwenden dieselbe Kopfzeile, Materialpalette und Texttasten. Das Werkstattpult wird als beschrifteter Eintrag im Zahnradmenü angeboten. Die reguläre Itemgrafik bleibt beim Rezept sichtbar.

- **Meisterpult im Addon (23.11.2026).** Die freigegebene Vorschau verwendet dunkles Walnussbraun für Fensterflächen (`#34271F`), Sattellederbraun für die Haupttaste (`#65412B`), mattes Messing für Kanten (`#C3A672`) und Creme für Text (`#F2EBDD`). Griffmulde und Präzisionsschieber ergänzen die Haupttaste. [Designreferenz](docs/assets/mockups/meisterpult/index.html)

- **Nachvollziehbare Kosten:** Kosten pro erwartetem Skillpunkt, Materialverbrauch und zusätzlicher
  Goldbedarf getrennt. Eigener Bestand ist wirtschaftlich nicht kostenlos. Händler-Mindestwert nur
  mit bestätigter Ausbeute; negative Netto-Schätzungen sind kein Gewinnversprechen. Unbekannt bleibt
  unbekannt, Lerngebühren einmalig. Kein uneingeschränktes globales Routenoptimum behaupten.
- **Stabile Aufträge:** Snapshot-basierter begrenzter Routenvergleich; vollständiger Vergleich am
  Rezept-/Rangwechsel oder ausdrücklich, keine Wiederholung nach jedem Bag-/Preisereignis.
  Intermediates reservieren, keinen Verkauf später verbauter Zutaten anrechnen.
- **Leichte Aktualisierung:** Native Craftserie erhält gezielte Fortschrittsupdates. Preisbursts
  zusammenführen, Metadateninteresse indizieren, unmögliche Kandidaten früh ausschließen.
  Keine schweren Vollscans oder neuen permanenten Diagnose-/Marktscan-Schleifen.
- **Explizite Materialwahl:** Eigenbestand/AH, native Alternativzutaten und bestätigte eigene
  Konversionen je Abschnitt/Produktionsauftrag. AH-Wahl reserviert alten lokalen Bestand.
  Keine erfundene Austauschbarkeit, variable Ausbeute oder unbewiesene Konversionskette.
- **Native Bestätigung:** Geschützte Herstellung über Originalbutton; Käufe pro bestätigter
  Aktion frisch prüfen, keine Doppelanfrage nach Timeout. Manuelle AH-Mengen bleiben erhalten;
  Auctionator nur über öffentliche APIs, eigene unveränderte Listeneinträge synchronisieren.
- **Berufs-/Rangidentität:** Ranglimit vor Zielabschluss, Fortsetzung erst nach nativ erhöhter Grenze.
  Aktiver Auftrag vor Giftangeboten; Gifte nur Schurke plus native Freischaltung.
  Keine Rezept-/Rangzuordnung aus Namensähnlichkeit. Mot-Fallback nur belegte Kombination
  11071/7771/6345 plus exakte Clientidentität ohne Mehrdeutigkeit, Gebühr live beobachten.
- **Quellen und Orte:** Rezeptlehrer brauchen Rezeptbeleg; Nähe/Rang allein reicht nicht.
  Nächsten bekannten geeigneten Punkt aus vergleichbaren Daten wählen, keine kürzeste Reisezeit
  versprechen. Stationen nur passend zur nativen Anforderung/Karte/Ebene/Instanz; fehlende Daten
  sichtbar. Referenzdaten, tatsächliche Besuche und Herkunft/Lizenzen unterscheiden.
- **Konten/Gilde/Bank:** Aufträge realm-/fraktionsgebunden; eigene Twinks mit Rezept-/Skillbeleg.
  Gilde opt-in, begrenzte kanonische Zwischenprodukte, bestätigte Konditionen/Zusage, keine Bestands-
  oder Golddaten im Protokoll. Persönliche Banktransfers explizit, Mengen beidseitig bestätigen;
  Account-/Gildenbank nicht stillschweigend einschließen. Anzeigeunterdrückung ändert keinen Auftrag.
- **Ansichten:** Hauptfenster/kompakter Guide projizieren denselben Auftrag. DE/EN, konkrete CTA,
  optionale Details, proportionale Assets. Einmaliger sichtbarer Bereitschaftsimpuls; kein Dauerblinken.
- **Zielbestände:** Ein Ziel je fertigem Gegenstand und Charakter. Fehlmenge zählt bestätigte
  Taschenstücke. Händlerstapel und feste native Rezeptmengen runden die nächste Aktion.
  Alte Giftziele erst nach bestätigter Ausgabe zuordnen. Einmalige Zusatzproduktion bleibt getrennt.
  Die Liste speichert clientbestätigte Rezepte pro Charakter. Berufszauber sind Hinweise
  und werden über Lernstatus, Berufszuordnung und Ausgabe geprüft. Vollständigkeit und
  tatsächliche Herstellbarkeit folgen aus dem geöffneten Berufsfenster.
- **Release:** Spielerpakete release-only ohne Dev-Runtime/automatische Instrumentierung.
  Exakte Tags und versionierte DE/EN-Texte nach passendem tatsächlich veröffentlichtem Vorgänger.
  Offizielle Upload API, keine blinden POST-Retries. Hauptbeschreibung manuell über Author Console.
- **Datenpflege:** Wöchentlicher externer Händlerrezept-Diff benötigt Herkunfts-/Lizenzprüfung.
  Siebentägige lokale Lernkostengültigkeit ist kein globaler Händlerabgleich.
- **Übergabe:** Kurzer aktueller Einstieg, eindeutige Dokumentzuständigkeiten, strukturierte Belege.
  Historie archivieren statt aktuelle Zustände mehrfach kopieren. Code/Git/Hashes vor Notizen prüfen.

## 23.11.2026 · Materialreserve und Rezeptbeschaffung

Skillchancen bestimmen den erwarteten Einkauf. Zusätzliche Reserve und eine längere native Serie brauchen jeweils eine Spielerentscheidung. Bei Rezepten ist der AH-Aufpreis auf 15 % gegenüber einem belegten Händlerpreis begrenzt. Ein ohnehin anstehender Besuch beim selben Anbieter lässt den Aufpreis entfallen. Die Vorschau bis 300 führt einen eigenen Vergleich und ändert das laufende Auftragsziel nicht.

## 21.11.2026 · Gestaltung der CurseForge-Projektseite

Der Nutzer hat Option D gewählt. Für künftige Releases gilt der schnelle Einstieg mit drei Spielervorteilen und echtem Guide-Ausschnitt im Goblin-Werkstattstil. Das Titelbild trägt die genietete Messingeinfassung direkt im Bild. Dunkles Rauchglas, warme Messingkanten und dezentes grünes Licht ziehen sich durch die Seite. Die Texte bleiben auch ohne Bilder lesbar. [Designreferenz D](docs/assets/marketing/2026-11-21-curseforge/D/desktop.html)

## 26.11.2026 · Synchroner Bankscan durch dirty-Debounce ersetzt und geschlossen geprüft

Bei geöffneter Bank führt `BAG_UPDATE_DELAYED` und jedes andere Zustandsänderungsereignis nur noch `state.dirty = true`; kein Ereignis setzt das Debounce-Intervall zurück. Der eigentliche Scan läuft über den bestehenden 0,3-Sekunden-Debounce in `inventoryTick`. `BANKFRAME_CLOSED` und `PLAYER_LOGOUT` sind unmittelbare synchron geschaltete Pfade (`captureInventory` direkt), damit Bankbestände beim Schließen nicht veraltet oder verloren gehen; `BANKFRAME_OPENED` geht dagegen über das Debounce wie die übrigen Ereignisse. Der Debounce-Scan konsumiert die ausstehende Anfrage zu Beginn (`dirty = false`, `elapsed = 0`); ein während des Scans neu ausgelöster dirty bleibt erhalten, statt am Ende des Captures überschrieben zu werden. Keine Einschränkung von `state.tracked` und keine Veränderung anderer Performance-Bereiche. Regressionstests (InventoryDebounceSuite) decken Burst, Bank schließen mit und ohne API-Verfügbarkeit, Logout, Missed-Capture, Craft-Busy-Defer, voller Dispatch-Pfad, Bank-open-Pfad sowie Mixed-Event-Cadence und den Re-Dirty-Fall ab.
