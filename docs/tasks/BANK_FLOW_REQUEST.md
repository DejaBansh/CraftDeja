Arbeite in meinem aktuellen lokalen CraftDeja-Projekt für WoW Forever. Prüfe zuerst Git-Status und AGENTS.md und erhalte meine vorhandenen lokalen Änderungen. Reproduziere die gemeldeten Probleme mit wowlua und behebe sie im bestehenden Ablauf.

## 1. Automatisches Öffnen beim Händler abschaltbar machen

- Füge einen dauerhaft gespeicherten Schalter „Beim Händler automatisch öffnen“ hinzu. Beschrifte ihn auf Deutsch und Englisch.
- Bei ausgeschaltetem Schalter bleibt ein geschlossenes CraftDeja-Fenster geschlossen, wenn ich einen Händler öffne, erneut besuche oder seine Warenliste aktualisiert wird. Bei eingeschaltetem Schalter gilt das bisherige Händlerverhalten.
- Manuelles Öffnen, Händlererkennung und Händlerkauf innerhalb eines aktiven Auftrags funktionieren in beiden Einstellungen.
- Prüfe separat das Anklicken eines Berufs. CraftDeja öffnet sich dabei aktuell ebenfalls. Verfolge, welcher Auslöser das Fenster öffnet und was mit einem bereits laufenden Auftrag passiert. Prüfe den Berufsaufruf vor und nach dem Bankschritt. Dabei muss der bestehende Auftrag mit seinem tatsächlichen Fortschritt weiterlaufen.

## 2. Stillstand an der Bank beheben und Materialien automatisch einlagern

Beobachtung im Spiel: CraftDeja zeigte beim Bankbesuch „Bankmaterialien anzeigen“ und blieb in diesem Schritt hängen. Im Screenshot soll 1 × Leinenstoff für spätere Skillups eingelagert werden, während der Bedarf für den aktuellen Craft in den Taschen bleibt.

- Stelle den Stillstand mit dem tatsächlichen CraftDeja-Code in wowlua nach. Verfolge die Ereignisse und Zustandsübergänge vom Öffnen der Bank über die erste und letzte Verschiebung bis zur nächsten Aktion im Guide. Dokumentiere, ob der Auftrag auf ein Ereignis wartet, ein Übergang fehlt oder sich ein Ablauf wiederholt.
- Wenn die passende Bank geöffnet ist und der aktive Auftrag eine Einlagerung vorsieht, verarbeite alle dafür eingeplanten Gegenstände und Mengen. Verwende vorhandenen Platz in passenden Stapeln und danach geeignete freie Plätze. Teile Stapel bei Bedarf. Beispiel: Bei 8 × Leinenstoff in den Taschen, davon 7 für den aktuellen Craft und 1 für später, lagere genau 1 ein.
- Bestätige jede Verschiebung anhand der tatsächlichen Bestandsänderung. Verarbeite verzögerte und doppelte Ereignisse so, dass dieselbe Menge nur einmal verschoben und verbucht wird.
- Wenn nachweislich kein passender Platz mehr frei ist, lagere die mögliche Teilmenge ein und zeige „Bank voll“ mit den konkreten Restmengen. Unterscheide volle Bank, geschlossene Bank und abgelehnte oder unbestätigte Verschiebung. Der Guide soll in jedem Fall zeigen, was noch offen ist und wie es weitergeht. Setze nach erneutem Öffnen oder nach Freimachen von Platz bei der tatsächlichen Restmenge fort.
- Sobald die Einlagerung bestätigt ist, muss der Guide zum nächsten sinnvollen Schritt wechseln. Sind die Zutaten für den aktuellen Craft bereits in den Taschen, soll er zur Herstellung weiterführen. Prüfe später auch die Entnahme des eingelagerten Materials, sobald die Route es braucht.
- Prüfe die Bank-API von WoW Forever und berücksichtige die TSM-Bankansicht aus dem Screenshot. Falls der Client einen Nutzerklick für die Verschiebung verlangt, biete „Bankmaterialien einlagern“ an und arbeite nach dem Klick die Liste ab, soweit der Client es unterstützt. Zeige konkret an, wenn eine weitere Aktion erforderlich ist.

## 3. Den vollständigen Ablauf in wowlua prüfen

Führe einen zusammenhängenden Test mit den echten CraftDeja-Modulen aus. Simuliere die Client-Ereignisse an den API-Grenzen und prüfe nach jedem Schritt die aktuelle Aktion im Guide, den Auftragszustand und die Mengen:

Beruf anklicken → vorhandene Route laden → fehlende Zutaten über den vorgesehenen Händler- oder AH-Ablauf beschaffen und einbuchen → Bank öffnen → Material für später einlagern → aktuellen Craft ausführen → später benötigtes Material aus der Bank entnehmen → Route fortsetzen.

Prüfe zusätzlich:

- Händleroption an und aus, nach Reload und bei wiederholten Händlerbesuchen. Prüfe manuelles Öffnen und das Anklicken des Berufs in beiden Einstellungen.
- Einlagerung mehrerer Gegenstände, Stapelteilung, Auffüllen eines vorhandenen Stapels, teilweise volle Bank und volle Bank.
- Bank während einer Verschiebung schließen, danach erneut öffnen und den Auftrag fortsetzen. Prüfe verspätete und doppelte Bestandsereignisse sowie das erneute Anklicken des Berufs in diesem Zustand.
- Der Leinenstoff-Fall aus dem Screenshot bleibt im Test nachvollziehbar. Die 7 Stück für den aktuellen Craft bleiben in den Taschen, 1 Stück wird eingelagert und der Guide wechselt nach bestätigter Einlagerung zur nächsten Aktion.

Führe nach den gezielten Tests die vorhandenen wowlua-Regressionstests nach den Projektregeln aus und erstelle einen installierbaren Release-Build. Berichte kurz, wo der Ablauf hängen blieb, wie du ihn behoben hast und welche vollständigen Durchläufe bestanden haben. Wenn der Live-Test mit WoW Forever und TSM noch aussteht, nenne die konkreten Prüfschritte dafür. Kein Merge nach main und keine Veröffentlichung.