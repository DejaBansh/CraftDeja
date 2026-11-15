# Beta.17 — verbleibende CPU-Spitzen nach beta.16

## Livebeleg und seine Grenzen

Nutzerrückmeldung vom 15.11.2026: Ruckeln mit beta.16 besser, aber noch vorhanden.
Freeloader-Screenshot: CraftDeja 10.9%, 3.89 ms/f, alle Addons 19.7%, 7.07 ms/f,
28 FPS. Das ist kein kontrollierter Vorher-/Nachher-Vergleich. Ein niedrigerer
prozentualer Anteil allein belegt keine kleinere absolute Framezeit.

Der beigefügte beta.16-CPU-Abschnitt misst 30.000s, 2355 OnUpdate-Aufrufe,
neun refresh/decide/marketView/readRecipes. refresh maximal 171.212ms,
OnUpdate maximal 173.770ms; decide maximal 127.224ms. selectionAt 216 Aufrufe,
989.836ms inklusive/399.414ms eigene Zeit. probability 63984 Aufrufe,
447.955ms eigene Zeit. readRecipes 227.088ms insgesamt, maximal 26.499ms.
OnEvent 373 Aufrufe, davon 363 GET_ITEM_INFO_RECEIVED und sieben
TRADE_SKILL_LIST_UPDATE. Keine gemeldeten Fehler. Instrumentierungsaufwand
ist eingeschlossen. Inklusive Zeiten dürfen nicht addiert werden.

Die Aufnahme belegt verbleibende teure Aktualisierungen und Auswahlberechnungen.
Sie ordnet keinen bestimmten einzelnen Refresh einem bestimmten Event zu.
Eine Auctionator-Endlosschleife, die Ursache jedes Rucklers und die genaue
Gleichzeitigkeit des Screenshots mit der Aufnahme sind damit nicht bewiesen.
Die übrigen Logeinträge enthalten auch alte Versionen; diese werden nicht als
beta.16-Ereignisse oder als Teil der 30s-Aufnahme ausgegeben.

## Nachgewiesene zusätzliche Arbeit und Korrektur

- selectionAt berechnete vor jeder Zugangs-/Skill-/Statusprüfung die
  Wahrscheinlichkeit aller Rezepte, auch unbestätigter, gesperrter oder noch
  nicht lernbarer Einträge. Jetzt werden nur solche Einträge ausgewertet, die
  entweder eine Empfehlung oder die getrennte Zahl ungeprüfter Quellen
  beeinflussen können. Unbekannte Quellen bleiben sichtbar; fehlende Preise,
  Farben, grüne Alternativen, Mehrpunktrezepte und negative Nettokosten behalten
  ihre bisherigen Regeln. Kein persistenter Entscheidungs- oder Preiscache.
- relevantItem suchte für nicht im Preis-Snapshot enthaltene Gegenstände bei
  jedem erfolgreichen Metadatenereignis erneut durch alle Rezeptgruppen und
  Ausgaben. Ein lazily aufgebauter Gegenstandsindex pro Rezepttabelle ersetzt
  diese Suche. Nach jedem vollständigen readRecipes wird er invalidiert, auch
  wenn eine Test-/Clientimplementierung dieselbe Tabelle wiederverwendet;
  ein Sitzungswechsel baut ihn ebenfalls neu auf. Preis-/Verkaufspreis-Snapshot
  wird weiterhin direkt geprüft. Relevante Events behalten die bestehende
  vollständige Aktualisierung und die 0.2s-Bündelung bei.

Keine neue Drossel, keine ausgelassenen Rezeptänderungen und keine Änderung
der manuellen Kaufmengen. Es wurde keine pauschale Verringerung der neun
Live-Refreshs vorgenommen: deren fachliche Notwendigkeit ist nicht einzeln belegt.

## Reproduzierbarer Vergleich

Getrennte, nacheinander ausgeführte native Windows/Camelot-Benchmarks mit
wowlua 0.13.14 und Dev-Profil, sieben Samples, Zielgröße 100ms/Batch.
Isolierter beta.16-Ausgang unter reports/performance/beta17-baseline;
identische Datei tests/ResidualCostSuite/residual.test.wowlua auf beiden Seiten.
Synthetisch 262 bestätigte Rezepte: 32 bekannte, 230 unbekannte mit Skill 200;
aktuell Skill 117, Cap 150. Größe und Skill stammen aus dem Livekontext, diese
Zusammensetzung bildet NICHT die tatsächlich vorhandenen 262 Rezepte ab.

| Messung | beta.16 | beta.17 |
|---|---:|---:|
| Wahrscheinlichkeit je Entscheidung über 34 Skillstände | 8908 | 1088 |
| Native Zeit je Entscheidung, optimiert | 35.421267ms | 9.928720ms |
| Native Zeit je Entscheidung, unoptimiert | 34.950167ms | 9.915473ms |
| Adaptive Aufrufe pro Batch | 3 | 15 |

Zeiten werden vom nativen Runner je Aufruf normiert. Streuung und Umgebung
stehen in den Rohberichten. Das ist ein Emulator-Stresstest; keine Aussage
über 3.89ms/f oder eine weitere gemessene FPS-Verbesserung im Spiel.

Ein differenzieller Test vergleicht den eingefrorenen beta.16-Selektor mit dem
neuen Selektor über 60 Katalogvarianten, vier Skillstände und Live/Future,
also 480 Vergleiche. Verglichen werden bekannte/unbekannte Kandidaten, Chancen,
Kosten, Farben, fehlende Preise, unbekannte Quellen und grüne Zusatzoptionen.
Ein weiterer Test prüft Wiederverwendung des Gegenstandsindex über 363 Events
und seinen Ersatz beim Sitzungswechsel. Bestehende vollständige AH-/Kauf-/Craft-
und Wirtschaftstests bleiben erforderlich. Der finale Gesamtnachweis steht in
TEST_RESULTS.md und in der teilbaren ZIP; ein fokussierter Zwischenlauf ist
kein Ersatz dafür.

Finale Windows/Blizzard-UI-Gesamtsuite für beta.17: 520 bestanden, 0
fehlgeschlagen, 0 übersprungen, 312 Testdateien, 207.86s; Build erfolgreich.
reports/tests/20261115-202609-aaf84c.zip. Alle 38 Lua-Quellhashes und sämtliche
Testeingaben wurden aufgezeichnet. Gesamtbericht mit Roh-ZIPs, Live-CPU-Auszug,
Umgebung und Vergleichsprüfsummen: reports/performance/beta17-20261115-202609.zip.

Rohberichte: vorher Benchmark 20261115-202439-1ec4d4, nachher
20261115-202520-734dcb. Unveränderte beta.16 verletzt erwartungsgemäß die zwei
neuen Aufruf-/Indexgrenzen (1 bestanden, 2 fehlgeschlagen):
20261115-202550-0595e1. Fokussierter korrigierter Lauf 20261115-202421-766d66
besteht alle drei Tests; Versionskennung danach auf beta.17 angehoben.

Verworfener Versuch: zusätzliche snapshotgebundene Wahrscheinlichkeitstabellen
reduzierten im alten All-Eligible-Stressfall die Aufrufe nur 27510 -> 25938 und
lieferten schlechtere Laufzeiten. Vollständig entfernt; Acquisition.lua bleibt
gegen beta.16 unverändert. Die explorativen Benchmarks 202158-9e48a2 und
202211-44e837 hatten teilweise überlappende Laufzeit und sind keine finalen
Vergleichsdaten. Die ersten neuen Testfixtures hatten einen Klammerfehler und
danach eine fehlende lokale Bindung der Referenzfunktion; beide korrigiert,
Fehlberichte bleiben lokal erhalten und gelten nicht als bestandene Tests.

## Nächster Live-Test

Nach geprüfter Installation /cdj version auf beta.17 prüfen. Gleicher Charakter,
Beruf, Ort, Addons und Freeloader-Einstellung; zunächst ohne aktive Diagnose
AH/Scan/Angebotsöffnung sowie eine kleinere manuelle Kaufmenge ausprobieren.
Danach gezielt /cdj perf start, 30s denselben Ablauf wiederholen und
/cdj perf show: CPU-Abschnitt kopieren. Kein Kauf nötig. Bitte unterscheiden,
ob Spitzen beim Berufsöffnen, während des Scans, beim Angebotsöffnen oder im
Leerlauf auftreten. Aufnahme selbst hat Overhead; sie ist kein FPS-Benchmark.

Die neun vollständigen Rezeptlesungen und wiederholtes UI-Rendering bleiben
als mögliche Restkosten sichtbar. Weitere Eingriffe nur mit Belegen und
korrekter Invalidierung, nicht durch pauschales zeitliches Unterdrücken.
