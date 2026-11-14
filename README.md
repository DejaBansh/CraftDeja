# CraftDeja 3.9.0-beta.4 — Ingame-Systemcheck

Zahnrad → Hilfe → Systemcheck oder /cdj check. Neuen Test starten, den angezeigten
Schritt selbst im Spiel durchführen, danach den Systemcheck wieder öffnen.
Grün/Bestanden bestätigt nur den ausdrücklich beschriebenen beobachteten Teil.
Gelb/Warten ist kein Erfolg; fehlende Voraussetzungen lassen sich überspringen.
Nach einem Ergebnis Nächster Schritt wählen. Schritt wiederholen setzt nur den
Diagnoseschritt zurück. Beenden beendet die Beobachtung. Neuen Test starten ersetzt
den vorherigen Testbericht, nicht den Auftrag. Der letzte Bericht bleibt pro
Charakter gespeichert; nach /reload ist der Test angehalten.

Der Test kauft und craftet nicht selbst, ändert keine Ziele und öffnet keine
nativen Fenster. AH-/Händler-/Craftschritte nur mit ohnehin benötigten Käufen
prüfen, ansonsten überspringen. Kaufbestätigungen bleiben unverändert erforderlich.
Bestand prüft die gelieferten Ausgabe-IDs und die mathematische Taschenfehlmenge;
das ist kein Beweis, dass jede externe Inventar-API fehlerfrei ist. Der Mailtest
bestätigt einen beobachteten Teilzugang, nicht zwangsläufig die ganze Post.

Bericht kopieren markiert den Bericht samt begrenzten Testbelegen und vorhandenem
Diagnoselog für Strg+C. Keine nicht geprüfte Funktion gilt als bestanden. Eine
leichte passive Kontrolle protokolliert einen erkannten Giftverkäufer ohne
sichtbaren Guide; ein bewusstes Schließen nach Händleröffnung wird respektiert.
Dies ist ein geführter Diagnosewerkzeugkasten, keine vollständige automatische
Garantie für alle Addons, geschützten Aktionen oder Lua-Fehler im Client.

# CraftDeja 3.9.0-beta.3

## Fenster und Berufswechsel

Unterseiten behalten den gemeinsamen Titel und das Logo. Eingebettete Seiten
zeichnen keine eigene Kopfzeile mehr über die zentrale Navigation. Einstellungen,
Nachschlagen und Hilfe bleiben im selben Rahmen. Ein neuer Giftverkäuferbesuch
öffnet auch einen zuvor geschlossenen Guide nach einem abgeschlossenen Auftrag.
Ein erneutes Händler-Update während desselben Besuchs respektiert das Schließen.

Beim Berufswechsel werden bekannte fremde Rezeptlisten verworfen. Die Aktionen
bleiben während des Ladens gesperrt, bis passende Rezepte verfügbar sind. Gemischte
Listen ohne ein einziges passendes bekanntes Rezept werden ebenfalls zurückgehalten.
Wiederholte identische Rezeptprüfungen überfüllen den Diagnoseverlauf nicht mehr.

Die gemeldeten Abläufe wurden simuliert nachgestellt; Darstellung und TSM-
Interaktion bitte im Forever-Client prüfen. Aufträge und gespeicherte Ziele bleiben.

# CraftDeja 3.9.0-beta.2

## Giftbestand klar anzeigen

Neue Charakterprofile starten mit Zielbestand auffüllen. Bestehende explizite
Mengen und laufende Aufträge werden nicht umgedeutet. Der Guide zeigt den Modus
sowie Taschen/Ziel/Fehlmenge oder vorhandenen Bestand/zusaetzliche Produktion.
Der Tooltip nennt jedes Ausgabe-Item samt ID. Verschiedene Giftränge werden
nicht vermischt. Unbekannte Bestandswerte sperren die Auffüllaktion; vollständig
gedeckte Ziele benötigen keinen neuen Auftrag. Das Log enthält Modus und die
Werte, aus denen der Auffüllauftrag berechnet wurde.

Für einen alten Zusatzauftrag: Auftrag ändern, Plan abbrechen, auf Zielbestand
auffüllen wechseln, Zielmengen einstellen und übernehmen. Gespeicherte Zusatz-
und Vorratsmengen bleiben getrennt. Bestehende Aufträge werden nie automatisch
vergrößert; erneutes Auffüllen benötigt eine ausdrückliche Bestätigung.

# CraftDeja 3.9.0-beta.1

## Eine zentrale Oberfläche

Der Guide ersetzt das automatische Berater-Hauptfenster. Im Alltag zeigt er
Auftragsübersicht, nächstes Ziel und die passende Aktion. Auftrag ändern öffnet
Giftmengen/Vorratsziele oder das normale Skillziel im selben Rahmen. Zurück zum
Guide ändert den Auftrag nicht. Beim Giftverkäufer erscheint nur der Guide mit
dem passenden Schritt und dem zu bestätigenden Gesamtpreis.

Im Zahnrad liegen Einstellungen, Nachschlagen und Hilfe. Rezeptkatalog,
Materialien, Quellen, Händler, Rezeptcheck und Protokoll nutzen denselben Rahmen.
Unten rechts lässt sich der Guide skalieren. Beim Berufsschließen bleibt nur
der Guide sichtbar; Aufträge und offene Kaufbestätigungen bleiben erhalten.

WoW schließen und den CraftDeja-Ordner ersetzen. Gespeicherte Einstellungen bleiben.
Die Umstellung ist simuliert geprüft; Darstellung und Interaktion bitte im
Forever-Client testen. Kaufen erfordert deine Bestätigung; Herstellen deinen
Klick auf den markierten originalen Herstellknopf.

## Frühere Änderungen

# CraftDeja 3.8.0-beta.7

## Beim Berufsschließen nur den Guide behalten

Sobald du das originale Berufsfenster schließt, bleiben nur Nächster Schritt
und die darin enthaltene Auftragsübersicht sichtbar. Alle anderen registrierten
CraftDeja-Fenster werden geschlossen: Berater, Gifte-Planer, Material-/Einkaufs-
fenster, Händler-Popups, Einstellungen, Rezeptcheck und Protokoll.

Aufträge, Zielmengen, Preis-/Bestandsdaten und offene Kaufbestätigungen bleiben
erhalten. Das Schließen ist keine Stornierung. Bereits laufende native Crafts
werden dadurch nicht zusätzlich ausgelöst oder automatisch abgebrochen.

Eine spätere Rückmeldung desselben Händlers öffnet dessen Popup nicht erneut.
Ein noch laufender Scan darf ein gerade geschlossenes Einkaufsfenster ebenfalls
nicht ohne erneute Freigabe öffnen. Der Guide, Befehle und ausdrücklich gewählte
Fenster bleiben bedienbar. Ein erneutes Berufsöffnen oder ein neuer Händlerbesuch
öffnet die passenden Ansichten wieder; neue AH-Besuche behalten die bestehende
Scan-/Einkaufsfunktion. Ohne frische Preise bleibt Einkaufen wie bisher gesperrt.

Installation: WoW schließen und den CraftDeja-Ordner ersetzen. /cdj log zeigt
3.8.0-beta.7. Die Schließlogik ist simuliert geprüft, bitte noch im Client testen.

# CraftDeja 3.8.0-beta.6

## Giftverkäufer öffnet den Planer

Beim Ansprechen eines Händlers mit Giftzutaten öffnet CraftDeja den Gifte-Planer
auch ohne bereits aktiven Auftrag. Erkannt werden fünf eindeutige Giftzutaten
über die tatsächlichen Händlerangebote; Phiolen allein gelten nicht als Beweis.
Die Erkennung nutzt Händlerereignisse und Item-APIs statt der Sichtbarkeit des
Standardfensters und funktioniert daher auch mit einer TSM-Händleroberfläche.

Sind Gifte in dieser Spielsitzung bereits vollständig eingelesen, kann der
zuletzt gültige Gifte-Kontext wiederverwendet werden. Ein aktuell geöffneter
anderer Beruf oder eine laufende Craft-Vorbereitung wird dabei nicht gewechselt.
Ein bestehender Auftrag zeigt passende fehlende Händlerzutaten samt Kaufpreis.
Ohne Auftrag wählst und übernimmst du zunächst deine Mengen bzw. Vorratsziele.
Es wird kein Auftrag und kein Kauf allein durch den Händlerbesuch ausgelöst.

Nach neuem Login oder ungültigen Berufsdaten erscheint stattdessen ein kleines
Fenster mit Gifte öffnen. Erst dein Klick öffnet den originalen Beruf 40 und
liest dessen Rezepte ein; keine geratenen Rezeptdaten werden verwendet. Das
Öffnen des originalen Berufs kann das Händlerfenster spielbedingt schließen.
Danach Mengen wählen und den Händler erneut ansprechen.

Verzögert geladene Händlerangebote werden bei Updates und für kurze Zeit erneut
geprüft. Pro Händlerbesuch öffnet das Fenster nur einmal; nach manuellem Schließen
bleibt es für diesen Besuch geschlossen. Ein neuer Besuch öffnet es erneut.
Die Erkennung wird als poison.vendor_open im Diagnoseverlauf erfasst.

Installation: WoW schließen und CraftDeja-Ordner ersetzen. /cdj log zeigt
3.8.0-beta.6. Die neue Händlererkennung wurde simuliert geprüft; bitte den
konkreten Händler und deine TSM-Version noch im Spiel prüfen.

# CraftDeja 3.8.0-beta.5

## Giftefenster passend zur Rezeptzahl

Der Gifte-Planer ist schmaler und passt seine Höhe an die Anzahl gelernter
Giftrezepte an. Ein Rezept benötigt keine große leere Liste mehr. Bis zu drei
Zeilen sind gleichzeitig sichtbar; ab vier Rezepten wird gescrollt. Bestehende
persönliche Fensterskalierungen und Ziehen an der unteren rechten Ecke bleiben.

Rezeptnamen, Bestandsangaben und Mengenfelder sind größer. Zutatenzeilen haben
eine dezente Karte für bessere Lesbarkeit. Regler und Eingabefeld stehen auf
einer gemeinsamen Zeile; Status und Aktionsbuttons folgen direkt unter der Liste.
Die Anzahl sichtbarer Rezepte ändert nur das Layout, nicht die Mengen oder Ziele.

Im Gifte-Hauptfenster steht eine kurze Hilfe anstelle des abgeschnittenen langen
Textes. Planer öffnen führt direkt zum Gifte-Planer. Der Hinweis Nächster Stapel
vorbereitet erscheint nur noch bei tatsächlicher nativer Craft-Vorbereitung.

Installation: WoW schließen, CraftDeja-Ordner ersetzen. Einstellungen bleiben.
/cdj log zeigt 3.8.0-beta.5. Darstellung noch im echten Client prüfen.

# CraftDeja 3.8.0-beta.4

## Auftragsübersicht im Fenster Nächster Schritt

Unter Rezept und Routenziel steht eine kompakte Leiste mit fünf Stationen:
Einkaufen, Post, Händler, Herstellen und Fertig. Zahlen zeigen offene Stücke;
bei Herstellen sind es verbleibende Herstellungen, nicht produzierte Stücke.
Gelb ist die aktuell empfohlene Station, Grün ist erledigt/nicht nötig, Grau ist
noch offen oder ungeklärt. Während des Scans steht ? statt einer Freigabe.

Maus über eine Station zeigt die offenen Materialien und Mengen. Bei großen
Listen werden bis zu acht Materialarten im Tooltip dargestellt; der Rest wird
als Anzahl weiterer Arten genannt. Herstellen enthält außerdem die Zahl echter
erfasster Craft-Erfolge. Bank-/Alt-Bestände erscheinen bei Bedarf als extra
Abholhinweis. Die bestehende Bestandspriorität bleibt bestehen: bereits mögliche
Crafts können vor weiteren Einkäufen empfohlen werden.

AH-Käufe bleiben bis zur Bestätigung offen; erst bestätigte Anhänge zählen als
Post. Bei mehreren Giften gilt die Übersicht für alle ausgewählten Giftarten,
auch wenn gerade nur ein Stapel im originalen Berufsfenster vorbereitet ist.
Für normale Skillrouten gilt die nächste Routengrenze; geschätzte Rest-Crafts
können sich bei gelben/grünen Rezepten ändern. Fertig erfordert die erreichte
Grenze bzw. einen abgeschlossenen Gifte-Auftrag und keine offenen erfassten
Kauf-/Postaufgaben. Abgebrochene Gifte-Aufträge werden nicht als fertig gezählt.

/cdj auftrag oder /cdj order öffnet Nächster Schritt mit der Übersicht erneut.
Der letzte Auftragskontext und erfasste Craft-Erfolge werden pro Charakter
beibehalten. Die Anzeige ist eine Übersicht; sie tätigt selbst keine Käufe und
startet keine geschützten Crafts. AH-/Händlerkäufe und Herstellen nutzen weiterhin
den vorhandenen Bestätigungsablauf.

Installation: WoW schließen und CraftDeja-Ordner ersetzen. Einstellungen bleiben.
/cdj log zeigt 3.8.0-beta.4. Die neue Anzeige benötigt noch einen Test im Spiel.

# CraftDeja 3.8.0-beta.3

## Kompaktere Innenbereiche im Berater

Die drei Karten für aktuellen Craft, nächste Aktion und Skillübersicht sind
schmaler und flacher. Gleichmäßige Abstände und mehr Rand lassen den gewählten
Berufshintergrund besser sichtbar. Textgrößen bleiben lesbar; Links und Inhalte
sind an die neuen Kartenmaße angepasst.

Installation: WoW schließen und CraftDeja-Ordner ersetzen. Gespeicherte
Einstellungen bleiben erhalten. /cdj log zeigt 3.8.0-beta.3.

# CraftDeja 3.8.0-beta.2

## Zielbestand auffüllen – zuerst für Gifte

Öffne Gifte und wähle oben im Planer den Modus Zielbestand auffüllen. Stelle
für jedes gelernte Gift den gewünschten Vorrat (0–200) ein. Die Zeile zeigt
Taschenbestand, Ziel, Fehlmenge und tatsächliche Produktionsmenge. Beispiel:
7 vorhanden, Ziel 20: 13 herstellen. Ziel 0 ignoriert diese Giftart.

Mit Auffüllen planen bestätigst du einen neuen Auftrag nur für die Fehlmengen.
Die gemeinsame Zutatenliste und der bestehende Händler-/AH-/Craft-Ablauf werden
weitergenutzt. Ist alles vorhanden, entsteht kein Kauf- oder Craft-Auftrag.
Jede Giftart muss weiterhin am markierten originalen Herstellknopf gestartet
werden. Ein Klick im Planer startet keinen geschützten Craft im Hintergrund.

Ziele gelten ausschließlich für die Taschen dieses Charakters. Fertige Gifte
auf Bank und gespeicherten Alts werden separat angezeigt, aber nicht abgezogen.
Du kannst sie zuerst holen und danach den Auffüllauftrag planen; noch nicht
begonnene Restmengen werden bei erkanntem Zugang auch nach unten angepasst.
Bank/Alt-Zahlen können veraltet sein: Alt einloggen und Bank öffnen aktualisiert
sie. Fehlende Ausgangs-Items oder unlesbare Taschenbestände sperren das Auffüllen.

Ziele und Modus werden pro Charakter gespeichert. Zusätzlich herstellen bleibt
als separater Modus mit eigenen Mengen erhalten. Nach Verbrauch oder Verschieben
wird ein bestehender Auftrag nicht automatisch größer. Ein erneuter Auffüllklick
berechnet den neuen Bedarf. Es gibt keine unbeaufsichtigte Dauerproduktion.
Die ursprüngliche Gifte-Funktion und alle anderen Berufe bleiben unverändert.

Feste Rezeptausgaben werden als ganze Herstellungen geplant: fehlen 5 Stück bei
2 Stück je Craft, werden 3 Crafts / 6 Stück vorbereitet. Die tatsächliche Ausgabe
steht vor dem Start in der Zeile. Zwei ausgewählte Rezepte mit demselben Ausgabe-
Item sind im Zielbestandsmodus gesperrt, um doppelte Auffüllungen zu vermeiden.

Die neue Option ist simuliert geprüft; ein Test mit deinem Schurken in WoW
Forever steht noch aus. Für Fehler bitte /cdj log kopieren und mit dem Ablauf
in den CurseForge-Kommentaren melden.

Installation: WoW schließen und CraftDeja-Ordner ersetzen; Einstellungen bleiben.
Im Kopf von /cdj log muss 3.8.0-beta.2 stehen.

# CraftDeja 3.8.0-beta.1

## Gifte planen und Design A für alle Berufe

Beim Öffnen des Gifte-Berufs erscheint der neue Planer. Pro gelerntem Rezept
lassen sich 0–200 Ausgabestücke mit Regler oder Eingabefeld wählen. Mengen
übernehmen friert den Auftrag ein. Gleiche Zutaten werden über alle gewählten
Giftarten zusammengezählt; Taschen, Bank, gespeicherte Alts, bestätigte Post und
ausstehende Käufe werden wie bisher berücksichtigt. Zutaten suchen öffnet die
Gesamtübersicht. /cdj poisons und /cdj gifte öffnen den Planer erneut.

Händlerzutaten kaufen zeigt zuerst den Gesamtpreis. Nach dem Klick kauft die
Warteschlange verfügbare unbegrenzte Gold-Angebote in passenden Packungsgrößen.
Sie wartet nach jedem Kauf auf die echte Bestandsänderung und stoppt bei
Preissteigerung, fehlender Bestätigung oder geschlossenem Händler. Fehlende
AH-Zutaten gehen gesammelt an Auctionator; aktuelle Scans und Kaufbestätigungen
bleiben erforderlich. Kleinste Händlerpackungen können Mehrstücke enthalten.

Alle gewählten vorbereiten setzt den ersten möglichen originalen Craft-Stapel.
Du klickst selbst auf den hervorgehobenen originalen Herstellknopf. Nach echten
Erfolgsereignissen zählt der Auftrag herunter und bereitet die nächste Giftart
vor. Für jede Giftart ist erneut der native Herstellklick nötig: kein geschützter
Craft wird im Hintergrund gestartet. Graue Gifte sind als Verbrauchsmaterial
zulässig. Unvollständige Zutaten, Alternativzutaten und schwankende Ausgabemengen
werden nicht geraten; die Zielmenge muss ein Vielfaches der festen Ausgabe sein.

Giftrezepte werden ausschließlich aus dem geöffneten Clientfenster eingelesen.
Es gibt keinen geratenen statischen Giftkatalog. Der neue Ablauf ist simuliert
geprüft und benötigt noch einen echten Test mit deinem Schurken im Spiel.

Alle zehn Bereiche nutzen die gewählten A-Hintergründe: Gifte, Alchimie,
Verzauberkunst, Schmiedekunst, Lederverarbeitung, Schneiderei, Ingenieurskunst,
Kochkunst, Erste Hilfe und Bergbau/Verhüttung. Die Fenster wechseln mit dem Beruf;
Regler, Symbole und Texte bleiben echte bedienbare UI-Elemente darüber.

Installation: WoW vollständig schließen, den bisherigen CraftDeja-Ordner durch
den Ordner dieser ZIP ersetzen und starten. Einstellungen bleiben gespeichert.
Im Kopf von /cdj log muss 3.8.0-beta.1 stehen.

# CraftDeja 3.7.0-beta.1

## Rezeptänderungen sammeln und prüfen

Beim Öffnen deines Berufs sammelt CraftDeja ungeprüfte Beobachtungen zu unbekannten
Rezepten, geänderten Zutaten/Mengen und abweichenden Schwierigkeitsfarben. Im
Hauptfenster stehen Datenpaket-Datum und Zahl der Meldungen. Der Knopf Rezeptcheck
bzw. Prüfen (N) und /cdj data öffnen den kopierbaren Bericht; /cdj audit ist ein Alias.

Unvollständige Clientangaben gelten nicht als Zutatenänderung. Die vorhandene
Kostenberechnung verwendet vollständige aktuelle Zutaten aus dem Client weiterhin
vorrangig. Das Referenzpaket für andere Spieler wird dadurch nicht überschrieben.

Berichte werden pro Charakter gespeichert, identische Einträge zusammengefasst und
auf 200 begrenzt. Ein späterer Farb-/Skillwechsel löscht einen Prüfhinweis nicht.
Erst ein geändertes Referenzpaket kann passende alte Hinweise automatisch auflösen.
Bericht leeren entfernt den gespeicherten Bericht; beim nächsten Einlesen können
noch bestehende Abweichungen wieder auftauchen.

Mit Strg+C kopieren und freiwillig in den CurseForge-Kommentaren mit einer kurzen
Beschreibung melden. /cdj log enthält zusätzlich bis zu 20 aktuelle Rezeptmeldungen.
Der eigenständige Rezeptbericht enthält keine Charakternamen, Kontodaten, Realm-
namen oder Chattexte. Es gibt keinen automatischen Upload.

Datenpaket 2026.11.12.1 (gepackt 2026-11-12) ist ein Referenzstand und kein Nachweis,
dass alle Rezepte an diesem Tag einzeln überprüft wurden. Nur im Berufsfenster
sichtbare Clientdaten werden eingelesen; unbekannte, dort nicht sichtbare Rezepte
können so nicht gefunden werden. Referenzen extern etwa wöchentlich und nach
größeren Patches prüfen und bestätigte Änderungen mit einem Addon-Update verteilen.

# CraftDeja 3.6.0-beta.6

## Charakterlevel vor Trainerbesuch prüfen - Beta 6

Ist der nächste Berufsrang erst ab einer höheren Charakterstufe verfügbar, steht
nun groß im Berater und nächsten Schritt: Erreiche zuerst die benötigte Stufe.
Alchimie 75–150 benötigt laut hinterlegtem Rang und deinem Trainer Stufe 10.
Der Lehrer bleibt für später aufrufbar. Sobald die benötigte Stufe erreicht ist,
kehrt die Aufgabe automatisch zum Trainer zurück. Die eigentliche Rangfreigabe
erkennt CraftDeja weiterhin erst am vom Client gemeldeten neuen Berufscap.

# CraftDeja 3.6.0-beta.5

## Passenden Rang-Lehrer markieren - Beta 5

Am Skillmaximum markiert CraftDeja einen passenden Rang-Lehrer auf der Karte.
Im nächsten Schritt stehen Name, Koordinaten und Voraussetzungen. Der Knopf
Lehrer auf Karte zeigen öffnet die Zielkarte und stellt die Markierung wieder her.
Für Alchimie 75–150 in Undercity ist Doktor Marsh hinterlegt, für 150–225 Doktor
Herbert Halsey. Nach dem Lernen schaltet die Aufgabe anhand des neuen Client-Caps um.

Auswahl nach Beruf, exaktem Rang und Fraktion; Standorte auf der aktuellen Karte
werden bevorzugt. Die Orts-/Rangdaten sind Referenzen und nicht vollständig für
jede Forever-Änderung vor Ort bestätigt. Nicht erfasste Lehrer werden nicht geraten.
Erste Hilfe/Kochkunst können stattdessen ein Lehrbuch erfordern; das wird angegeben.

# CraftDeja 3.6.0-beta.4

## Briefkasten, Händler, Herstellen - Beta 4

Nach bestätigten AH-Käufen zeigt Nächster Schritt alle noch abzuholenden Materialien
zusammen an. Darunter stehen die anschließenden Händlermengen und der Craft-Schritt.
Gehe selbst zum Briefkasten und hole die Anhänge ab. Die automatische Bestandsprüfung
schaltet nach vollständiger Abholung weiter; Teilabholungen bleiben als Rest sichtbar.
Der Knopf Postbestand prüfen aktualisiert dieselbe Prüfung zusätzlich, anstatt
Rezeptdetails zu öffnen. Er öffnet keinen entfernten Briefkasten.

# CraftDeja 3.6.0-beta.3

## AH-Menge abgleichen - Beta 3

Die volle bezahlbare Planmenge wird bereits beim Anzeigen der Angebote im
Auctionator-Mengenfeld eingetragen. Vor der Preisanfrage werden Mengenfeld,
interne Menge und Gesamtpreis abgeglichen. Eine Abweichung sperrt den Kauf und
erscheint im Verlauf als ah.quantity.check.

Installation: WoW beenden, den bisherigen CraftDeja-Addonordner durch den Ordner
aus dieser ZIP ersetzen und WoW starten. Gespeicherte Einstellungen beibehalten.
Im Kopf von /cdj log muss 3.6.0-beta.3 stehen. Eine alte ZIP oder ein anderer
WoW-Installationsordner aktualisiert das laufende Addon nicht.

# CraftDeja 3.6.0-beta.2

## Scan-Sperre und volle Kaufmenge - Beta 2

Solange der aktuelle Vollscan läuft, verarbeitet wird oder die Preise abgelaufen
sind, steht im kleinen Fenster Warte auf aktuellen Scan. Suche, Kaufvorbereitung
und Kaufbestätigung über CraftDeja sind dann gesperrt. Die AH-Einkaufsschaltfläche
im Hauptfenster ist ebenfalls deaktiviert; alte Kosten/Planangaben werden während
des Wartens ausgeblendet. Das Öffnen des Berufs zum ersten Einlesen bleibt möglich.

Erst ein erfolgreicher Scan dieses AH-Kontexts gibt neue Daten frei. Zeigt
Auctionator danach noch einen laufenden Scan, wartet CraftDeja weiter. Ein AH-Schließen
verwirft eine noch ausstehende Freigabe. Die 30-Minuten-Gültigkeit gilt weiterhin
über kurze AH-Besuche hinweg und prüft zusätzlich die echte Uhrzeit: lange PC-Pausen
zählen mit. Nach /reload oder neuem Login ist ohnehin ein neuer Scan erforderlich.

Ein zusätzlich gefundener Fehler ist korrigiert: Die große Liste bis zur nächsten
Aktion wurde beim Laden des einzelnen Artikels wieder auf den alten manuellen
Fünf-Punkte-Wert reduziert. Artikel laden und Quote verwenden jetzt dasselbe Ziel.
Frische Live-Angebote aktualisieren den Stückpreis und die Preisgrenze. Vor einem
Kauf Preis/Menge prüfen und selbst bestätigen. Alte Plan-/Quote-Klicks nach einem
neuen Scan werden abgelehnt; der bereits verbrauchte Kaufrahmen wird nicht neu gewährt.

English: CraftDeja shopping stays disabled through scan processing and until a
successful same-context scan is ready and native scanners are idle. The 30-minute
window uses wall time as well as client time. Purchase paths retain the selected
Next action goal; stale scan-generation plans/quotes are rejected without restoring
spent purchase budgets. Live commodity-result events refresh current price limits.

## Neu: Ziel bis zur nächsten Aktion

Standard im Einkauf ist jetzt Ziel: nächste Aktion. Die alte gespeicherte +5-Auswahl
begrenzt diesen Modus nicht. CraftDeja plant bis zum nächsten berechneten Rezeptwechsel,
zum Lernen eines Rezepts, zur aktuellen Berufsrang-Grenze oder zur nächsten sicheren
Neubewertung. Im kleinen Fenster stehen Gesamtbedarf, Zielskill und nächste Aktion.
Gelb/Grün bleiben Schätzungen, keine garantierte Craft-Anzahl.

Der Regler aktiviert ausdrücklich den manuellen 1-50-Modus. Der Ziel-Knopf oben
schaltet auf nächste Aktion zurück. Automatische Ziele können über 50 Punkte reichen.
Mengen berücksichtigen vorhandenen Bestand und bestätigte Post. Normale Händlerwaren
bleiben getrennt, wenn der Händler günstiger ist. Nicht hinter einer Lern- oder
Ranggrenze für ungeprüfte Folgerezepte vorab einkaufen.

## Wichtige Aufgaben und Craft-Pfeil

Post abholen, Händler-/Bankbesuche, Rezepte/Ränge lernen und die native Bestätigung
werden durch größere goldene Schrift und einen pulsierenden Hintergrund hervorgehoben.
Der Text wird nicht ausgeblendet. Sobald die Aufgabe erledigt ist, wechselt die Anzeige.

Im Berufsfenster weist ein pulsierender Pfeil auf den passenden Knopf. Alle erstellen
wird nur markiert, wenn dessen aktuelle Anzahl exakt der sicheren Sammelmenge entspricht.
Andernfalls zuerst Alle vorbereiten (N), dann auf den markierten Erstellen-Knopf klicken.
Der Pfeil klickt nichts an und fängt keine Mausaktionen ab. Während des Casts verschwindet er.

## English quick reference - 3.6

Shopping defaults to Next action: the next recipe switch/learning step, rank cap or
safe review boundary. It no longer stops at a remembered +5 target. The slider opts
into manual 1-50 planning; the goal button returns to Next action. The task panel
shows the remaining estimated crafts, target skill and following action.
Important tasks have larger golden text and a pulsing background. A non-interactive
arrow points to native Create all only when its actual count exactly matches the
safe planned batch; otherwise it guides the prepared native Create button. Crafting
still requires the player's physical click in the profession window.

## Aktueller Herstellungsablauf - Beta 5

Der Client hat den Addon-Aufruf der Herstellungsfunktion ausdrücklich blockiert.
CraftDeja bereitet deshalb nur Rezept und Stückzahl vor. Der Start erfolgt über
einen echten Klick auf den normalen Erstellen-Knopf im Berufsfenster.

1. 1 Craft vorbereiten oder Alle vorbereiten (N) anklicken.
2. Im normalen Berufsfenster den hervorgehobenen Erstellen-Knopf anklicken.
   Nicht Alle erstellen wählen: dort könnte mehr als die begrenzte Planung starten.
3. CraftDeja verfolgt die tatsächlich gestarteten Crafts und die Restmenge.

Im kleinen Fenster steht die vorbereitete Anzahl samt Icon. Erstellen-Knopf zeigen
hebt den Knopf erneut hervor; Zurück verwirft die Vorbereitung. Ein Rezept- oder
Mengenwechsel bzw. Schließen des Berufsfensters verwirft sie ebenfalls. Zum Stoppen
die normalen Spielbedienelemente/Esc benutzen. Ein direkter Ein-Klick-Start aus dem
CraftDeja-Fenster wird in dieser Version nicht angeboten. Es werden weder CraftRecipe
noch ein nativer Button/Handler durch das Addon ausgelöst. Es gibt keine automatischen
Neuversuche. Vorherige Beta-Änderungen unten sind Verlauf, nicht der aktuelle Startweg.

## English crafting steps

Prepare 1 or Prepare all (N) selects the native recipe and exact bounded quantity.
Then physically click the highlighted Create button in the profession window.
Use Create, not Create all, to preserve the bounded quantity. CraftDeja tracks actual
cast events only; cancel a running batch through the native UI/Esc. It never invokes
the protected craft function or a scripted native click. Direct one-click crafting
from the adviser is unavailable in this version. Live validation is still pending.

## Korrektur in Beta 4

Der vorliegende Verlauf zeigt Menge 4 im Berufsfenster, aber keinen bestätigten
Craft und keinen Materialverbrauch. CraftDeja fordert die Serie nun einmal direkt
über die dokumentierte Spiel-API an und übernimmt dafür Reagenzienauswahl und
Rezeptstufe aus dem ausgewählten Berufsrezept. Der bisherige Create-Fenster-Callback
wird nicht mehr aufgerufen. Es gibt keine automatisch wiederholten Craft-Anfragen.

Bis zum ersten Cast-Ereignis steht im Aufgabenfenster nur eine Startanforderung.
Bleibt diese aus, erscheint nach fünf Sekunden eine Meldung statt einer scheinbar
laufenden Serie. Mögliche Client-Blockierungen werden protokolliert, nicht umgangen.
Der Warteschlangenplan bleibt bei vier bzw. den verbleibenden Crafts, nicht bei der
vollen geschätzten Strecke bis zum nächsten Rezept. Das Log enthält weniger Rauschen.

Bitte Alle herstellen einmal testen; falls weiterhin nichts startet, /cdj log
öffnen und den aktualisierten Text kopieren. Die Ursache für den bisherigen
UI-Callback ohne Craft-Start ist nicht abschließend bewiesen. Die lokale Prüfung
ersetzt keine Bestätigung im echten Client.

## Korrektur in Beta 3

Der per Client-Fehlermeldung bestätigte SetFont-Fehler beim Öffnen des Logs ist
korrigiert: das dritte Argument flags wird ausdrücklich gesetzt. Falls ein weiterer
Fehler im Logfenster auftritt, erscheint er direkt im Chat. /cdj version zeigt die
geladene Version. Nach dem nächsten abgebrochenen Sammelcraft /cdj log öffnen und
den Text kopieren. Der Grund für den Sammelcraft-Abbruch ist noch nicht bestätigt.

## Korrektur in Beta 2

Das Info-Symbol und /cdj log öffnen wieder das kopierbare Verlaufsfenster.
Alle herstellen wählt das Rezept im normalen Berufsfenster, setzt und prüft dort
auch die Stückzahl und nutzt die native Herstellungsfunktion samt Reagenzienauswahl.
Eine vorzeitig beendete Serie wird mit verbleibender Anzahl im Log festgehalten.
Bitte den CraftDeja-Ordner durch diese Version ersetzen und WoW neu starten.
Falls die Serie weiter nur einmal craftet: /cdj log direkt danach kopieren.

## Bei einem Hänger: Log kopieren

Das Verlaufsprotokoll ist standardmäßig an und bleibt bei /reload erhalten.
1. Den fehlerhaften Ablauf kurz wiederholen.
2. Im kleinen Nächster-Schritt-Fenster auf das Info-Symbol klicken oder /cdj log eingeben.
3. Bei Bedarf Aktualisieren, dann Markieren / Strg+C drücken und den Text im Chat einfügen.

Gespeichert werden höchstens 500 Einträge pro Charakter: gewähltes Rezept/Skillziel,
Materialmengen und Lageraufteilung, nächster Schritt, Klicks, relevante Ereignisse,
API-Ergebnisse, Kaufstatus sowie zugehörige Spiel-/Lua-Fehler. Unveränderte Zustände
werden nicht laufend neu geschrieben. Chatnachrichten und Zugangsdaten werden nicht
protokolliert. Das Fenster bietet An/Aus und Log leeren. /cdj diagnose bleibt als
zusätzliche Kaufdiagnose verfügbar. Die bisherigen Screenshot-Hänger lassen sich
rückwirkend nicht vollständig rekonstruieren; erst der neue Log erfasst die Details.

## Vorhandenes Material und Sammelherstellung

CraftDeja priorisiert den gerade empfohlenen Craft, sobald mindestens ein Versuch
mit Taschenbestand möglich ist. Ist ein Fünferplan noch nicht vollständig gedeckt,
aber es reichen Materialien für vier Crafts, werden diese zuerst angeboten.

Jetzt 1 herstellen fordert einen einzelnen Craft an. Alle herstellen (N) startet
mit einem bewussten Klick eine native Serie. N ist auf Taschenbestand und die
sichere nächste Rezept-/Skill-/Grüngrenze begrenzt. Bei Gelb/Grün kann die Serie
kleiner als die geschätzte Versuchsmenge sein: selbst bei Erfolg jedes Versuchs
soll die geplante Grenze nicht durch eine lange Warteschlange überschritten werden.
Nach Fehlschlägen kann eine weitere Serie nötig sein. Bank-/Altmaterial muss zuvor
abgeholt werden. Verzauberungen mit Zielitem bleiben im normalen Berufsfenster.

Während einer Serie erscheint Stoppen; Einzelcraft ist gesperrt. Es werden keine
Folge-Craft-Klicks simuliert. Status und Empfehlung werden nach Crafts geprüft.
Ein unterstütztes StopRecipeRepeat kann die Serie beenden; fehlt es bzw. blockiert
der Client das Abbrechen, muss im normalen Berufsfenster/Escape abgebrochen werden.
Der Startumfang ist deshalb bereits konservativ begrenzt. Der Log zeigt Requests,
Cast-Abschlüsse, Unterbrechung und geänderte Empfehlungen.

## English quick reference

Use bag stock before buying for the rest of a shopping plan. Craft 1 requests one
craft; Craft all (N) requests a native batch bounded by stock and a conservative
recipe/skill boundary. Yellow/green batches can be smaller than expected attempts.
The log is on by default and persists through reload, capped at 500 entries per
character. Reproduce the issue, open /cdj log or the Next-step Info button, select
and copy with Ctrl+C. Pause/clear controls are included. No chat/account credentials
are logged. Actual in-game behaviour still needs validation.


# CraftDeja 3.4.0-beta.4

Beta 4 korrigiert die Einkaufsbudgets und den Livepreis-Abgleich. Ein bestätigter
Kauf wird für denselben Craft-/Skill-Plan nicht erneut freigegeben. Unbestätigte
Vorgänge bleiben gesperrt. /cdj diagnose zeigt Ereignisse und Restmengen; die
Einzelheiten der Überprüfung stehen in AUDIT_EINKAUF.md. Vor dem ersten Test alte
Käufe aus der Post abholen. Angebote und Quotes ergänzen den Vollscan um Livepreise;
Preisänderungen werden neu bewertet, Käufe weiterhin per Klick bestätigt.

Beta 4 freezes purchase allowances, reserves pending confirmations, correlates
both success event forms and consumes live commodity prices. /cdj diagnose shows
recent transaction events. Collect previous purchases before testing this update.


Beta 3: Berufsfenster und AH dürfen gleichzeitig sichtbar sein. Ein tatsächliches
Öffnen des Berufs gibt das Einlesen frei; der AH-Status allein blockiert es nicht.
Fehlen Skill-/Rezeptdaten zunächst, zeigt CraftDeja den Ladezustand und liest mit
begrenzter Wiederholung weiter. Es öffnet das Fenster dabei nicht erneut.
Öffnungsereignis, Knopf und native Fenstersichtbarkeit werden abgeglichen.

Beta 3 recognizes native crafting alongside the AH, including delayed profile/
recipe data and missing show events. The task stays visible while loading. Hidden
profession panels still do not permit recipe reads at the AH.


## Korrigierter Ablauf / Corrected actions (Beta 2)

Das kleine Fenster zeigt das herzustellende Item mit Icon und geplanter Anzahl.
Wenn die Clientdaten die Ausbeute nennen, steht zusätzlich die Stückzahl oder
Stückzahlspanne dabei. Berufsfenster öffnen öffnet jetzt den tatsächlichen Beruf;
bei bekanntem nativen Rezeptlisten-Interface wird auch das Rezept ausgewählt.
Jetzt 1 herstellen startet einen gewöhnlichen Craft pro Klick, prüft zuvor die
aktuelle Empfehlung und Taschenmaterialien und berechnet nach dem Cast neu.
Verzauberkunst benötigt weiterhin ein Zielitem im normalen Berufsfenster.

AH: Suche senden -> im kleinen Fenster Kauf vorbereiten -> Angebote laden ->
Menge und Gesamtpreis prüfen -> Kaufen (Preisangebot anfordern) -> Kauf bestätigen.
Die Knöpfe führen durch diesen Ablauf; es gibt keinen unbeaufsichtigten Kauf.
Bei Preis-/Mengenänderung muss der aktualisierte Knopf erneut geprüft werden.
Preiswarnungen bleiben erhalten. Nicht unterstützte Einzelauktionen werden in
Auctionator ausgewählt und gekauft.

Erst COMMODITY_PURCHASED mit Item-ID und Stückzahl zählt als bestätigter Kauf.
Suche und Preisabfrage erzeugen KEINEN Briefkastenauftrag. Bei Teilkäufen bleibt
der Rest offen; der Aufgabenwechsel zum Briefkasten erfolgt erst, wenn die noch
fehlenden AH-Mengen durch bestätigte Käufe gedeckt sind. Ein gespeicherter Zähler
wird beim Materialeingang in die Taschen entsprechend abgebaut. Das ist kein
vollständiger Postfach-Scanner; positive Bestandsänderungen können auch aus
anderen Quellen stammen. Direkt in die Taschen gelieferte Mengen werden nicht
zusätzlich als ausstehende Post gezählt.

Next step now displays the craft icon/count and performs real native actions.
Open profession opens the game's profession; Craft 1 starts one revalidated craft
per click. Enchanting requires a target item. AH actions load the planned commodity,
show live affordable quantity/cost, request a quote, and explicitly confirm it.
Only an item-specific COMMODITY_PURCHASED event records a purchase; submitted
searches and quotes never produce a mailbox instruction. Partial purchases keep
the remaining materials in the buying phase. In-game verification is still needed.


## Automatischer Ablauf / Automatic workflow (3.4)

Das Aufgabenfenster erscheint bei jedem Öffnen von Beruf oder AH. Es bleibt bei
Rezeptwechseln und während Scans sichtbar. Das Einkaufsfenster darf geschlossen
werden, ohne die Aufgabe zu schließen. Ein ausdrücklich geschlossenes Aufgaben-
fenster wird spätestens beim nächsten Öffnen von Beruf/AH wiederhergestellt.

AH-Preise werden nach 30 Minuten automatisch erneuert, solange das AH geöffnet
ist. Ohne gültigen Scan startet CraftDeja nach dem AH-Besuch selbst einen Vollscan.
Bei geschlossenem AH wartet es bis zum nächsten Besuch. Auctionators eingestellter
Scanmodus und spielseitige Sperren werden respektiert. Offene Commodity-Kaufdialoge
haben Vorrang; bei Fehlern wird nach mindestens 60 Sekunden erneut versucht.
Nicht unterstützte Auctionator-Versionen melden den manuellen Scan als Ausweichweg.
Die bestehende Einkaufssperre gegen doppelte Postkäufe bleibt bei Auto-Scans erhalten.

Für an Auctionator übergebene CraftDeja-Pläne wird die Reagenzienmenge vorbelegt,
auch im zusätzlichen Mengen-Bestätigungsdialog von Auctionator 344. Nur passende
Items innerhalb der Restmenge und Stückpreisgrenze werden ausgefüllt. Der Kauf
braucht weiterhin einen bewussten Klick. Warnungen bei Preisänderungen bleiben
bestehen. Andere Käufe und globale Auctionator-Einstellungen werden nicht verändert.
Nach Erfolgsbestätigung wird die erlaubte Restmenge reduziert; nach AH-Schließen
oder 30 Minuten wird keine alte Mengenfreigabe wiederverwendet. Für nicht teilbare
Einzelauktionen bleibt Auctionators normales Kaufverfahren bestehen.

The task window reappears on every profession/AH opening and remains available
during scans and recipe changes. Full scans start automatically when needed and
refresh after 30 minutes while the AH is open; outside the AH they wait for the
next visit. Cooldowns, throttling, open buy panels and failure backoff are respected.
Only submitted CraftDeja commodity plans qualify for automatic quantity prefill,
including Auctionator's extra quantity confirmation. Item, remaining amount and
price limits are checked; purchase confirmation remains an explicit user click.
No unattended purchases, global setting changes or cooldown bypasses are performed.


Unten rechts an jedem Fenster ziehen, um seine Größe zu ändern. Die Skalierung
wird pro Fenster gespeichert (50-140 %). Die Hauptfenster-Tasten +/- sowie
/cdj scale 70 setzen alle Fenster gemeinsam. Der Einkaufsregler verwendet eine
violette Leiste, einen goldenen Knopf und umrahmte Endwerte 1 und 50.

Drag each window at its bottom-right corner to scale it independently (50-140%).
Per-window scales are saved. Main +/- controls or /cdj scale reset all windows.

Nächster Schritt / Next step: Das kleine Aufgabenfenster nennt konkrete Mengen und
führt zum Händler, zur Bank, zum Briefkasten oder zum Craft. Passende Händler
werden automatisch markiert, soweit unterstützt; sonst stehen Koordinaten bereit.
Die Aufgabe bleibt unterwegs sichtbar und aktualisiert sich mit dem Bestand.
Skillbereiche und ihre Zahlen sind passend eingefärbt.

## Goblin UI und Händlerkauf / Goblin UI and vendor buying

Alle Fenster haben runde Konturen im Goblin-Logo-Stil. Buch (violett) öffnet
Rezepte, Tasche (mint) Materialien, Zahnrad Optionen, Münze (gold) den AH-Einkauf.
Der Einkauf ist kompakter: Materialsymbole zeigen vorhanden/benötigt. Beim
Darüberfahren erscheinen Lagerorte, Zeitstempel, Händler und Preisregeln.
Status: Grün = gedeckt, Blau = Bank, Gold = Händler, Rot = fehlend.
Weitere Materialien sind mit den Pfeilen erreichbar; die vollständige Textliste
bleibt unter Material verfügbar. Nicht unterstützte Schriftzeichen werden ersetzt.

Beim Öffnen eines passenden normalen Händlers erscheint das neue Kauf-Popup.
Beruf vorher einmal öffnen. Es verwendet dasselbe gewünschte Skillziel wie der
AH-Einkauf; +/- ändert es. Ein Material auswählen, Paketmenge und Gesamtpreis prüfen
und den Kaufknopf drücken. Je Klick wird höchstens ein Stapel gekauft. Pakete werden
aufgerundet: 6 fehlende Phiolen bei 5er-Paketen bedeuten 10 gekaufte Phiolen.
Aktuelle Preise, Gold und Bestand werden vor dem Kauf erneut geprüft. Danach bleibt
der Knopf bis zur Bestandsbestätigung gesperrt. Bei ausbleibender Antwort nach
5 Sekunden nur nach eigener Prüfung mit Aktualisieren erneut versuchen.
Keine automatischen Folgekaufe; limitierte Angebote, Währungen und teurere Händler
als bekannte AH-Angebote werden ausgeschlossen. Schließen wird respektiert.

Der Kartenknopf setzt zusätzlich einen großen CraftDeja-Logo-Pin auf unterstützten
Weltkarten. Native Wegpunktführung bleibt erhalten; das eigene Logo ist kein neuer
Minimap-Pin. Maus darüber zeigt den Händler; Strg-Klick entfernt nur das eigene Logo.

Rounded Goblin-themed windows and distinct action icons replace the plain skin.
Shopping uses item cards with owned/required counts and detailed hover tooltips.
A matching vendor opens a purchase popup: select a material, inspect bundle-rounded
quantity and price, then click to buy at most one stack. Prices and money are
revalidated; another purchase waits for bag confirmation. A manual refresh is
available after a timeout. No unattended purchases. Limited/currency offers and
vendors above a known AH quote are excluded. A large logo marker supplements the
native waypoint on supported world-map canvases; the custom logo is not a minimap pin.


Ein neu geschriebenes, mehrsprachiges Berufs-Addon für **WoW Forever, Interface 16001**.
A freshly written profession adviser for **WoW Forever, interface 16001**.

**Voraussetzung / Requirement:** Auctionator oder TradeSkillMaster mit AH-Preisdaten
für Preisvergleiche. **Der neue AH-Einkauf benötigt Auctionator** mit
`MultiSearchAdvanced` und unterstützten Vollscan-Ereignissen. TSM allein öffnet
den Einkaufsbereich nicht. / Shopping specifically requires Auctionator.

**Beta:** Die neue Einkaufsfunktion wurde mit simulierten WoW-APIs und gegen
die öffentliche Suchschnittstelle von Auctionator 345 geprüft. Ihr Verhalten
im laufenden Forever-Client muss noch getestet werden. Kein getestetes Retail-/TBC-Addon.

## Installation / Installation

1. WoW beenden. Den bisherigen Ordner `Interface/AddOns/EntchantingDeja` bzw. `CraftDeja` sichern
   und aus AddOns heraus verschieben; nicht über alte Dateien entpacken.
2. Den Ordner `CraftDeja` aus dieser ZIP nach `Interface/AddOns/` entpacken.
   Die Datei `CraftDeja.toc` muss direkt darin liegen.
3. Das frühere `ForeverProfessionCapper` deaktivieren, falls noch installiert.
4. Addon aktivieren. Auctionator oder TradeSkillMaster mit einem aktuellen,
   tatsächlich verfügbaren AH-Preisbestand verwenden. Den gewünschten Beruf zuerst einmal öffnen.
5. Bei Alchemie auch den Reagenzienhändler öffnen: echte Einkaufspreise für Phiolen
   werden gespeichert. Fehlende Preise werden nicht durch Verkaufspreise ersetzt.

Quit WoW, back up and move the previous EntchantingDeja/CraftDeja folder outside AddOns,
then install this ZIP's CraftDeja folder. Disable ForeverProfessionCapper.
Open a crafting profession and use Auctionator or TSM with populated prices.
Open a reagent vendor to record vial purchase prices. This version uses its own
`CraftDejaDB`; previous versions' saved settings are not imported or erased.

## Berufe / Professions

| Beruf / Profession | Referenzrezepte / Reference recipes |
| --- | ---: |
| Verzauberkunst / Enchanting | 262 |
| Alchemie / Alchemy | 195 |
| Schmiedekunst / Blacksmithing | 512 |
| Lederverarbeitung / Leatherworking | 603 |
| Schneiderei / Tailoring | 477 |
| Ingenieurskunst / Engineering | 275 |
| Kochkunst / Cooking | 133 |
| Erste Hilfe / First Aid | 33 |
| Bergbau: Verhüttung / Mining: Smelting | 18 |

**2.508 Katalogeinträge** für diese neun Herstellungsbereiche; das ist kein
Nachweis, dass alle im aktuellen Forever-Build erhältlich sind. Bekannte Rezepte,
verfügbare ungelernte Rezepte und im Client ungeprüfte Katalogeinträge werden
getrennt behandelt. Zusätzliche Rezepte aus dem geöffneten Client werden ebenfalls
eingelesen. Sammeln, Angeln und reine Entzauberung haben keinen Craft-Plan.

**2,508 reference records**, not a guarantee of current availability. Only recipes
confirmed by the open client enter recommendations. Live-only recipes are included.
Gathering, fishing and disenchanting are not crafting routes.

## Erste Schritte direkt im Spiel / In-game quick start

Beim ersten Login nach Installation dieses Updates öffnet sich der Leitfaden
auf der ersten Seite des CraftDeja-Hauptfensters. Fünf Schritte erklären Beruf,
Preisquellen, Vollscan, Rezeptberatung, Skillziel, Materialien und Kaufbestätigung.
**Verstanden · Berater öffnen** wechselt zum normalen Berater und merkt sich die
Auswahl über weitere Logins hinweg. Der Button **Leitfaden** oben rechts sowie
`/cdj help` oder `/cdj guide` öffnen die Anleitung jederzeit erneut. Die bestehende
Skalierung gilt auch für diese Startseite. Deutsch und Englisch werden unterstützt.

On the first login after installing this update, CraftDeja shows a five-step guide
inside its main window. **Got it · Open adviser** saves completion for later logins.
Use **Guide**, `/cdj help` or `/cdj guide` to reopen it anytime. The guide follows
your selected language and window scale.

## Bedienung / Controls

- `/cdj` oder `/craftdeja` – Fenster ein-/ausblenden / toggle adviser.
- `/edj` funktioniert weiterhin als Alias / remains a compatibility alias.
- `/cdj recipes` – durchsuchbarer Katalog; Berufsbutton durchschalten / catalogue.
- `/cdj materials` – Materialbedarf des empfohlenen Rezepts / shopping estimate.
- `/cdj shopping` – AH-Einkauf nach erfolgreichem Vollscan / shopping after a full scan.
- `/cdj options` – Sprache, Preisquelle und grüne Fortsetzung / settings.
- `/cdj scale 70` – alle Fenster auf 70 % / scale all windows to 70% (50–140%).
- `/cdj lang de`, `/cdj lang en`, `/cdj lang auto` – Sprache / language.
- `/cdj source auto`, `auctionator` oder `tsm` – Preisquelle / price provider.
- `/cdj refresh` – geöffneten Beruf neu einlesen / rescan open profession.

Titelbereich ziehen zum Verschieben. Die Buttons −/+ skalieren alle Fenster.
Der geschlossene Berater öffnet sich erst beim erneuten Öffnen des Berufs oder
mit `/cdj` wieder. Rezept anklicken für Herkunft, Farbgrenzen, Reagenzien und einen
markierbaren Wowhead-Link. Im Katalog sind Rezepte anderer Berufe auch ohne
geöffnetes Berufsfenster lesbar. Für Live-Rezepte den Beruf zuerst öffnen; am AH
verwendet CraftDeja den zuletzt vollständig eingelesenen Beruf dieser Sitzung.

Drag the title area to move. The −/+ buttons scale every window. Click a catalogue
recipe for source, colour limits, materials and a copyable Wowhead URL. Game item
names and source NPC names can follow the client/reference language; static recipe
names and all interface text have German and English versions. Matching game-language
recipe names from the live client take precedence over older reference names.

## Kostenrechnung / Cost model

Stand: 2026-11-14, 3.9.0-beta.9; src/Economy.lua und src/Run.lua sind die Referenz.

Die Auswahl vergleicht Materialkosten / (geschätzte Skillchance × Skillpunkte je erfolgreichem Craft).
Verkaufserlöse, Rezeptkauf, Trainergebühren, Reise und Werkzeugbeschaffung sind noch nicht Teil der wirtschaftlichen Rangfolge.
Werkzeug-/Rutenaufgaben im Guide sind von einer vollständigen Einrechnung ihrer Erwerbskosten zu unterscheiden.

Orange wird mit 100 % modelliert; Gelb/Grün verwendet bei brauchbaren Grenzen
p = (Grau − Skill) / (Grau − Gelb), begrenzt auf 0–1. Das ist eine nicht abschließend für Forever validierte Modellannahme.
Bei fehlenden oder widersprüchlichen Grenzen gelten konservative Regeln; unbekannte Preise sind nicht kostenlos.
Grün ist in den aktuellen Standardoptionen aktiviert, kann aber durch gespeicherte Optionen deaktiviert sein.
Der aktuelle Code hat keine pauschale Fünf-Punkte-Grenze ab Grün. Er plant bis zu wirtschaftlichem Wechsel,
Lernschritt, Rezeptgrenze oder Skilllimit, soweit Daten und Voraussetzungen den Vergleich erlauben.

Skill-/Materialereignisse aktualisieren den Guide. Während nativer Craft-Serien werden nur benötigte
Fortschrittsdaten aktualisiert; vollständige Rezept-/Markt-/Inventurarbeiten werden bis Ende/Abbruch verschoben.
Es gibt keine dauernde Live-AH-Abfrage. Ein technischer Haltepunkt nahe einem Rezeptwechsel kann eine kleine
vorbereitete Serie ergeben, obwohl die geschätzte Versuchszahl höher ist.

English: candidates are ranked by material cost per expected skill point. Resale, learning and tool acquisition
costs are not included in that ranking. Yellow/green probabilities remain estimates. Full background work is
deferred during a native batch. This is not a demonstrated globally optimal complete 1–300 route.

## Materialplanung / Shopping estimates

Mengen werden pro zukünftiger Skillstufe summiert und auf ganze Crafts aufgerundet;
Taschen- und Bankbestand werden, soweit lesbar, abgezogen. Das Ziel ist auf den
nächsten Entscheidungspunkt und den aktuellen Berufsrang begrenzt. Der Plan enthält
keinen Sicherheitsaufschlag. Zufall kann mehr oder weniger Versuche erfordern.
Bei Rezepten mit mehreren Skillpunkten ist die Erwartungswertberechnung ebenfalls
eine Näherung. Mehrere zulässige Pflichtreagenzien werden nach dem günstigsten
bepreisten Ersatz ausgewählt; optionale Reagenzien sind nicht Teil des Plans.

Expected attempts are summed by skill level, rounded up, and owned bag/bank
materials deducted when available. No safety buffer or guaranteed success count.
Multiple-point crafts use an approximation. The planner chooses the cheapest
priced allowed mandatory reagent; optional reagents are excluded.


## Berufsfenster und AH / Crafting window and AH

Das Spiel kann das normale Berufsfenster beim Öffnen des Auktionshauses schließen.
CraftDeja bleibt als eigenständiges Fenster erhalten und hält den zuletzt vollständig
eingelesenen Beruf samt Skill, Rezepten und Reagenzien im Speicher dieser Sitzung.
**Beruf vorgemerkt** kennzeichnet diesen Zustand. Ein gleichzeitiges Öffnen beider
Blizzard-Fenster ist für den Einkauf nicht nötig. CraftDeja öffnet das Berufsfenster
am AH nicht automatisch und liest dort keine leeren/veralteten Rezeptlisten ein.

Ablauf: **Beruf einmal öffnen → Berufsfenster schließen → AH öffnen → Auctionator-
Vollscan → Skillziel wählen → Suche übergeben → Käufe in Auctionator bestätigen.**
Bei Bedarf `/cdj` verwenden, um ein manuell geschlossenes CraftDeja wieder zu öffnen.
Nach einem Reload/Login den Beruf erneut einlesen. Beim Öffnen eines anderen Berufs
wird der vorgemerkte Beruf durch den neuen gültigen Stand ersetzt.

The game's crafting panel may close when the AH opens. CraftDeja stays independent
and uses the last fully read profession for shopping. Open your profession once,
then close it and open the AH. A successful Auctionator full scan unlocks shopping.
CraftDeja never reopens the native crafting panel at the AH. Its own manual close
is respected; `/cdj` reopens it. The snapshot lasts for this login session.

## AH-Einkauf / AH shopping — neu in 3.1

1. Den gewünschten Beruf öffnen, damit Skill und erlernte Rezepte eingelesen werden.
2. Zum Auktionshaus gehen und das AH offen lassen: CraftDeja startet den Auctionator-Vollscan automatisch.
3. Erst nach erfolgreicher Verarbeitung öffnet CraftDeja den Einkauf automatisch.
   Alternativ danach **AH-Einkauf** oder `/cdj shopping` verwenden.
4. Mit dem Regler **1–50 Skillpunkte** wählen. Angezeigt werden tatsächliches
   Ziel, geschätzte Crafts sowie benötigte, vorhandene und fehlende Materialien.
   Ein früherer Rezeptwechsel, Berufsrang oder die Grün-Grenze begrenzt das Ziel;
   die bestehende Ausnahme erlaubt höchstens fünf Punkte ab fester Grün-Grenze.
5. Stückpreisgrenze wählen: Scanpreis +0 / +5 / +10 / +20 %, Standard +10 %.
   **Material in Auctionator suchen & kaufen** übergibt exakte Namen, Fehlmengen
   und Stückpreisgrenzen an Auctionator. Dort aktuelle Angebote prüfen und Käufe
   bestätigen. CraftDeja klickt keine Kaufbestätigungen automatisch.
6. Käufe aus der Post abholen. Die Liste wird nach Übergabe gegen versehentliches
   erneutes Suchen gesperrt. **Weitere Suche erlauben** entsperrt ausdrücklich;
   Postbestand wird nicht als automatisch bekannt vorausgesetzt.

Beide vollständigen Auctionator-Scanverfahren werden unterstützt: Replicate/Get-All
und Summary/Browse (auch Auctionator 344). Auf einfache Preisupdates wird nicht
freigeschaltet. Bei Klick auf AH-Einkauf stehen Warte-, Fehler- und Bereitmeldungen
direkt im Hinweisbereich des Hauptfensters.

Ein erfolgreich abgeschlossener Vollscan ist **30 Minuten ab Abschluss** gültig.
Schließen und erneutes Öffnen des AH behalten den Scan, seine ursprüngliche Uhrzeit
und die Sperre gegen versehentlichen Doppeleinkauf. Ein erneuter AH-Besuch setzt
die 30 Minuten nicht zurück. Nach Ablauf ist ein neuer erfolgreicher Scan nötig.
Reload/Login setzt den nur im Arbeitsspeicher gehaltenen Scan zurück. Ein neu
begonnener, anschließend abgebrochener Scan schaltet den Einkauf nicht frei.
Spielseitige Scan-Abklingzeiten werden nicht umgangen.

Für diesen Einkauf werden Preise aus genau diesem Vollscan verwendet, auch bei
sonst ausgewählter TSM-Preisquelle. Fehlt ein Material im Scan, wird kein alter
AH-/TSM-Preis als frisches Angebot ausgegeben. Beobachtete Händlerpreise und Referenzpreise
für 36 gewöhnliche Händlerreagenzien werden zum Vergleich herangezogen; diese Materialien gehen nicht in die
AH-Suche. Die Summe mit Suchgrenzen gilt für die Planmenge, nicht als garantierter
Gesamtpreis: Angebote können verschwinden, Mengen fehlen oder ganze Stapel nötig
sein. Keine Reservierung, keine garantierte Verfügbarkeit und kein automatischer
Kauf eines Ersatzrezepts bei Preisänderungen. Bei stark veränderten Preisen neu
scannen, damit Rezeptvergleich und Mengen erneut berechnet werden.

Gelbe/grüne Skillchancen und damit Einkaufsmengen bleiben Erwartungswerte. Ein
unlesbarer Bestand sperrt die Suchübergabe. Wenn eine Craft-Warteschlange nach dem Schließen des Berufs noch einen bekannten
Craft abschließt, wird der vorgemerkte Stand gesperrt. Dann AH schließen und den
Beruf vor dem Einkauf neu einlesen. Allgemeine Skill-Update-Meldungen allein
verwerfen den vorgemerkten Beruf nicht.

Open your profession first, then open the AH and complete an Auctionator Full Scan.
The shopping panel opens only after successful processing. Choose 1–50 desired
skill points; the actual target is capped at the next decision/rank/green limit.
Choose a per-item ceiling (scan +0/5/10/20%) and send the missing quantities to
Auctionator. Review live offers and confirm purchases there. Vendor-recommended
materials are excluded. Collect purchased mail before another search; explicit
unlock is available. A successful full scan stays valid for 30 minutes from completion, including
after closing/reopening the AH in the same login session. Reload clears it.
Starting an interrupted new scan does not unlock shopping. Unknown
inventory blocks handoff. TSM alone supports adviser pricing, not this shopping
integration. Yellow/green quantities and the shown total remain estimates.

The full-scan hook is an Auctionator internal integration and may change between
versions. Unsupported events/payloads fail closed; generic DB-update callbacks
never unlock buying. Auctionator code is not bundled or modified.

## Fraktionsfilter und Quellenlinks / Factions and source links

CraftDeja erkennt Allianz/Horde über den Charakter. Der Katalog startet mit
„Meine Fraktion“; „Alle Fraktionen“ zeigt auch die anderen Bezugsquellen.
Aktuelles UND nächstes Rezept besitzen jetzt jeweils **Details / Link**.
In den Rezeptdetails schalten **Rezeptseite**, **Herstellung** und **Quelle**
zwischen den passenden Wowhead-Adressen um. Mehrfach auf Quelle klicken, um
NPCs und Quests zu wechseln. Der Link bleibt zum Kopieren markierbar. Wenn
vorhanden, werden Questgeber, Karte und Koordinaten ebenfalls angezeigt.

Alle 2.508 Katalogeinträge haben einen Prüfstatus. Für 1.743 ließ sich eine
Bezugsfraktion zuordnen; 765 bleiben ungeklärt. Solche ungelernte Rezepte werden
standardmäßig nicht zum Lernen empfohlen. Die Option „Rezepte mit ungeprüfter
Quellfraktion einschließen“ kann sie wieder zulassen; bekannte gegnerische Quellen
bleiben dabei ausgeschlossen. Quellen aus ergänzenden Referenzdaten bleiben als
unbestätigt markiert. Fraktionszuordnung ist keine Garantie für Ruf-, Quest-,
Klassen-, Stufen-, Saison- oder Spezialisierungsvoraussetzungen.

Eine Allianzquest ist keine automatische Benutzungssperre für ein handelbares
Rezept: Ein bereits erlerntes, vom Client benutzbares Rezept darf weiter gewählt
werden. Für den Lernvorschlag wird aber kein Handel mit der Gegenseite vorausgesetzt.
Kaldorei-Spinnenkebab ist jetzt der Allianzquest 4161 bei Zarrin zugeordnet und
wird einem Hordecharakter nicht mehr zum Lernen empfohlen.

The adviser detects the character's faction. Current and next recipes each have
a Details / link button. Recipe details offer separate recipe-item, crafting-spell
and cycling NPC/quest URLs. Friendly sources are listed first; coordinates are
shown where available. The catalogue's faction switch does not change the
recommendation rules. Unknown source factions are excluded from learning hints
by default. Learned tradeable recipes remain usable across source factions.
See FACTION_AUDIT.md for coverage, evidence and limitations.

## Daten und Veröffentlichung / Data and redistribution

Die Anwendungsmodule wurden für Version 3 neu geschrieben. Code von
ForeverProfessionCapper wird nicht mitgeliefert. Die Referenzdaten basieren auf
LibProfessionDB (MIT), mit separat abgeglichenen Verzauberkunst-Fakten. Das Paket
benötigt weder LibProfessionDB noch Ace3 oder VersionCheck als Laufzeit-Addon.
Ergänzende Fraktions- und Quellenfakten stammen aus der MIT-lizenzierten
Forever-Datenbank von AllTheThings; kein ATT-Laufzeitcode wird benötigt.
Details, Datenlücken, Abgleichregeln und Lizenzen: [DATA_SOURCES.md](DATA_SOURCES.md).

The newly authored code is MIT licensed. Derived data retains upstream attribution.
Keep LICENSE, DATA_SOURCES.md and Licenses/ with redistributions. This is not a
formal clean-room legal certification or a guarantee of CurseForge acceptance.
Check the current project's submission rules and select WoW Forever's supported
client/game version when preparing a release.

## Prüfungen / Tests

`lua Tests/spec.lua` aus dem Addon-Ordner ausführen (Lua 5.1+).
Die Tests ersetzen keine Spielprüfung. Sie prüfen unter anderem Gelb/Orange,
Grün-Grenze, frühzeitigen Wechsel, Preise, Live-Reagenzien, Cooldowns, Deutsch/Englisch,
Berufswechsel, Skalierung und Craft-Ereignisse. Keine Testdatei wird im Spiel geladen.


## Normale Händlerreagenzien / Ordinary vendor reagents

Für 36 übliche Verbrauchsreagenzien (u. a. Phiolen, Garne, Farbstoffe, Gewürze,
Flussmittel, Kohle und Holz) stehen Händlerreferenzen schon vor dem ersten
Händlerbesuch bereit. Grundlage sind unlimitierte, reine Goldangebote mit zur
Fraktion passenden Reaktionen. Bündelpreise werden auf ein Stück umgerechnet.
Ein im Spiel beobachteter, nicht limitierter Einkaufspreis hat Vorrang. Aktuell
als limitiert erkannte Händlerangebote werden nicht als unbegrenzte Versorgung
angenommen. Referenzen sind keine Garantie für den nächsten NPC, seinen Rufrabatt,
Reiseweg oder Bestand; der tatsächliche Händlerbesuch verbessert den Vergleich.

Händler günstiger oder gleich teuer → getrennte Händlerliste. AH günstiger →
AH-Suche, deren Preisgrenze auch mit prozentualem Aufschlag strikt unter dem
Händlervergleichspreis bleibt. Händlerpreise sind Einkaufspreise, keine aus dem
Verkaufserlös hochgerechneten Werte. Weitere normale, unlimitierte Goldangebote
werden beim Händlerbesuch gespeichert. Es werden keine seltenen/limitierten
Händlerwaren pauschal als überall verfügbare normale Reagenzien eingestuft.

Die Vorschau und die Übergabemeldung zählen AH-, Händler- und vollständig durch
Bestand gedeckte Materialarten. Gesucht werden nur Fehlmengen. Beispielsweise
reichen 11 Silberblatt und 7 Friedensblume für fünf Crafts mit je einem davon;
diese Kräuter werden dann zu Recht nicht nachgekauft. Alle tatsächlich fehlenden
AH-Reagenzien werden gemeinsam übergeben.

36 faction-aware ordinary-reagent vendor references work without a prior vendor
visit. Unlimited gold-only bundle offers are normalised per item; observed
unlimited purchase prices override references. Equal or cheaper vendor reagents
are excluded from AH shopping. Cheaper AH alternatives are allowed with ceilings
strictly below the vendor comparison even with tolerance. Reference prices can
vary by NPC/reputation. Only missing quantities are searched; the UI explains
AH/vendor/already-owned categories. See VENDOR_REFERENCE.md for provenance.


## Lagerorte und Charaktere / Storage and characters — 3.2

Im Einkauf stehen pro Material der Bedarf, die Fehlmenge und die Lagerorte:
**Taschen**, **persönliche Bank**, **Accountbank** und **gespeicherte Alt-Bestände**.
Grüne Hinweise nennen die Menge, die vor dem Craften aus der Bank geholt bzw.
von Alts übertragen werden muss. Der Materialbereich scrollt bei langen Listen.

Einrichtung: Jeden gewünschten Charakter mit aktiviertem CraftDeja einmal einloggen
und seine Bank öffnen. Taschen werden beim Login sowie nach Bestandsänderungen
aktualisiert; Bankbestände werden über verfügbare Client-Zählungen und Bankbesuche
gespeichert. Unbekannt ist keine Null: eine noch nicht erfasste Bank wird als
unbekannt angezeigt. Die Daten liegen in CraftDejaDB und bleiben bei Logout/Reload
bestehen. Sie gelten für dieses WoW-Konto/SavedVariables-Verzeichnis. Andere,
nie eingeloggte Charaktere können nicht abgefragt werden. Materialbestände aus
Post und Gildenbank werden nicht mitgezählt.

Alt-Daten sind ausdrücklich **gespeicherte Momentaufnahmen mit Zeitangabe**. Ein
Charakter muss nach Änderungen erneut mit aktiviertem Addon eingeloggt werden.
Die Anzeige umfasst gespeicherte Charaktere desselben Realms. **Alt-Bestände: nur
anzeigen** ist der Standard; per Button kann man sie für die Planung anrechnen.
Dabei zählen nur gleichfraktionige Charaktere und vom Client als ungebunden
bestätigte Items. Unbekannte Bindung bzw. andere Fraktion bleibt Anzeige. Der
Accountbankbestand wird zentral gehalten und genau einmal angerechnet; er wird
nicht in jede persönliche Alt-Bank kopiert. Keine automatische Post/Übertragung.

The shopping view separates bags, personal bank, account bank and timestamped alt
snapshots. Log in every desired alt and open its bank once. Current-client counts
and inventory/bank events update saved data. Unknown bank counts remain unknown.
Alt stock is display-only by default; optional deduction only includes confirmed
unbound items on same-realm/same-faction characters. Shared bank counts once.
Mail/guild bank are excluded. Saved alt data is not a live query of offline alts.

## Händler in der Nähe und Kartenpunkte / Nearby vendors and map points

**Händler in der Nähe / Karte** zeigt passende Lieferanten für fehlende normale
Händlerreagenzien, deren Gebiet und Koordinaten. Für 164 NPCs sind Referenzpositionen
hinterlegt. Quellen: die bereits MIT-lizenzierten AllTheThings-Camelot-Ortsdaten,
verbunden mit den Forever-Händlerangeboten der normalen Reagenzien. Nicht jeder
Händler ist erfasst, und Referenzpositionen können sich im aktuellen Build ändern.

Passende Händler auf der aktuellen Karte werden bevorzugt und dort nach relativer
Kartendistanz sortiert. Das ist kein berechneter Laufweg. Ohne passenden Händler
auf der aktuellen Karte werden bekannte passende Orte anderer Gebiete angeboten.
Ein lokaler Chat-Hinweis erscheint bei einem nahegelegenen passenden Händler;
Wiederholungen pro Händler sind auf fünf Minuten begrenzt. Keine Sprachausgabe und
keine Nachricht an andere Spieler. Beim tatsächlichen Händlerbesuch werden Name,
NPC-ID, normale unlimitierte Goldangebote und die Spielerposition beim Gespräch
als genauerer besuchter Referenzstand gespeichert.

**Kartenpunkt** setzt einen nativen Benutzer-Wegpunkt und aktiviert dessen Tracking,
soweit die Client-Funktionen und die Zielkarte es unterstützen. Die Weltkarte wird
nicht automatisch geöffnet, sodass das AH bestehen bleiben kann. Karte anschließend
selbst öffnen. Ohne Unterstützung werden Name und Koordinaten weiterhin angezeigt.
Ein gesetzter Punkt ersetzt den bisherigen Benutzer-Wegpunkt. Er garantiert keine
aktuelle Warenverfügbarkeit, Erreichbarkeit, Rabattstufe oder Position.

Nearby vendors / map offers supplier names, zones and coordinates, with native
waypoint support when available. Compatible suppliers on the current map are
ranked by map-relative distance; this is not pathfinding. Local notices are throttled.
Reference data may differ from the live game. Real vendor visits record nearby
player coordinates and current ordinary offers. The world map is not forced open.
