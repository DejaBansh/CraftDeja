# CraftDeja — geltende technische Entscheidungen

Stand: 17.11.2026. Dauerhafte Gründe und Grenzen; aktuelle Ergebnisse stehen in TEST_RESULTS.md.
Die vollständige Entscheidungshistorie bleibt im [Archiv](docs/archive/2026-11-17-handoff/DECISIONS.md).

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
