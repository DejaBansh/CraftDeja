# CraftDeja — Orientierung im Code

Stand: beta.25. Übersicht anhand der Module und wowlua.json; keine zweite Spezifikation.
Verbindliche Ladefolge: wowlua.json → build.load-order. Viele Module ergänzen Funktionen
am gemeinsamen app-Objekt oder umschließen vorherige Funktionen: Reihenfolge vor Änderungen prüfen.

| Aufgabe | Module in src/ | Passende Tests |
|---|---|---|
| Start, Client-/Rezeptdaten, Ereignisse | Start, Client, Inventory, Run, OrderProgress | ProfessionSuite, RefreshCostSuite, CraftPerformanceSuite |
| Kosten und begrenzte Planung | Economy, Acquisition, RouteCosts, RoutePlanner, PlanningGoals | NetCostSuite, EconomyEvidenceSuite, PlanCostSuite, RouteCoreSuite |
| Routenauftrag, Voraussetzungen, Quellen | RouteModel, RouteRequirements, RouteRuntime, RouteSupply, RouteTrainer | RouteCoreSuite, RequirementsSuite, SkillGoalSuite |
| Materialwahl / eigene Konversionen | MaterialSources (am Ende geladen), CraftActions | MaterialSourceSuite |
| AH-Angebot, Mengen, Bestätigung, Post | Shopping, AuctionBridge, PurchaseState | AHMailSuite, AHPerformanceSuite, UndercityFlowSuite |
| Händler, tatsächlicher Kauf | Merchants, VendorBuy, MerchantVisibility | VendorSuite, UndercityFlowSuite |
| Bank und Transfers | RouteBank, BankTransfer, Inventory | BankFlowSuite |
| Lehrer / Ort / Station / Marker | Trainers, TrainerNavigation, LocationRouting, StationRouting, MapPins, Data/* | TrainerRoutingSuite, NavigationSuite, MapSuite, StationCTASuite |
| Native Herstellung / Spezialfälle | CraftActions, RodPreparation, Poisons | CraftSuite, RodSuite, ProfessionSuite, UndercityFlowSuite |
| Twinks und opt-in Gilden-Crafts | RouteModel, RouteSupply, RouteGuild | RouteCoreSuite |
| Hauptfenster und Guide | Screen, RouteUI, NextStep, UnifiedUI, WorkshopDashboard | WorkshopSuite, CTASuite, UICompatibilitySuite |
| Gestaltung und Zugänge | Skin, Themes, WorkshopSkin, Attention, Launcher | WorkshopSuite, UICompatibilitySuite |
| Diagnose / Audit | FlowLog, SystemCheck, Performance, RecipeAudit | auftragsspezifisch; Livebelege separat |

Der Auftrag wird aus Clientdaten, gespeichertem Bestand und Preis-/Quellenbelegen bewertet.
RouteRuntime/NextStep liefern konkrete Aufgaben; RouteUI/WorkshopDashboard und kompakter Guide
zeigen diese an. MaterialSources ergänzt Auswahl- und Ranglogik. Hauptfenster und Guide dürfen
keine unabhängigen widersprüchlichen Einkaufspläne führen.

Eine Aktion muss den tatsächlichen aktuellen Auftrag prüfen: Mengen, Post, Reservierungen,
Angebotsidentität und Voraussetzungen können seit dem Rendern geändert sein. AH-/Händlerkauf,
native Craftserie und Banktransfer sind bestätigte Übergänge; Timeout ist kein sicherer Fehlschlag.
Station erfüllt → Marker entfernen → nächste gültige Aufgabe; Cap erreicht → Rang vor Zielabschluss.

Für Änderungen zuerst Funktionsdefinitionen und spätere Wrapper suchen, dann betroffene Tests lesen.
Keine neue permanente OnUpdate-/Timer-Schleife als Ersatz für relevante Invalidierung einführen.
Datengrundlagen und Grenzen: DATA_SOURCES.md, DECISIONS.md, docs/OPEN_ITEMS.md.
