# Beta.20 — feste Routenabschnitte und Bankvorrat

## Belegter Auslöser

Nutzerlog aus beta.19, Client 1.60.1/70938, deDE: Beim gleichen Rezept 3919 und Skill 49 wechseln #1565/#1570/#1576 zwischen `route_pending` und normalem Craft-Schritt. Der Klick auf Herstellung vorbereiten (#1580–1584) erzeugt eine korrekte native Menge 11, schaltet den Guide aber erneut auf `route_pending`. Nach Mailboxkontakt (#1952) treten wieder Pending-Schritte auf; Öffnen des Berufes (#1978–1988) wird später von einem normalen Craft-Schritt gefolgt. Das Log belegt die Wartezustände und den Ablauf, keine individuelle Laufzeit jedes Suchjobs.

Ursache im Code: `RouteRuntime.invalidateRoute` erhöhte bei **jedem** Grund die Revision, setzte `routeDirty` und entfernte `routeSearch`. Der Refresh-Wrapper rief das sowohl bei leichten Aktualisierungen als auch nach Rezeptlesen auf, der Inventar-Wrapper zusätzlich bei Taschenaktualisierungen. Auch `craftNext` führt vor der Sicherheitsprüfung `refresh(true)` aus. Viele gültige Einzelereignisse führten damit zu vollständigen neuen Vergleichen; Ereignisse während einer laufenden Coroutine konnten deren Arbeit immer wieder verwerfen. Zusätzlich überlagerte `route_pending` die bereits vorbereitete native Herstellung.

Die bisherige globale `decide(marketView(...))`-Auswahl lief außerdem bei Refreshs weiter, obwohl die explizit gewählte Route innerhalb desselben Abschnitts bereits feststand.

## Änderung

- Gewählte Rezeptabschnitte bleiben fest. Innerhalb des Abschnitts wird die bestehende Routenentscheidung mit echtem aktuellem Rezeptobjekt, Skill, Lernstatus und Preisquote aktualisiert. Keine neue globale Rezeptwahl/Routensuche für normale Refresh-, Inventar- oder Preisereignisse.
- Eine laufende Suche wird von solchen Beobachtungen nicht verworfen. Sie endet und aktualisiert den Guide selbst. Ihre Kosten werden bei zwischenzeitlich geänderten Daten als veraltet/vorläufig markiert; keine aktuelle Ersparnis aus altem Snapshot ausweisen.
- Neue vollständige Vergleiche an festen Punkten: Abschnittsgrenze oder geänderter Rang, ungültiges Rezept, neuer Auftrag/ausdrückliches Neuplanen sowie tatsächliche Änderungen an Herstellerkonditionen, Gildenverfügbarkeit oder AH-Abwahl. Kein pauschaler Zeitticker und keine verzögerte Kaufvalidierung.
- Native Herstellungsbereitschaft bleibt sichtbar; während nativer Vorbereitung, Serie oder ungeklärtem Kauf startet keine neue schwere Suche. Normale Material-, Kaufmengen-, Preis-, Post- und Herstellungsprüfungen bleiben erhalten.
- `route.started` und `route.completed` dokumentieren tatsächliche vollständige Vergleiche im vorhandenen freiwillig kopierbaren Diagnoseprotokoll. Keine ständig aktive Compiler-Performanceinstrumentierung.

## Bankhinweis

Spätere Abschnitte liefern den reservierten Materialbedarf. Für jeden Gegenstand gilt:

`Einlagern = min(späterer Bedarf − bereits in der Bank, Taschenbestand − Bedarf des aktuellen Abschnitts)`, jeweils mindestens null und auf ganze Stücke abgerundet.

Nur echte Taschenmengen werden empfohlen. Bereits eingelagerter Bestand wird einmal abgezogen; Material für den aktuellen Abschnitt bleibt im Beutel. Keine Empfehlung bei laufender Herstellung, ungeklärtem Kauf, laufender Suche oder auf einem anderen Charakter. Werkzeuge-/Lieferantenaufgaben haben Vorrang. Die Zukunftsbedarfe werden pro gewähltem Suchergebnis zwischengespeichert.

Der Guide nennt Gegenstand und Menge; die Details zeigen die Liste. „Jetzt weiterherstellen“ verschiebt den Hinweis bis zur nächsten Abschnittsgrenze. CraftDeja bewegt keine Gegenstände automatisch und behauptet keinen Bankzugang ohne tatsächliche Bestandsbeobachtung. Wenn ein späteres Rezept das Bankmaterial benötigt, greift die bestehende Abhol-/Materiallogik.

## Reproduzierbare Prüfung

`tests/RouteCoreSuite/checkpoints.test.wowlua`:

- 300 identische Zustands-/Inventar-/Preismeldungen: vorhandene Route bleibt bestehen, kein neuer vollständiger Suchauftrag.
- 300 Meldungen während einer Suche: derselbe Suchauftrag bleibt erhalten.
- Echte Coroutine unter wiederholten Inventar-/Fortschrittsmeldungen: genau ein Modellaufbau, Abschluss und Guide-Aktualisierung ohne erneutes Öffnen.
- Rezeptgrenze, Rangwechsel und ausdrückliches Neuplanen lösen weiterhin einen vollständigen Vergleich aus.
- Native Vorbereitung, aktuelle Rezept-/Skill-/Lernbelege sowie Bankmengen mit aktuellem und bereits gespeichertem Bedarf.

Unveränderte beta.19 aus Commit a0a6437339345a1dcf5c58c6caec0d8e2d2d9bac wurde separat unter reports/route-checkpoints-ab/beta19 ausgecheckt, ohne den Projektarbeitsbaum zu verändern. Dieselben ersten beiden Prüfungen schlagen dort reproduzierbar fehl: 0/2/0, 5.32s, ZIP reports/route-checkpoints-ab/beta19/reports/tests/20261116-164051-9e6d65.zip. Auf korrigiertem Code acht gezielte Prüfungen bestanden: 8/0/0, 8.85s, reports/tests/20261116-164157-952e4e.zip. Die Laufzeiten betreffen unterschiedliche Prüfumfänge und sind **kein** Vorher-/Nachher-Geschwindigkeitsvergleich oder FPS-Beleg. Der abschließende breite Lauf steht in TEST_RESULTS.md.

## Früher Ladefall

Ein breiter Zwischenlauf wurde trotz 570 bestandener Einzeltests ausdrücklich nicht freigegeben: Ein früher `PLAYER_ENTERING_WORLD`-Aufruf erreichte die Routeninvalidierung, bevor das Routenmodell bereit war. Der Einstieg prüft nun die Verfügbarkeit; ein zusätzlicher Bootstrap-Test und die gezielte bestehende CraftPerformance-Prüfung bestehen (10/0/0, reports/tests/20261116-164649-c1178b.zip). Der endgültige Gesamtnachweis folgt in TEST_RESULTS.md.

## Kurzer Live-Retest

1. Bei gleicher Addonkonfiguration Route wählen, aktuelle Abschnittsgrenze notieren. Mehrfach „Herstellung vorbereiten“ und wenige echte Crafts: kein Pending-Wechsel ohne Grenzüberschreitung, native Mengen korrekt.
2. AH-Angebote öffnen, manuelle Kaufmenge verkleinern, kaufen und Post abholen. Mengen/Bestand müssen aktuell werden; kein zusätzlicher Vollvergleich pro Angebot oder Taschenmeldung und kein erneutes Öffnen von CraftDeja nötig.
3. Am Abschnittswechsel genau einen neuen vollständigen Vergleich beobachten. Preis-/Mengenvalidierung muss weiterhin vor jedem Kauf gelten.
4. Vorrat für einen späteren Abschnitt: konkrete Bankempfehlung prüfen, aktuelles Material bleibt vollständig in den Taschen. Einlagern und aktualisierte Empfehlung prüfen; alternativ „Jetzt weiterherstellen“. Späterer Abschnitt fordert gelagertes Material über den vorhandenen Guide an.

Die automatisierten Szenarien beweisen keine tatsächliche FPS-Verbesserung oder abgeschlossene Live-Prüfung des Nutzerablaufs.
