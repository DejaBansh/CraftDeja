# Berechnungsnachweis — 3.9.0-beta.9

Stand 14.11.2026; Referenzen src/Economy.lua, src/Run.lua, src/Start.lua.

1. quote summiert Reagenzmenge × verfügbarem Preis; Alternativreagenzien nutzen die günstigste bepreiste Auswahl.
2. probability setzt Orange=1 und Grau=0; bei verwertbaren Grenzen p=(grey-skill)/(grey-yellow).
3. selectionAt bewertet quote.cost / (p × Skillpunkte), mit Grenzen, Zugriff, Abklingzeit und bekannten Voraussetzungen.
4. decide vergleicht kommende Skillstufen auf einen wirtschaftlichen Wechsel oder Lernschritt.
5. expectedCraftAttempts summiert erwartete Versuche entlang der Skillstufen; dies ist keine Garantie.
6. Run.refresh verschiebt vollständige Neuvergleiche während aktiver Serien; refreshCraftProgress bleibt leichtgewichtig.

Derzeit keine Erlösverrechnung und keine bewiesene globale Optimierung. Die UI-Voraussetzungsprüfung ersetzt nicht die
Verrechnung ihrer Erwerbskosten. Preise sind gecacht; unbekannte Preise sind nicht kostenlos.
Ein grünes Beispiel in Werbematerial ist eine Modellrechnung, keine gemessene Forever-Erfolgsquote.

Öffentlich zugängliche Tests sollen diese Logik künftig anhand fester Eingaben und erwarteter Ergebnisse belegen.
Dieser Text ist eine Codebeschreibung, kein neuer Testlauf und keine Servervalidierung.
