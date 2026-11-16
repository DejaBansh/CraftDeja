# beta.24 — Undercity guide corrections

## Evidence and arithmetic

The supplied beta.23 log (500 entries, 16 November 2026) confirms the following. Raw player logs and screenshots remain local and are not release payloads.

- Entries 3164–3166: Engineering skill 60, next boundary 65, five Copper Tube crafts: **10 Copper Bars + 5 Weak Flux**. This is the old temporary Auctionator list.
- Entries 3504–3508: skill 65, next boundary 75, ten crafts: **20 Copper Bars + 10 Weak Flux**, before subtracting bags, confirmed purchases and mail. The later twenty-bar offer is correct; the old list was not updated for the new stage.
- Entries 3555–3565 and 3583–3604: live AH Flux 106 copper versus observed vendor 100. Leaving the AH discarded that price context and resurrected Auctionator's older 99-copper database quote. That changed the acquisition choice back to AH. The earlier 99-copper AH offer really was cheaper than the vendor and must remain permitted while current.
- Entries 3608–3609 and 3642–3643: MERCHANT_SHOW followed by poison.vendor_open, hasOrder=false, recipesReady=false. Daniel Bartlett sells poison supplies as well as Weak Flux. His inventory triggered the poison prompt without checking the active Engineering order. The recorded active profession remained 202: this case is a prompt override, not proof of a profession switch.
- Entries 3229 onward: the native Amboss requirement is unmet; the previous station action only checked readiness and did not create a target. The later native requirement becomes fulfilled at 3265.
- Screenshot 220108 shows twenty bars, no Flux, Engineering 65, Daniel Bartlett and the wrong poison prompt. Screenshot 215439 shows the stale list and correct twenty-bar offer. Screenshot 215215 is only a scenery crop; it does not independently show a missing map marker.

## Changes

- One material projection now supplies Auctionator list quantities and purchase budgets, including confirmed mail and pending reservations. Update only unchanged CraftDeja-owned list entries through public Auctionator APIs. Manual edits survive; an explicit update action replaces an incompatible list. No repeat MultiSearch and no automatic rewriting of the buyer quantity. Whole-route previews use a separate list identity.
- Preserve the last valid live price after closing the AH until its original scan expires. A newly observed vendor price remains preferred over a more expensive current AH quote. Named vendor action includes the actual missing quantity and cost.
- Poison prompts cannot replace another active profession or route order. Additionally, Poisons requires **Rogue plus live unlock evidence**: learned profession ability 2842, current native profession rank 40, or an open native Poisons profession with positive skill. Class, level, saved jobs and cached sessions alone do not unlock it. Explicit planner/open actions and catalogue cycling observe this guard. No guessed faction quest-completion IDs.
- Stations match the exact native SpellFocus/Area requirement. Record an area only while the client confirms it fulfilled. Compare current-map/current-floor/current-instance points, faction and known access flags; exclude expired or blocked observations. Clicking opens the map and uses existing CraftDeja pins/native waypoints. Completion clears only the station's own marker and leaves a replacement user waypoint intact.
- Nine-slice corners use square source pixels; center artwork crops proportionally. Main button has independent frame slices and event-based hover/press tint. Compact/expanded guide surface follows the final frame bounds. No permanent animation timer added.

## Station-data limits

No verified static Forever station atlas was available. No Classic coordinates or test coordinates were shipped as verified Forever locations. New players may therefore see the concrete missing requirement and an explicit **no verified location on this map/floor** message on their first visit. A successful native readiness observation records an approximate player crafting area, not an exact object position. Permanent-type observations expire after one hour; potentially temporary fire/lab/other foci after two minutes. A special alchemy table never borrows a generic laboratory location.

This is conservative location selection, **not pathfinding** or proof of the shortest reachable walking route across cities, floors or continents. A verified atlas and access graph remain future work. Test coordinates 65/40 are controlled fixtures, not real Undercity directions.

## Automated evidence

- Unchanged beta.23: three targeted production regressions fail in reports/tests/20261116-225338-85ef80.zip (expected baseline).
- Existing broad station/vendor/requirements/AH/workshop check: 118/0/0, reports/tests/20261116-230304-8b64b0.zip.
- Final targeted guide/unlock/cooking check: 21/0/0, 7.17s, reports/tests/20261116-231920-ab34fe.zip, including twenty new cases. Source-emulated screenshots included.
- Initial full beta.24 check: 629/1/0. The old cooking test expected the whole task text to equal its old one-line caption; it now checks that caption as the prefix of the expanded location information. This intermediate run is not release approval.
- Final full suite and screen matrix: see the newest beta.24 entries in TEST_RESULTS.md. All Windows runs use Test-CraftDeja.ps1, release profile, WoWLua 0.13.14/Camelot/Blizzard UI, automatic logs, metadata and source hashes. These are simulations, not a live-server or FPS proof.

## Undercity live check

1. Verify `/cdj version` is beta.24. Open Engineering with learned Copper Tube and the desired skill plan. At skill 65 → 75 with orange one-point crafts and no supplies the recorded case requires ten crafts, twenty bars and ten Flux. At different skill, stock or recipe odds, use the currently displayed plan rather than these example quantities.
2. Search via Auctionator; the current list, guide and native purchase quantity should agree. Buy the bars once, collect mail, and verify no second purchase demand for confirmed mail.
3. Speak to Daniel Bartlett, NPC 4561. With twenty bars, zero Flux and vendor selected, expect **Schwacher Fluxus kaufen · 10**, not Gifte öffnen. Confirm the actual current price and purchase; check the reduced money and increased stock.
4. Open Engineering near a genuine anvil. If there was no verified point, the earlier station action must explicitly say so. Once the native Amboss requirement is fulfilled, expect Herstellung vorbereiten immediately. For marker testing, walk away after this observation: the now-recorded crafting area should be marked, and its button should open the corresponding map. Return; that marker must disappear when readiness is fulfilled.
5. Prepare and start through the original native Create button. Check progress, quantities and the next recipe boundary, without repeated AH searches or heavy scans during the batch.
6. Test compact/expanded sizes and long German text. Separately test a Rogue before and after genuine Poison unlock, and a non-Rogue at the mixed vendor. Full live acceptance remains open.

## Follow-up: weekly vendor recipe audit

Checked Client.observeMerchant, Merchants.recordMerchant, Run merchant events, Acquisition and available tools/workflows. Merchant inventory/prices are refreshed on MERCHANT_SHOW and MERCHANT_UPDATE; saved locations include only unlimited offers. Stored vendor observations have timestamps but no weekly freshness gate. The seven-day window in Acquisition is for observed learning/acquisition costs, not an automatic worldwide recipe sync. Reference recipe-source data changes only with maintained project updates.

A weekly audit needs a verified Forever reference source and provenance/diff checks. The game client cannot query unopened merchants or download arbitrary web data. A lightweight stale-data reminder and refreshed observations on the next actual visit are feasible, but must not be described as a completed weekly global sync. No weekly polling/full scans introduced in this bugfix. Track the audit separately in ROADMAP.md.
