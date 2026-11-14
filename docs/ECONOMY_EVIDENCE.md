# Economic verification / Nachweis der Kostenberechnung

CraftDeja **3.9.0-beta.9**, source base **d3b02173457ecc691a3b77e0641a0ffd8fd73d47**, 14 Nov 2026.

> Historical beta.9 evidence. Current development code: [beta.10 net-cost model](NET_COSTS.md). These 20 fixtures have no confirmed output credit and still exercise the material-only baseline.

## English

These are **controlled synthetic fixtures**, not live auction prices, measured server skill chances, or a ranking of competing addons. Prices below are in silver; the test inputs use copper (100 copper = 1 silver). Fixtures use synthetic recipe IDs. The existing production functions `quote`, `probability`, `marketView`, `selectionAt`, `decide` and `expectedCraftAttempts` run unchanged. Only the price-provider and recipe-access boundaries are supplied by fixtures.

### Reproducible comparisons

| Case | Inputs | Independently calculated expectation | Verified result |
|---|---|---|---|
| 01: green vs orange | Skill 120; green 2s, yellow/green/grey thresholds 90/110/130; orange 10s | Green p=(130−120)/(130−90)=25%; 2/0.25=8s per point vs 10s | Green selected, score 8s |
| 02: expensive green | Same thresholds; green 3s, orange 10s | Green 3/0.25=12s vs 10s | Orange selected |
| 03: successive levels | Same green recipe at 120/121/122 | p=25% / 22.5% / 20% | Each probability matches |
| 04: economic switch | Green 2s with thresholds 90/110/130; alternative orange 12s, thresholds 140/145/150 | At 123: 2/0.175=11.428571s; at 124: 2/0.15=13.333333s. Alternative stays 12s | Green at 123, forecast stops at 124, alternative selected after updating skill to 124 |
| 05: colour boundary | Recipe 2s at 109/110; alternative orange 20s | Becoming green alone does not make the cheaper recipe uneconomic | Same recipe retained |
| 06–08: missing prices | Missing whole quote, all quotes, or one required reagent | Unknown is not zero; incomplete recipe cannot be ranked as a bargain | Priced recipe wins, or `no_prices`; incomplete quote rejected |
| 09: quantities/alternatives | 2×2s plus 3× cheapest of 1s / 0.7s / unknown | 4+2.1=6.1s per craft | Quote 6.1s, priced 0.7s alternative selected |
| 10–11: multiple points/cap | Orange 10s for 1 point vs 15s for 2 points | 7.5s beats 10s when 2 points fit; at skill 149/150 only 1 point remains, so 10s wins | Both selections match |
| 12–13: unlearned recipe/access | Known recipe 10s vs confirmed unlearned 1s | Learning step only if the fixture marks the recipe accessible | Immediate learning follow-up, or inaccessible recipe excluded |
| 14–15: cooldown/grey | Cheap recipe has cooldown or has reached grey | Neither is an eligible skill-up bargain | Alternative selected |
| 16: equal expected cost | Green 2.5s at 25% vs orange 10s | Both 10s per point; prefer higher chance | Orange selected |
| 17: changed prices | Green rises from 2s to 3s; orange stays 10s | Expected cost rises from 8s to 12s | Newly constructed market snapshot changes recommendation to orange |
| 18: expected attempts | Same green recipe at skill 123, target 124 or 125 | ceil(1/0.175)=6; ceil(1/0.175+1/0.15)=13 | 6 and 13 expected attempts; no success guarantee |
| 19–20: cap/options | Skill cap reached, or green disabled | Stop at cap; respect green setting | `rank_full`, or orange selected |

**Case 04 explains why an economic boundary can occur at 124 even if a new recipe unlocks at 125.** This synthetic example does not establish the prices or cause of an earlier live screenshot.

### Run it yourself

On the configured Windows development PC, from the project root:

```powershell
wowlua test EconomyEvidenceSuite
```

This executes **20 cases in one file**, with the project's configured Blizzard UI. The Windows run of these newly added cases **passed: 20 passed, 0 failed, 0 skipped in 4.99s** on 14 Nov 2026; the test file took 3.50s. [Recorded user output summary](evidence/economy-windows-2026-11-14.txt). It does not change the recorded 302-case earlier result into a new 322-case result.

For isolated economic-module verification without a WoW installation (Python plus Lua runtime dependency):

```text
python -m pip install lupa==2.8
python tools/verify_economy.py
```

The Python adapter executes the same Lua fixture bodies in fresh **Lua 5.1** runtimes, loading the actual `src/Economy.lua`. It strips only the suite imports and test annotations. It permits stubbing only `unitPrice` and `canRecommend`. No second implementation of the ranking formula is used as the system under test.

**Recorded isolated result: 20 passed, 0 failed.** The identical test file also passed all 20 cases in a minimal wowlua 0.13.12 project using the actual Economy.lua plus a namespace bootstrap (camelot, Windows emulation, no Blizzard UI, 1.15s). This validates the test DSL and mock boundaries; it is still not the complete addon/Blizzard-UI run. [Raw output](evidence/economy-lua51-2026-11-14.txt). Production Economy.lua SHA256: `bc9675cb550ffbaf476211bae7367fe7a83006cb8a88fb2e20af01c4cf356ed2`.

Sensitivity checks temporarily changed the calculation to ignore probability, ignore multi-point gains, ignore the cap, or remove switch lookahead. All four mutations were caught by failing cases. [Results](evidence/economy-mutations-2026-11-14.txt). These copies are not part of the addon.

### What this does not establish

- The 25% probability is derived from the current model, not measured Forever server behaviour.
- Case 04 calls `decide` with a changed skill explicitly; it does not verify automatic event dispatch or the native crafting loop. Case 17 similarly rebuilds a snapshot; it is not an AH scan test.
- Recipe-access data is controlled here. This does not validate every actual trainer, vendor, faction restriction or price provider.
- Full recipe/market updates remain deferred during native crafting batches; lightweight progress updates continue. See [algorithm](ALGORITHM.md).
- Resale income, learning/tool fees and globally optimal complete routes remain outside the current economic model.
- These comparisons establish specified behaviour, not measured savings or superiority over other addons.

## Deutsch

### Was wurde geprüft?

Die Tabelle oben enthält **20 reproduzierbare Fälle mit künstlichen Preisen und Rezepten**. Geprüft werden die echten Funktionen aus `src/Economy.lua`. Preislieferant und Rezeptzugang werden kontrolliert vorgegeben; die eigentliche Preis-, Wahrscheinlichkeits- und Auswahlberechnung wird nicht ersetzt.

- Grün für 2 Silber bei geschätzten 25% kostet erwartete 8 Silber je Punkt und schlägt Orange für 10 Silber.
- Steigt der grüne Craft auf 3 Silber, gewinnt Orange: 12 gegen 10 Silber je Punkt.
- Bei Skill 123 kostet das Beispielrezept erwartete 11,43 Silber je Punkt. Bei 124 sind es 13,33 Silber. Eine Alternative für 12 Silber wird daher ab 124 günstiger, unabhängig von einem Rezeptfreischalten bei 125.
- Fehlende Preise werden nicht als kostenlos gewertet. Mengen, alternative Reagenzien, Mehrfach-Skillpunkte, Skillcap, Lernschritte, Abklingzeiten und Einstellungen sind abgedeckt.
- Sechs erwartete Versuche bis zum nächsten Punkt bedeuten keine Erfolgsgarantie und nicht automatisch sechs sicher vorzubereitende Crafts.

**Hier ausgeführt:** 20 bestanden, 0 fehlgeschlagen unter Lua 5.1 mit dem unveränderten Wirtschaftsmodul. Dieselbe Testdatei bestand zusätzlich 20/20 in einem minimalen wowlua-0.13.12-Projekt ohne Blizzard-UI (1,15 s). Vier absichtlich eingebaute Rechenfehler in temporären Kopien wurden erkannt.

**Auf dem Gaming-PC ausgeführt:** `wowlua test EconomyEvidenceSuite` bestand am 14.11.2026 mit **20 bestanden, 0 fehlgeschlagen, 0 übersprungen in 4,99 s** (Testdatei: 3,50 s). Dieselben Fälle wurden innerhalb des Addons mit der konfigurierten Blizzard-UI geprüft. [Protokollzusammenfassung](evidence/economy-windows-2026-11-14.txt). Der frühere Lauf mit 302 bestandenen Tests bleibt ein separater Beleg.

Die Fälle belegen weder echte AH-Preise noch serverseitig bestätigte Skillchancen, die automatische Ereignisverarbeitung oder eine global optimale Route. Vollständige Marktvergleiche bleiben während laufender Herstellungsserien verschoben. Verkaufserlöse und einmalige Beschaffungskosten sind noch nicht Teil der Bewertung. [Berechnungslogik](ALGORITHM.md) · [Roadmap](../ROADMAP.md).
