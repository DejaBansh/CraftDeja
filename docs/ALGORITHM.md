# Cost model / Kostenmodell — 3.9.0-beta.10 (development)

Source references: [Economy.lua](../src/Economy.lua), [Run.lua](../src/Run.lua), [Start.lua](../src/Start.lua). This describes the current implementation, not a claim of measured superiority over other addons.

## English

### Recipe score

`(material cost per craft − confirmed minimum vendor value) / (estimated skill-up chance × achievable skill points)`

`quote` sums reagent quantity × available unit price, choosing the cheapest priced choice in an alternative-reagent group. A recipe without a usable quote is not treated as free. `quote.cost` stays gross; `quote.vendorRevenue` credits only confirmed physical output and client vendor sell value, using minimum output. `quote.netCost` subtracts that credit and drives the score. Selling the output is an assumption, never an automatic action. See [net-cost rules and tests](NET_COSTS.md).

`probability` models orange as 1 and grey as 0. For usable yellow/grey thresholds, yellow/green use `(grey − skill) / (grey − yellow)`, clamped to 0–1. When the ranges cannot be used, fallback estimates and eligibility rules apply. This is a model, not a server-confirmed probability table.

`selectionAt` ranks eligible candidates using net cost divided by expected gain, respecting the cap, access and other available recipe metadata. Green is enabled by default, but saved settings can disable it; green candidates also require usable range data. Equal cost prefers higher chance, then recipe ID.

`decide` examines later skill levels for a recipe switch or learning step. `expectedCraftAttempts` sums the expected attempts along the relevant skill levels. The prepared batch size can be deliberately smaller than this expected attempt count near a switch. There is no guarantee of a point after a fixed number of attempts.

### Update policy

Skill and inventory events update the guide. `Run.refresh` takes a lightweight progress path during a native crafting batch and defers full recipe/market/inventory work until completion or interruption. This avoids claiming that a full market comparison runs immediately on every skill point while a batch is active. Price-provider values are cached observations; an AH scan or search is needed for new market observations.

### Limits and planned improvements

The economic ranking now deducts confirmed minimum vendor sell value if the output is sold. It does not deduct AH resale proceeds. Beta.13 additionally gates unlearned candidates with observed/quoted one-time recipe costs against a bounded route of known alternatives; unknown costs are explicitly provisional. Travel, tools and profession-rank costs remain excluded. See [ACQUISITION_COSTS.md](ACQUISITION_COSTS.md). Requirement/rod tasks in the guide do not imply their acquisition costs are included in the score.

This is a local cost-per-expected-point comparison with switch lookahead, not a demonstrated globally optimal full 1–300 route. Future work includes one-time learning/prerequisite costs, full-route comparisons and empirical validation of Forever skill probabilities. [Roadmap](../ROADMAP.md).

### Evidence

[20 reproducible economic comparisons](ECONOMY_EVIDENCE.md) exercise the actual quote and ranking functions with controlled prices. The isolated Lua 5.1 run and the Windows/wowlua run with configured Blizzard UI both passed all 20 cases; the Windows run took 4.99s on 14 Nov 2026.

[AutoSkillSuite](../tests/AutoSkillSuite/) exercises choices including cheap green vs expensive orange, missing prices, skill caps and quantities. [TEST_RESULTS.md](../TEST_RESULTS.md) records the user's 302-test Windows run on 14 Nov 2026. Automated cases validate their specified inputs and expectations; they do not establish that every recipe, server action or price-provider combination works live.

## Deutsch

Bewertet werden Netto-Kosten pro erwartetem Skillpunkt: Materialkosten abzüglich bestätigtem Mindest-Händlerwert, unter der Annahme eines Verkaufs. Der volle Einkaufsbetrag bleibt davon getrennt. Die Skillchance wird aus Farbe und verwertbaren Grenzen geschätzt; Grün kann wirtschaftlicher als Orange sein. Bei gleichem Preis wird die höhere Chance bevorzugt.

Die Vorschau berücksichtigt mögliche spätere Rezeptwechsel. Vorbereitete Serienmenge und geschätzte Versuchszahl sind unterschiedliche Werte. Während laufender Serien bleiben Fortschrittsupdates leichtgewichtig; vollständige Vergleiche werden verschoben.

AH-Verkaufserlöse, Rezeptkauf, Trainergebühren, Reise und Werkzeugbeschaffung sind noch nicht Teil der wirtschaftlichen Rangfolge. Händlererlös wird bei bestätigten Ausgabedaten mit der Mindestmenge angerechnet; ohne Bestätigung bleibt es bei Materialkosten. Die Ruten-/Werkzeugprüfung im Guide ist davon getrennt. Eine global günstigste komplette 1–300-Route und alle Forever-Skillwahrscheinlichkeiten sind nicht nachgewiesen.

Die 302 Tests sind ein dokumentierter automatisierter Lauf des Nutzers mit wowlua 0.13.14 und Blizzard-UI 1.60.1.70938; keine vollständige Live-Serverprüfung. Künftige Änderungen müssen ihre passenden Tests erneut bestehen.


## Development validation — beta.10

[Net-cost implementation and limitations](NET_COSTS.md): 50 new cases plus 37 existing economic cases passed in focused module validation. Full Windows/Blizzard-UI regression execution passed all 372 cases (0 failures/skips) in 195.46s with wowlua 0.13.14 on 14 Nov 2026. [Windows record](evidence/net-costs-windows-2026-11-14.txt). The beta.9 results above remain historical.

## Trainer fee identity — beta.14

Beta.14 adds a guarded nil-link fee observation for the specifically reported Mot Dawnstrider offer (NPC 11071 / recipe 7771 / recipe item 6345): exact client name and rank, verified NPC/catalog relationship, and no duplicate service or spell identity. All other unsupported nil-link offers remain unknown. This is not fuzzy name matching or complete trainer coverage. See [ACQUISITION_COSTS.md](ACQUISITION_COSTS.md).
