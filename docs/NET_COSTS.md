# Net cost per skill point / Netto-Kosten pro Skillpunkt — 3.9.0-beta.10

Development patch based on public source `711d463`. Full Windows/Blizzard-UI regression run **passed: 372 passed, 0 failed, 0 skipped (304 files) in 195.46s**, wowlua 0.13.14, 14 Nov 2026. [Verified record](evidence/net-costs-windows-2026-11-14.txt). The earlier beta.9 GitHub release is unchanged.

## English

### Calculation

`expected net cost per point = (material cost − confirmed minimum vendor value) / (estimated skill-up chance × achievable skill points)`

The vendor value is a **sale assumption**, not gold already in your bags. CraftDeja neither sells the output nor assumes it sells on the auction house. If you keep an item, its credited vendor value is not cash you received.

| Controlled example (silver) | Material/craft | Minimum vendor value/craft | Estimated chance | Expected net cost/point |
|---|---:|---:|---:|---:|
| Orange A | 5 | 0 | 100% | 5 |
| Orange B | 11 | 9 | 100% | 2 — selected |
| Green C | 3 | 2 | 25% | 4 |
| Orange D | 10 | 0 | 100% | 10 |

B can beat the cheaper-to-craft A; C can beat D despite requiring more expected attempts. These are separate synthetic comparisons, not server prices or measured skill chances.

### Conservative resale credit

- Output item ID and minimum quantity come from the current client's recipe data for **all crafting professions**. Legacy trade-skill item links and minimum/maximum creation quantities are supported.
- With variable output (e.g. 2–5 items), only 2 items are credited. No average, maximum, proc or critical craft is assumed.
- `C_Item.GetItemInfo` / legacy `GetItemInfo`, return 11, supplies sell value **per item**. This is separate from reagent vendor **purchase** prices, Auctionator and TSM.
- Missing item information, missing/conflicting output proof or invalid quantities give **no credit**; the quote keeps full material cost. The next market snapshot can retry previously unknown values.
- Direct enchanting of equipment never credits the value of the target item. Enchanting output must be explicitly marked as a physical item by the client.
- Binding alone does not mean unsellable. A bound output with a confirmed sell price can be credited; an unsellable/zero-value output gives zero credit.
- Unknown reagent prices still invalidate the quote, even when the output has a large sell value.

A quote retains `cost` (gross material value), adds `vendorRevenue` and `netCost`, and exposes whether vendor credit is confirmed. Ranking and future recipe switches use `netCost / expected gain`. Legacy fixture quotes without `netCost` retain the gross fallback.

### Zero and negative costs

Zero and negative net costs stay signed. A negative score models a potential vendor margin per expected point; it is not a profit guarantee or a global gold-farming strategy. At equal scores, the higher chance still wins. Percentage savings are omitted when the comparator is zero or negative. Grey recipes cannot generate a skill-up recommendation.

### Purchasing, display and performance

Material quantities and purchase budgets remain **gross**. Two crafts at 10s material cost each still require 20s for their materials, even if the outputs could later sell for 18s. Owned stock continues to reduce missing purchases in the normal way; it does not alter the per-craft market valuation.

The existing adviser labels the score as net/skill. Recipe details show material value, credited vendor value, net cost and the sale assumption in **German and English**. No additional text is added to the primary CTA.

Vendor values are memoized within an economic snapshot, including misses (modern API plus optional legacy fallback). Lookahead reuses quote values. Even a quote requested during a native batch reads vendor credit only from the existing decision snapshot, never from the item API. Without that cache it credits zero until normal refresh resumes. There is no new timer, explicit item-load request, item-info event handler or native batch refresh. `Run.lua` and `CraftActions.lua` remain unchanged; their existing full-scan deferral still applies. This patch does not claim to eliminate all live-client stutter.

### Validation and limits

- **50 new NetCostSuite cases**, plus 20 existing evidence cases and 17 existing AutoSkillSuite economic cases: **87 passed, 0 failed, 0 skipped**, 19 files, in a minimal wowlua 0.13.12 project without Blizzard UI. Actual Start/Words/Client/Economy sources and Lua test bodies are copied unchanged; non-UI bootstrap helpers are described in the runner.
- [Recorded focused run](evidence/net-costs-focused-2026-11-14.txt) and [six sensitivity checks](evidence/net-costs-mutations-2026-11-14.txt). These temporary mutations must fail; production source is not mutated.
- Reproduce without a WoW installation: `python tools/verify_net_costs.py --wowlua /path/to/wowlua`.
- Complete Gaming-PC build and all 372 tests passed with configured Blizzard UI. Metadata, output and source hashes were checked from the generated report ZIP. This remains automated validation, not a live-server test.
- Price providers, all live outputs/requirements and actual selling remain data-dependent and are not validated by synthetic economic cases.
- AH resale proceeds, trainer/recipe/tool acquisition fees and globally optimal complete routes remain outside this model. Skill probabilities remain estimates.

API layout reference: [Blizzard-generated ItemDocumentation.lua](https://github.com/Gethe/wow-ui-source/blob/live/Interface/AddOns/Blizzard_APIDocumentationGenerated/ItemDocumentation.lua). The client recipe APIs are queried at runtime; no retail recipe/output data is imported as Forever economics.

## Deutsch

### Was ändert sich?

Die Empfehlung vergleicht jetzt **Materialkosten minus bestätigtem Mindest-Händlerwert**, geteilt durch den erwarteten Skillgewinn. Beispiel: Ein Craft für 11 Silber mit 9 Silber Händlerwert kostet netto 2 Silber und kann damit einen Craft für 5 Silber ohne Erlös schlagen.

Der Händlerwert wird nur unter der Annahme angerechnet, dass du das Ergebnis tatsächlich verkaufst. CraftDeja verkauft keine Gegenstände automatisch. Behältst du das Ergebnis, bekommst du den angerechneten Erlös nicht ausgezahlt.

### Welche Fälle sind abgesichert?

- Ausgabedaten für alle Herstellungsberufe; bei 2–5 Ergebnissen zählt nur die Mindestmenge 2.
- Fehlende oder widersprüchliche Daten führen zu keiner Erlösgutschrift.
- Verzauberungen auf Ausrüstung erhalten keinen fiktiven Verkaufserlös. Physische Verzauberungsprodukte benötigen eine ausdrückliche Bestätigung des Clients.
- Gebundene Gegenstände zählen nur mit bekanntem Händlerwert; nicht verkäufliche Ergebnisse bringen keinen Abzug.
- Fehlende Materialpreise werden auch bei hohem Verkaufserlös nicht als kostenlos behandelt.
- Negative Netto-Kosten bleiben erhalten; bei Gleichstand gewinnt die höhere Skillchance.
- **Einkaufsmengen und benötigtes Gold bleiben brutto.** Der spätere Verkauf bezahlt keinen Einkauf im Voraus.
- Details erklären Materialkosten, Händlerwert und Netto-Bewertung auf Deutsch und Englisch. Die nächste Aktion bleibt kurz.

### Stand der Prüfung

**87 gezielte Tests bestanden**, darunter 50 neue Netto-Fälle. Geprüft wurde mit wowlua 0.13.12 in einem minimalen Projekt ohne Blizzard-UI. Sechs absichtlich fehlerhafte Varianten wurden erkannt. Der korrigierte vollständige Lauf auf dem Gaming-PC bestand alle **372 Tests ohne Fehler oder übersprungene Fälle in 195,46 s**, mit wowlua 0.13.14 und aktivierter Blizzard-UI. Build, Bericht und Quellhashes sind geprüft.

Die bisherigen Schutzmaßnahmen gegen schwere Scans während laufender Herstellungsserien bleiben bestehen. AH-Verkaufserlöse, einmalige Lern-/Werkzeugkosten und eine global optimale komplette Route sind weiterhin nicht Teil der Berechnung.


## Integration correction / Integrationskorrektur

The first complete Gaming-PC run reported **369 passed, 3 failed** in 216.40s.
The poison extension wrapped `quote(r,memo)` but dropped the newly added sell-price memo,
so shared output values were read repeatedly and the active-batch snapshot lacked vendor prices.
This was reproduced locally with the actual poison wrapper: 84 passed, 3 failed in the focused 87-case set.
Forwarding `sellPrices` fixes the cause; the focused set now passes 87/87 with Poisons.lua loaded.
[Before](evidence/net-wrapper-before-fix-2026-11-14.txt) · [After](evidence/net-wrapper-after-fix-2026-11-14.txt).
The corrected complete Windows run passed 372/372, including the three previously failing cases. [Verified Windows record](evidence/net-costs-windows-2026-11-14.txt). Future Windows tests use
[the automatic ZIP report command](TEST_REPORTS.md).

Der erste vollstaendige Lauf hatte drei echte Integrationsfehler. Sie wurden mit der Gifte-Erweiterung
reproduziert und durch Weiterreichen des Preiszwischenspeichers behoben. Das Gift-Mengenmodell bleibt unveraendert.
Der lokale Testaufbau laedt jetzt auch diese Erweiterung. 87/87 lokal bestanden;
die neue vollstaendige Windows-Pruefung ist durch den geprueften Bericht belegt: 372/372 bestanden, 0 Fehler, 0 uebersprungen.
