# Cost model / Kostenmodell — 3.9.0-beta.9

Source references: [Economy.lua](../src/Economy.lua), [Run.lua](../src/Run.lua), [Start.lua](../src/Start.lua). This describes the current implementation, not a claim of measured superiority over other addons.

## English

### Recipe score

`material cost per craft / (estimated skill-up chance × skill points per successful craft)`

`quote` sums reagent quantity × available unit price, choosing the cheapest priced choice in an alternative-reagent group. A recipe without a usable quote is not treated as free.

`probability` models orange as 1 and grey as 0. For usable yellow/grey thresholds, yellow/green use `(grey − skill) / (grey − yellow)`, clamped to 0–1. When the ranges cannot be used, fallback estimates and eligibility rules apply. This is a model, not a server-confirmed probability table.

`selectionAt` ranks eligible candidates using cost divided by expected gain, respecting the cap, access and other available recipe metadata. Green is enabled by default, but saved settings can disable it; green candidates also require usable range data. Equal cost prefers higher chance, then recipe ID.

`decide` examines later skill levels for a recipe switch or learning step. `expectedCraftAttempts` sums the expected attempts along the relevant skill levels. The prepared batch size can be deliberately smaller than this expected attempt count near a switch. There is no guarantee of a point after a fixed number of attempts.

### Update policy

Skill and inventory events update the guide. `Run.refresh` takes a lightweight progress path during a native crafting batch and defers full recipe/market/inventory work until completion or interruption. This avoids claiming that a full market comparison runs immediately on every skill point while a batch is active. Price-provider values are cached observations; an AH scan or search is needed for new market observations.

### Limits and planned improvements

The economic ranking currently uses material costs. It does not deduct output resale proceeds or amortize recipe purchases, trainer fees, travel or tool acquisition. Requirement/rod tasks in the guide do not imply their acquisition costs are included in the score.

This is a local cost-per-expected-point comparison with switch lookahead, not a demonstrated globally optimal full 1–300 route. Future work includes safe vendor resale, one-time learning/prerequisite costs, full-route comparisons and empirical validation of Forever skill probabilities. [Roadmap](../ROADMAP.md).

### Evidence

[20 reproducible economic comparisons](ECONOMY_EVIDENCE.md) exercise the actual quote and ranking functions with controlled prices. The isolated Lua 5.1 run and the Windows/wowlua run with configured Blizzard UI both passed all 20 cases; the Windows run took 4.99s on 14 Nov 2026.

[AutoSkillSuite](../tests/AutoSkillSuite/) exercises choices including cheap green vs expensive orange, missing prices, skill caps and quantities. [TEST_RESULTS.md](../TEST_RESULTS.md) records the user's 302-test Windows run on 14 Nov 2026. Automated cases validate their specified inputs and expectations; they do not establish that every recipe, server action or price-provider combination works live.

## Deutsch

Bewertet werden Materialkosten pro erwartetem Skillpunkt. Die Skillchance wird aus Farbe und verwertbaren Grenzen geschätzt; Grün kann wirtschaftlicher als Orange sein. Bei gleichem Preis wird die höhere Chance bevorzugt.

Die Vorschau berücksichtigt mögliche spätere Rezeptwechsel. Vorbereitete Serienmenge und geschätzte Versuchszahl sind unterschiedliche Werte. Während laufender Serien bleiben Fortschrittsupdates leichtgewichtig; vollständige Vergleiche werden verschoben.

Verkaufserlöse, Rezeptkauf, Trainergebühren, Reise und Werkzeugbeschaffung sind noch nicht Teil der wirtschaftlichen Rangfolge. Die Ruten-/Werkzeugprüfung im Guide ist davon getrennt. Eine global günstigste komplette 1–300-Route und alle Forever-Skillwahrscheinlichkeiten sind nicht nachgewiesen.

Die 302 Tests sind ein dokumentierter automatisierter Lauf des Nutzers mit wowlua 0.13.14 und Blizzard-UI 1.60.1.70938; keine vollständige Live-Serverprüfung. Künftige Änderungen müssen ihre passenden Tests erneut bestehen.
