# Offene Fehler, Abnahmen und Datenlücken

Stand: 23.11.2026. Einträge erst mit konkretem Beleg schließen. Status „automatisiert geprüft“
ist kein Live-Erfolg. Neue Meldungen mit Version, Kontext, Erwartung, Beobachtung und Beleg ergänzen.

| ID | Status / Version | Reproduktion und Abnahmekriterium | Beleg / Zuständigkeit |
|---|---|---|---|
| UI-27 | Zweite Designprobe, visuelle Forever-Abnahme offen | Beim Händler die Hauptaktion und „Materialwahl ändern“ vergleichen. Zahnrad öffnen, Werkstattpult auswählen und mit der eigenen UI-Skalierung Lesbarkeit und Schließkreuz prüfen. | Emulatoransichten und Installationsbericht unter reports/install/meisterpult-v2/ |
| PROC-27 | Lokaler Kandidat, Live-Abnahme offen | Kochkunst 219/225 mit 33 Fischen und manuellem Stopp am Ziel, grüner Zauberstab mit Reserve und Fehlversuch, Silberrute mit verzögertem Bestand, Rezept vom Händler lernen, Rezept-Einzelauktion und Auctionator-Dialog mit Preisänderung. Händlerweg nur als gemeinsamer Stopp modelliert. | docs/GUIDE_BESCHAFFUNG_UND_SERIEN.md, ProcurementSuite |
| GUIDE-DEV | In beta.26 ausgeliefert, detaillierte Live-Abnahme offen | Vollständiger deDE-Auftrag über Kauf/Post/Händler, Bankvariante und Unterbrechung. Guide-Toggle und Zielbestand mit realem Addonset prüfen. | docs/GUIDE_FULL_FLOW_DEV.md, TEST_RESULTS.md |
| ENG-300-LIVE | WoWLua: 300/300 und „Fertig“ erreicht. Forever-Abnahme offen | Echte Rezeptwechsel, Skillchancen und die drei Rangwechsel prüfen. Direkteingabe „Rang lernen“ für 75/75 prüfen. Bei 150 und 225 den Rang im nativen Lehrerfenster lernen und die Fortsetzung beobachten. | TEST_RESULTS.md; UndercityFlowSuite; RouteTrainer.lua |
| STOCK-UI | In beta.26 ausgeliefert, Forever-Abnahme offen | Berufsübergreifende Rezeptliste mit neuerlerntem Rezept, `/reload` und Charakterwechsel prüfen. Ziel per Zeile setzen und Auffüllauftrag bestätigen. Materialwahl, Optionen und Rückkehr bei kleiner Skalierung mit realem Addonset kontrollieren. | docs/GUIDE_FULL_FLOW_DEV.md; StockRefillSuite; MaterialSourceSuite; TEST_RESULTS.md |
| BRAND-LOGO | Neue PNGs erstellt, Übernahme offen | Logo und quadratisches Goblin-Symbol im Stil von Werbemotiv A; transparente Ränder geprüft. Bei Übernahme passende Größen/Texturexporte erzeugen und kleine Darstellung prüfen. Aktive Addongrafiken bleiben unverändert. | docs/assets/branding/2026-11-17/, PROMPTS.json / MANIFEST.json |
| LIVE-25 | Live offen / beta.25 | Bank/AH-Auswahl, echte Reagenzalternative, Erz→Barren→Elternauftrag und 75/75→150. Altbestand nach AH-Wahl geschützt, keine Doppelaktion; Rang erst nach Clientbestätigung fortsetzen. | docs/MATERIAL_SOURCES_BETA25.md; MaterialSources, CraftActions, RouteRuntime; MaterialSourceSuite |
| LIVE-24 | Automatisiert geprüft, Live-Gesamtabnahme offen / beta.24+ | Undercity: AH→Kauf/Post→Daniel Bartlett/Fluxus→Amboss→Herstellen; Ingenieursauftrag darf kein Gifte-Prompt auslösen. Gifte separat nur nativ freigeschaltet; Bank mit TSM prüfen. | docs/UNDERCITY_GUIDE_BETA24.md, docs/BANK_FLOW.md; UndercityFlowSuite, BankFlowSuite |
| UI-LIVE | Quellemulation geprüft, Live offen / beta.23+ | Hauptfenster/kompakter und aufgeklappter Guide bei 1080p/3440×1440, UI65%/100%, langen DE-Texten mit realem Addonset. Keine Überlappung oder verzogenen Motive. | docs/WORKSHOP_BETA23.md; WorkshopSuite |
| PUB-DESC | Summary öffentlich nachprüfen / beta.26 | Beschreibung D und beide Bilder öffentlich geprüft. Anzeige der gespeicherten Summary nachprüfen. | releases/published-history.json; docs/CURSEFORGE_RELEASE.md |
| PROMO-HERO | Option D öffentlich eingebunden | Werkstattbanner mit Messingrahmen und beschriftetem Live-Guide gemäß Referenz D übernehmen. | docs/assets/marketing/2026-11-21-curseforge/D/media.md |
| DATA-STATIONS | Datenlücke | Verifizierter Forever-Atlas, Zugänge, Ebenen/Instanzen und echte Wege fehlen. Derzeit nur passende nativ beobachtete Punkte; ohne Beleg kein erfundener Standort. | StationRouting, LocationRouting; docs/UNDERCITY_GUIDE_BETA24.md |
| DATA-VENDORS | Geplant, nicht implementiert | Autoritative Datenquelle, Lizenzen/Herkunft und wöchentlichen externen Diff fachlich prüfen. Sieben Tage Lernkostengültigkeit sind kein globaler Händlerabgleich. | docs/VENDOR_RECIPE_AUDIT.md; RecipeAudit, Data/Vendor* |
| MODEL-VALIDATION | Teilweise geprüft, Daten/Modell offen | Forever-Skillchancen aus echten Versuchen und vollständige Routen gegen unabhängige Referenz prüfen. Rang-/Reise-/Werkzeugkosten, riskante AH-Verkaufserlöse nicht pauschal als vollständig berechnet darstellen. | docs/ALGORITHM.md, docs/ECONOMY_EVIDENCE.md, docs/MULTI_STAGE_ROUTES.md |

Historischer bestätigter Fall: Mot Dawnstrider / Rezept7771 / Gegenstand6345 / nil-Link /
200 Kupfer wurde am 15.11.2026 live erfasst (beta.15). Kein aktueller offener Fehler daraus
ableiten; bei neuer Regression separaten Eintrag eröffnen. Vollständige Belegchronik im Archiv.

Historischer Performancefall: Nutzer meldete Release-Build ohne Freezes; Ursache eines speziellen
GC-/Speichermechanismus blieb unbewiesen. Bei neuer Meldung aktuellen Release/Addonset erfassen,
keine globale Entwarnung oder automatische Dauerdiagnose aus früheren Beobachtungen ableiten.
