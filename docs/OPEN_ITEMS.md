# Offene Fehler, Abnahmen und Datenlücken

Stand: 17.11.2026. Einträge erst mit konkretem Beleg schließen. Status „automatisiert geprüft“
ist kein Live-Erfolg. Neue Meldungen mit Version, Kontext, Erwartung, Beobachtung und Beleg ergänzen.

| ID | Status / Version | Reproduktion und Abnahmekriterium | Beleg / Zuständigkeit |
|---|---|---|---|
| LIVE-25 | Live offen / beta.25 | Bank/AH-Auswahl, echte Reagenzalternative, Erz→Barren→Elternauftrag und 75/75→150. Altbestand nach AH-Wahl geschützt, keine Doppelaktion; Rang erst nach Clientbestätigung fortsetzen. | docs/MATERIAL_SOURCES_BETA25.md; MaterialSources, CraftActions, RouteRuntime; MaterialSourceSuite |
| LIVE-24 | Automatisiert geprüft, Live-Gesamtabnahme offen / beta.24+ | Undercity: AH→Kauf/Post→Daniel Bartlett/Fluxus→Amboss→Herstellen; Ingenieursauftrag darf kein Gifte-Prompt auslösen. Gifte separat nur nativ freigeschaltet; Bank mit TSM prüfen. | docs/UNDERCITY_GUIDE_BETA24.md, docs/BANK_FLOW.md; UndercityFlowSuite, BankFlowSuite |
| UI-LIVE | Quellemulation geprüft, Live offen / beta.23+ | Hauptfenster/kompakter und aufgeklappter Guide bei 1080p/3440×1440, UI65%/100%, langen DE-Texten mit realem Addonset. Keine Überlappung oder verzogenen Motive. | docs/WORKSHOP_BETA23.md; WorkshopSuite |
| PUB-DESC | Manueller Schritt offen / beta.25 | releases/3.9.0-beta.25/description.md in offizieller Author Console übernehmen und öffentliche Vorschau prüfen. Kein erneuter Datei-Upload. | releases/published-history.json; docs/CURSEFORGE_RELEASE.md |
| DATA-STATIONS | Datenlücke | Verifizierter Forever-Atlas, Zugänge, Ebenen/Instanzen und echte Wege fehlen. Derzeit nur passende nativ beobachtete Punkte; ohne Beleg kein erfundener Standort. | StationRouting, LocationRouting; docs/UNDERCITY_GUIDE_BETA24.md |
| DATA-VENDORS | Geplant, nicht implementiert | Autoritative Datenquelle, Lizenzen/Herkunft und wöchentlichen externen Diff fachlich prüfen. Sieben Tage Lernkostengültigkeit sind kein globaler Händlerabgleich. | docs/VENDOR_RECIPE_AUDIT.md; RecipeAudit, Data/Vendor* |
| MODEL-VALIDATION | Teilweise geprüft, Daten/Modell offen | Forever-Skillchancen aus echten Versuchen und vollständige Routen gegen unabhängige Referenz prüfen. Rang-/Reise-/Werkzeugkosten, riskante AH-Verkaufserlöse nicht pauschal als vollständig berechnet darstellen. | docs/ALGORITHM.md, docs/ECONOMY_EVIDENCE.md, docs/MULTI_STAGE_ROUTES.md |

Historischer bestätigter Fall: Mot Dawnstrider / Rezept7771 / Gegenstand6345 / nil-Link /
200 Kupfer wurde am 15.11.2026 live erfasst (beta.15). Kein aktueller offener Fehler daraus
ableiten; bei neuer Regression separaten Eintrag eröffnen. Vollständige Belegchronik im Archiv.

Historischer Performancefall: Nutzer meldete Release-Build ohne Freezes; Ursache eines speziellen
GC-/Speichermechanismus blieb unbewiesen. Bei neuer Meldung aktuellen Release/Addonset erfassen,
keine globale Entwarnung oder automatische Dauerdiagnose aus früheren Beobachtungen ableiten.
