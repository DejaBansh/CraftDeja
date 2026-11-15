# beta.17 — Peak-Anzeige, Speicherhypothese und Dev/Release-Vergleich

## Aktueller Livebefund

Nutzerbeobachtung: mehr aktivierte Addons scheinen das Ruckeln zu verstärken.
CraftDeja allein war mehrfach flüssig; auch CraftDeja + KelaGraphics und danach
die kumulativ hinzugefügten Forever Companion, Loot Sparkles, Quest Tint,
ForeverQuestMark, GearQuest Forever, LFG Bulletin Board, RogueEnergyCombo und
ForeverDungeonJournal waren laut Nutzer flüssig. Anschließend wurden weitere
Addons ohne vollständige Liste aktiviert; Ruckeln wieder vorhanden. Der zuletzt
vorgeschlagene einzelne QuestRadar-Test wurde nicht separat bestätigt.
KelaGraphics ist damit nicht als einzelner Partner bewiesen. Vorherige
Gruppenbeobachtungen nicht als allgemeine Entlastung einzelner Addons ausgeben.

Neuer Screenshot: CraftDeja 9.4%, 3.34ms/f, Peak >100; alle Addons 16.8%,
5.94ms/f, 28 FPS. Diese Momentaufnahme belegt keine monotone Speicherzunahme,
keinen Leak und keinen Zusammenhang der Kosten mit einer bestimmten Funktion.

## Verifizierte Bedeutung von Peak

Lokaler Freeloader/Core.lua: SPIKE_BANDS liest vorhandene
C_AddOnProfiler/Enum.AddOnProfilerMetric.CountTimeOver{N}Ms-Zähler. WorstBand
ermittelt die höchste seit der vorigen Abfrage gestiegene Schwelle. >100 steht
für mindestens eine vom Client diesem Addon zugeordnete Framezeit über 100ms,
nicht für 100% RAM/CPU und nicht für eine exakt 100ms lange Funktion.
PEAK_HOLD=10 hält die Spitze etwa zehn Sekunden sichtbar. Daraus folgt kein
Nachweis eines neuen Freezes alle zehn Sekunden. Durchschnitt ms/f und Peak
beantworten unterschiedliche Fragen. KB/s-Striche liefern keine Messreihe des
Speicherverbrauchs.

## Offene Hypothesen

Lua verwaltet gemeinsam genutzten Speicher und bereinigt nicht mehr benötigte
Objekte. Mehr Addons und mehr kurzlebige Objekte können den Aufwand erhöhen,
ohne dass der physische RAM voll sein muss. Welche Kosten der Client welchem
Addon zuordnet, wird hier nicht aus einer Peak-Anzeige hergeleitet. Ein
Speicherleck erfordert zeitliche Messungen unter wiederholbar gleichem Ablauf;
größere Dateigrößen oder ein einzelner hoher Speicherwert beweisen es nicht.

Der installierte beta.17-Build ist dev+59bee85. Die generierte wowlua-Runtime
misst in diesem Profil automatisch Funktionsaufrufe, Handler, Zeiten, Callpaths
und Speicherzählstände; sie führt Statistiken und Frame-Ringe. Diese Arbeit ist
zusätzlich zur standardmäßig ausgeschalteten /cdj-perf-Aufnahme aktiv. Letztere
erfasst ausgewählte App-Funktionen/den zentralen Eventframe, nicht die ganze
generierte Runtime oder globale Framepausen. Ein Zusammenhang mit Heapgröße,
Garbage Collection oder anderen Addons ist plausibel, aber noch nicht bewiesen.

## Vorbereiteter Vergleich, kein behaupteter Fix

Unveränderter beta.17-Quellcode als release gebaut. Die generierte TOC lädt ein
CraftDeja.lua-Bundle und enthält keine wowlua/runtime.lua oder
WowluaDevDB-SavedVariable. Im Release-Bundle keine __wl.prof/__wl.mon/__wl.perf-
Instrumentierung gefunden. Automatische Kennung auf diesem Feature-Branch:
3.9.0-beta.17-alpha+a1362f0; das ist die Compilerkennung des Vergleichsartefakts,
keine ausgelieferte neue Fachversion. app.release bleibt 3.9.0-beta.17.

Dateistatistik: Dev 117 Dateien / 3005234 Lua-Bytes, Release 73 Dateien /
2757338 Lua-Bytes. Das sind Dateigrößen, KEINE gemessenen Live-Heapgrößen,
Allokationsraten oder CPU-Gewinne. Die Art-Dateien dominieren die Gesamtgröße.

Testskript erweitert um -Profile dev|release (Default dev). Build und Benchmark
verwenden dieses Profil. wowlua 0.13.14 test besitzt keinen Profilselektor:
die komplette Quellsuite bleibt native Quellemulation, und wird nicht als
Ausführung des gebündelten Release-Artefakts ausgegeben. Metadaten trennen
buildProfile und testMode ausdrücklich. Der erste Versuch 20261115-213806-e02211
baute erfolgreich, scheiterte aber am nicht unterstützten test --profile;
kein Testnachweis. Nach Hilfeprüfung korrigiert und neu ausgeführt.

Finalen Bericht/Testergebnisse in CONTINUE.md und TEST_RESULTS.md prüfen.
Der Build ist ein vorbereiteter A/B-Kandidat; die Spielinstallation wurde in
dieser Untersuchung nicht ersetzt. Kein Merge, kein Release/Publish.

## Gezielter nächster Livevergleich

Nach separat angekündigtem, abgesichertem Wechsel auf den geprüften
Release-Kandidaten exakt gleiche Addons, Charakter, Ort, Fenster und
Freeloader-Einstellungen benutzen. Nach Ladephase 60–90s ohne /cdj perf start
beobachten; Kauf/Craft nicht nötig. Auftretende Freezes und neue Peaks nach
Ablauf der zehnsekündigen Haltezeit vergleichen. Eine Rückinstallation des
gesicherten Dev-Builds kann eine beobachtete Änderung anschließend bestätigen.
Nicht gleichzeitig scriptProfile, Grafikeinstellungen oder Addongruppe ändern.
Verschwinden die Spitzen, ist Dev-Instrumentierung als beteiligte Bedingung
eingegrenzt; dies beweist weiterhin kein Speicherleck als konkreten Mechanismus.
Bleiben sie, weitere Frame-/Speichermessungen vorbereiten, keine pauschale
Garbage-Collection oder künstliche Zeitdrossel als vermeintlichen Fix einbauen.
