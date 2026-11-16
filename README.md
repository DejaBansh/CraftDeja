<p align="center"><a href="https://www.curseforge.com/wow/addons/craftdeja"><img src="https://media.forgecdn.net/attachments/2202/742/craftdeja_goblin_unter_2mb-jpg.jpg" alt="CraftDeja Goblin workshop and profession features" width="420"></a></p>

# CraftDeja — WoW Forever Profession Leveling

**MORE SKILL. LESS GOLD.**

Compare recipes by **estimated net cost per skill point**, then follow one clear next action: get materials, learn a recipe, find a workstation or prepare crafting.

**WoW Forever 1.60.1 · German & English · Auctionator shopping · Optional TSM prices**

[Download on CurseForge](https://www.curseforge.com/wow/addons/craftdeja) · [Report a problem](https://github.com/DejaBansh/CraftDeja/issues) · [How the calculation works](docs/ALGORITHM.md) · [Reproducible comparisons](docs/ECONOMY_EVIDENCE.md) · [Deutsch](#deutsch)

| Current source | Automated validation | Status |
|---|---|---|
| 3.9.0-beta.22 (local feature branch) | Release/source validation recorded in TEST_RESULTS.md | Location-aware trainer selection, minimap access and AddOns settings; live retest pending |

Validation uses Windows/Camelot, wowlua 0.13.14 and configured Blizzard UI. Source emulation is not execution of the bundled release artifact or a complete live-server test. The earlier beta.17 release comparison was reported smooth in game. [Full test record](TEST_RESULTS.md) · [Multi-stage routes and controlled comparisons](docs/MULTI_STAGE_ROUTES.md) · [Product priorities](docs/PRODUCT_PLAN.md).

## English

### Why cost per skill point?

A cheap craft is not always a cheap skill point. CraftDeja compares reagent costs minus confirmed minimum vendor value (assuming the output is sold) with the estimated chance of gaining skill and the number of skill points a successful craft can award.

**Illustrative example — not live prices; no resale credit in this example:**

| Recipe | Material cost per craft | Estimated skill-up chance | Expected material cost per point |
|---|---:|---:|---:|
| Orange | 10 silver | 100% | 10 silver |
| Green | 2 silver | 25% | 8 silver |

Green can therefore be the cheaper option when enabled and the recipe data supports it.

### What CraftDeja helps with

- **Recipe comparison:** ranks eligible candidates by estimated net cost per skill point and looks ahead for a cheaper recipe or a learning step.
- **A clear guide:** a prominent next-action button; details remain in optional views and tooltips.
- **Material planning:** deducts available holdings and distinguishes missing purchases, storage and confirmed incoming purchases where data is available.
- **Plan cost details (beta.18):** separates full material value, owned reagents, estimated missing-material purchases and net material value after credited vendor resale. Unknown inventory stays explicit; learning and prerequisite costs may be extra.
- **Multi-stage routes (beta.19):** `/cdj route` compares complete same-target candidates, reserves intermediate outputs, checks observed AH quantity tiers and separates remaining payments from economic net costs. Planned trainer visits, confirmed alt professions and opt-in guild sourcing for rods/Salt Shaker share a saved order. [Details and live checks](docs/MULTI_STAGE_ROUTES.md).
- **Stable route sections (beta.20):** routine price/inventory/progress events update the current action without restarting the full route search. Complete comparisons happen at checkpoints or on explicit replan; surplus supplies reserved for later sections receive bank guidance. [Cause, regression evidence and retest](docs/ROUTE_CHECKPOINTS.md).
- **Auctionator shopping:** searches missing materials and prepares quantities. TSM can optionally supply suitable price values; it does not replace the Auctionator workflow.
- **Recipe sources:** considers usable unlearned recipes and shows recorded trainers, vendors and map markers when coordinates are known.
- **Workstations and tools:** specific instructions such as cooking fire, anvil or forge, using requirements the client reports.
- **Enchanting rods:** plans a missing runed rod as a prerequisite task, including predecessor rods where needed, then returns to the original order.
- **Rogue poisons:** target stock or additional quantities, with poison ranks kept separate.

Automatic quantities apply below skill 300. Custom quantities remain available for poisons and production at skill 300 or above.

### Watch the workflow

<p><img src="https://media.forgecdn.net/attachments/2202/942/craftdeja_demo_en-gif.gif" alt="Real CraftDeja gameplay: prices, auction shopping, mail, cooking fire, crafting and a trainer map marker" width="640"></p>

English captions; the recorded game client is German. The added cost-per-point text explains the model; the video is not a controlled savings benchmark.

### Install and start

1. Download the **installable addon ZIP from [CurseForge](https://www.curseforge.com/wow/addons/craftdeja)**.
2. Extract its `CraftDeja` folder into `_forever_/Interface/AddOns/`, then enable it in the AddOns list.
3. For AH prices and shopping, install Auctionator and scan your auction house. Suitable TSM data is an optional price source.
4. Open a supported profession, type **`/cdj`**, and follow the guide.
5. Use the gear menu for settings, sources, diagnostics and the guided system check.

You confirm purchases yourself and start crafting with the game's original Create button. The repository's **Code → Download ZIP is a source archive**, not an installable release; developers should [build it with wowlua](docs/DEVELOPMENT.md).

### Supported professions

Alchemy, Blacksmithing, Leatherworking, Tailoring, Engineering, Enchanting, Cooking, First Aid and Mining **smelting recipes**, plus rogue poisons. This is not a gathering-route addon for Herbalism, Skinning or Fishing.

### What the current model does — and does not do

`Expected net cost per skill point = (material cost − confirmed minimum vendor value) / (estimated skill-up chance × achievable skill points)`

- Orange is modelled as certain; yellow/green chances use estimates. Threshold or availability data may be incomplete.
- Unknown prices do not mean free materials. Prices are cached observations, not a continuous live AH feed.
- Skill and inventory changes update the guide. During a native crafting batch, lightweight progress updates continue while full recipe/market work waits for completion or interruption.
- **Vendor resale value is credited only for confirmed minimum physical output, assuming you sell it.** Supported unlearned-recipe comparisons additionally consider observed/quoted one-time acquisition costs against known alternatives; unknown fees stay provisional. AH resale, travel and general tool-acquisition costs are not included. A tool task in the guide is not the same as pricing that task into the route.
- The current comparison is **not a demonstrated globally optimal complete 1–300 route**. Recipe/source coverage depends on confirmed data.

Gross reagent purchase budgets stay unchanged. [Net-cost examples, rules and tests](docs/NET_COSTS.md) · [Current test record](TEST_RESULTS.md). Feature-branch code and locally prepared packages do not automatically update the public CurseForge download.

See [the calculation and its limits](docs/ALGORITHM.md), [the tests](tests/) and [the roadmap](ROADMAP.md).

---

## Deutsch

**MEHR SKILL. WENIGER GOLD.**

CraftDeja vergleicht Rezepte nach **geschätzten Netto-Kosten pro Skillpunkt** und führt dich mit einer klaren nächsten Aktion durch den Auftrag.

Das Beispiel oben zeigt den Unterschied: 2 Silber pro Craft bei geschätzten 25% Erfolg ergeben 8 Silber pro Skillpunkt. Damit kann Grün günstiger sein als Orange für 10 Silber bei 100%. Es handelt sich um ein Rechenbeispiel, nicht um Live-Preise oder eine bestätigte Forever-Erfolgsquote.

### Funktionen

- Wirtschaftlicher Rezeptvergleich mit bestätigtem Mindest-Händlerwert bei Verkauf des Ergebnisses und Vorschau auf mögliche Rezeptwechsel oder Lernschritte.
- Materialplanung mit verfügbarem Taschen-/Bankbestand, optionalen Alt-Daten und bestätigten Einkäufen.
- Auctionator-Einkaufshilfe, passende Kaufmengen und optionale TSM-Preisdaten.
- Bekannte Rezeptquellen, Lehrer und Händler; Kartenmarker bei vorhandenen Koordinaten.
- Konkrete Arbeitsstätten- und Werkzeughinweise sowie vorgeschaltete Rutenaufträge.
- Eigene Planung für Schurkengifte mit getrennten Rängen und Zielbeständen.
- Automatische Mengen unter Skill 300; eigene Stückzahlen bei Giften und Produktion ab 300.

### Installation

Die fertige Addon-ZIP von **[CurseForge](https://www.curseforge.com/wow/addons/craftdeja)** laden. Den enthaltenen Ordner `CraftDeja` nach `_forever_/Interface/AddOns/` entpacken und aktivieren. Auctionator installieren, das AH scannen, den Beruf öffnen und **`/cdj`** eingeben.

Käufe bestätigst du selbst; die Herstellung startest du über den originalen Herstellknopf. Die GitHub-Quellarchiv-ZIP muss erst mit wowlua gebaut werden. [Entwicklungsanleitung](docs/DEVELOPMENT.md).

### Berechnung und Grenzen

Die Rangfolge verwendet Materialkosten abzüglich bestätigtem Mindest-Händlerwert bei Verkauf des Ergebnisses, geteilt durch erwarteten Skillgewinn. Der Einkauf benötigt weiterhin den vollen Betrag. Gelbe und grüne Skillchancen bleiben Schätzungen. Vollständige Vergleiche werden während einer laufenden Craft-Serie aus Performancegründen verschoben; gezielte Fortschrittsupdates bleiben aktiv.

Bei unterstützten Vergleichen unbekannter Rezepte werden beobachtete oder bepreiste einmalige Erwerbskosten gegen bekannte Alternativen geprüft; unbekannte Gebühren bleiben ausdrücklich vorläufig. **AH-Verkaufserlöse, Reise und allgemeine Werkzeugbeschaffung sind nicht eingerechnet.** Ohne bestätigte Ausgabedaten oder Händlerwert gibt es keinen Erlösabzug. Eine global günstigste vollständige Route von 1–300 ist nicht bewiesen. Ab beta.18 trennen die Rezeptdetails Materialwert, verwendeten eigenen Bestand, geschätzten Zukauf und Nettomaterialwert. Ab beta.19 vergleicht `/cdj route` vollständige Kandidaten zum gleichen Ziel, reserviert Zwischenprodukte und berücksichtigt belegte Lern-/Runenrutenkosten sowie bestätigte Twink-/Gildenquellen für den Auftrag. Fehlende Belege bleiben vorläufig. [Routenvergleich und Live-Prüfung](docs/MULTI_STAGE_ROUTES.md) · [Berechnungslogik](docs/ALGORITHM.md) · [Produktplan](docs/PRODUCT_PLAN.md).

Beta.10: 87 gezielte Wirtschaftsfälle bestanden; vollständiger Windows-/Blizzard-UI-Lauf: **372 bestanden, 0 fehlgeschlagen, 0 übersprungen**. [Neue Netto-Berechnung](docs/NET_COSTS.md). Die fertige beta.9-Downloadversion ist unverändert.

Für beta.9: 302 automatisierte Tests bestanden am 14.11.2026 mit wowlua 0.13.14 und Blizzard-UI 1.60.1.70938. Das ersetzt keine vollständige Prüfung aller Abläufe auf dem Liveserver.

## Feedback and contributions / Rückmeldungen

Use [GitHub Issues](https://github.com/DejaBansh/CraftDeja/issues/new/choose). Please include addon version, client build/language, profession and skill, recipe ID if available, steps to reproduce, price source and the error text. A screenshot or diagnostic report helps. Reports in **English or German** are welcome.

Bitte Fehler mit Version, Clientbuild/-sprache, Beruf, Skill, Rezept und reproduzierbaren Schritten melden. Bei Preisproblemen die Preisquelle und das Alter der Daten ergänzen. [Neuen Fehler melden](https://github.com/DejaBansh/CraftDeja/issues/new/choose).

## License and data

Newly authored code and documentation: [MIT](LICENSE). Derived reference data retains its attribution and notices in [DATA_SOURCES.md](DATA_SOURCES.md) and [Licenses](Licenses/). Data and artwork have their own provenance; do not assume every asset is covered by the code license. World of Warcraft belongs to its respective owners.


Development test reports / Testberichte: use [tools/Test-CraftDeja.ps1](tools/Test-CraftDeja.ps1) to generate a shareable ZIP automatically. [Instructions DE/EN](docs/TEST_REPORTS.md).


Beta.11 routing correction / Routingkorrektur: [Thunder Bluff recipe trainers and current-map ordering](docs/TRAINER_ROUTING.md). The underlying source snapshot remains incomplete.
