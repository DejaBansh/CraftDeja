# beta.23 — Goblin-Werkstattpult

## Tatsächlicher Ausgangsstand

Sauberer Branch codex/trainer-navigation, Commit 3dffca8b722821e8d289772f8097a3b42c37ab24. Neue Arbeit auf codex/workshop-dashboard. Der Nutzer gab die Designreferenz als Beschreibung, kein zusätzliches Dashboard-Referenzbild. Grundlage bleiben die vorhandenen Auftragsmodelle und der tatsächliche beta.22-Code.

Das alte Hauptfenster aus Screen.lua wird von UnifiedUI.lua absichtlich ausgeblendet. Einstellungen, Rezeptdetails und Auftragswahl werden in den Rahmen des NextStep-Guides eingebettet. RouteUI.lua öffnete daneben ein eigenes langes Fenster mit allen Routen-/Gilden-/Twink-Eingaben. Diese Beziehungen wurden geprüft; die Überarbeitung verwendet dieselben Instanzen und erhält deren Aktionen.

## Neues Layout und Bedienung

- **Großes Werkstattpult / Levelroute:** bestehendes CraftDejaRoute-Fenster mit linker Navigation, Beruf/Skillfortschritt ab Auftragsbeginn, auswählbaren Rezeptabschnitten, rechter aktueller Aktion und Schrittdetails sowie Kostenkarte. Öffnen mit `/cdj dashboard`, `/cdj werkstatt`, der Routenfunktion oder dem Buchsymbol im Guidekopf. Der kleine Minimap-Zugang bleibt wie zuvor für den Guide nutzbar.
- **Materialien:** vorhandene Materialanforderungen, aktuelle Bestandsdaten und aktuelle Preis-API. Fehlende Daten bleiben unbekannt. Aus Materialbewegungen werden keine Käufe oder Herstellungen erfunden. Ein Materialtab-Klick darf einmal den bestehenden Materialplan anfordern; reine Neudarstellung erzeugt keinen neuen Routenvergleich oder Rezeptscan. Während einer nativen Serie bleibt die schwere Planung gesperrt; bestätigte verbleibende Craftmengen werden projiziert.
- **Einstellungen:** gespeicherte Anzeigeoptionen direkt erreichbar; vollständige Einstellungen, Referenz und Hilfe verwenden die bestehenden Ansichten.
- **Auftrag & Angebote:** alle bisherigen Ziel-/Plan-/Abbruch-/Preis-/Lehrer-/Gilden-/Twink-/Zahlungs-/Übergabefunktionen bleiben mit ihren unveränderten Skripten in einer scrollbaren Detailseite erhalten. Route planen führt bewusst dorthin. Konfigurationsaktionen für Gilden-/Twink-Aufträge wählen diese Seite gezielt an.
- **Kompakter Guide:** allein verständlich, primäre konkrete Aktion plus sichtbarer Status/Fehlgrund, namentliche Werkzeuge, Preise im Kaufbutton und Mengen im Status. Auftragsübersicht, weitere Hinweise, Gilden-AH-Ausweichweg und Bankaufschub sind aufklappbar. Der Bankaufschub kann die offene Restmenge nicht mehr überdecken. Werkstatt schließen lässt den Guide verwendbar; „Kompakten Guide öffnen“ wechselt zur kleinen Ansicht.
- **Aktionen:** gleiche echte Guide-Schaltfläche und gleiche Bestätigungslogik. Vor einem Dashboard-Klick wird die Aktion aktualisiert. Hat sich Identität, Menge oder Preis geändert, wird die aktualisierte Aktion angezeigt; der alte Klick löst keine andere Handlung aus. Kein automatischer Kauf, Lernklick, Whisper oder native Craft-Start durch das Design.

## Grafiken und Licht

Vier eigens mit Imagegen erstellte Einzelgrafiken, keine texttragenden Mockups: WorkshopCard, WorkshopLogoFrame, WorkshopGoblin und WorkshopAction. Unverändertes bisheriges CraftDeja-Logo in neuer Fassung; neues Goblin-Werkstattmotiv separat am Kopfbereich. Hochauflösende transparente PNG-Quellen in docs/assets/workshop, RGBA32-TGA in Art. Kartenrahmen als neun Teilflächen, damit Ecken/Nieten bei anderer Fenstergröße erhalten bleiben.

Export: `powershell.exe -NoProfile -ExecutionPolicy Bypass -File tools/Export-WorkshopTextures.ps1`. Das Skript delegiert bei PowerShell Core an vorhandenes Windows PowerShell für System.Drawing; es installiert nichts. Unterstützte Potenz-von-zwei-Größen: Karte 2048×1024, Aktionsbutton 2048×512, Logo-Fassung und Goblin 1024×1024. Transparenz bleibt erhalten. Text, Preise, Mengen und Status sind echte FontStrings/EditBox-/Button-Elemente.

Hauptaktion mit eigenem grünen Rahmen, sichtbaren Hover-/Druckzuständen und einer einmaligen weichen Alpha-Animation (0.22s Aufhellen + 0.65s Abklingen). Keine Endlosschleife und kein neuer dauerhafter OnUpdate. Nur bei einer neuen bereiten sichtbaren Aktion; Wiederholungsrender startet den Impuls nicht erneut. Verstecken stoppt die Animation. Laufende Verarbeitung, volle Bank/Taschen, offene Bestätigung und fehlende Voraussetzungen bleiben optisch ruhig; die Schaltfläche kann zur zulässigen manuellen Prüfung weiter anklickbar sein.

## Automatisierte Abnahme

WorkshopSuite simuliert ausschließlich Client-/Inventar-/Waren-/native UI-Grenzen. Die tatsächlichen CraftDeja-Module prüfen einen zusammenhängenden Auftrag: bestätigter Händlerkauf → Bankeinlagerung mit sieben behalten/eins einlagern → native Craft-Vorbereitung und vom simulierten Spieler gestartete Serie → spätere Entnahme → zweite Herstellung → Zielabschluss im selben Auftrag. Dazu UI-Projektionen für AH/Bestätigung/Warten/Post/Trainer/Rang/Twink/Gilde, volle Bank, unbekannter Preis, aktuelle Materialmengen/Preise ohne Neuplanung, sichtbare veraltete Klicks und einmalige/gestoppte Animation.

Bestehende Regressionen bleiben maßgeblich. Auftragsfortschritt wird jetzt durch Aufklappen geprüft; konkrete Fehler werden direkt in der neuen sichtbaren Statuszeile geprüft. Frühere Zwischenberichte mit Überlappungen, fehlenden Werkzeugnamen oder Test-Callback-Lecks sind keine Freigaben. Abschließenden Gesamtstand ausschließlich TEST_RESULTS.md und den passenden Quellprüfsummen entnehmen.

Die Auflösungsmatrix verwendet echte `test.screen`-Manifeste aus dem offiziellen wowlua-Schema: 1920×1080 und 3440×1440, jeweils dpiScale=1 und uiScale=0.65/1.00. Keine bloß vergrößerten Bilder. Jeder Fall verwendet identische Runtime-/Texturquellen und erzeugt eigenen automatischen Test-/JSON-/Screenshot-ZIP. Reproduzieren: tools/New-WorkshopScreens.ps1. Primärquelle zum Bildschirmvertrag: https://github.com/DomenikIrrgang/wowlua/blob/main/schema/wowlua-0.1.json.

Alle gelieferten Ansichten sind **wowlua/Camelot-Quellemulation mit kontrollierten Testdaten, keine Screenshots aus dem Live-Client**. Referenzpreise und einige Itemnamen stammen aus Fixtures; sie sind keine aktuellen Marktdaten. Die bestehenden Bank-, Preis-, Kauf-, Inventar-, Trainer-, Alt- und Gildenregressionen prüfen weiterhin die jeweiligen Geschäftsabläufe. Keine FPS-Verbesserung durch das Design behauptet.

## Kurzer Live-Test

1. Nach verifizierter Release-Installation `/cdj version`, anschließend `/cdj dashboard`. Beruf, gespeicherten Auftrag, Rezeptwechsel und ausgewählte Details kontrollieren.
2. Route/Materialien/Einstellungen wechseln; echte Bestände und Preise vergleichen. Auftrag & Angebote mit Zieländerung, Gilden-/Twink-Aktion und Übergabe bei Bedarf prüfen.
3. Über die linke Guide-Schaltfläche zur kleinen Ansicht wechseln. Händler/AH/Briefkasten/Bank/Lehrer und Craft-Vorbereitung im bestehenden Auftrag durchgehen. Kauf-/Lernbestätigungen und nativen Herstellknopf weiterhin selbst drücken.
4. Volle Bank/fehlendes Werkzeug/laufende Verarbeitung: konkreter Grund sichtbar, ruhiger Button, Details öffnen/schließen ohne Überdeckung. Neue bereite Aktion: ein kurzer Impuls, kein wiederholtes Blinken im Leerlauf.
5. Spielauflösung 1920×1080 bzw. 3440×1440 und eigene UI-Skalierung testen, lange deutsche Namen/Tooltips, verschobene Fenster und andere UI-Addons prüfen. DE/EN wechseln. Die echte Grafik-/Skalierungs-/TSM-/ElvUI-Abnahme bleibt bis dahin offen.
