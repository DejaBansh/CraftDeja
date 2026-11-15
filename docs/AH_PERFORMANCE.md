# AH quantity and refresh regressions / AH-Menge und Aktualisierungen

## Observed in beta.11 / In beta.11 beobachtet

Tim reported that editing Auctionator's planned quantity of 101 to a smaller
quantity immediately restored 101. A live Freeloader screenshot attributed
12.89 ms/frame to CraftDeja (63% in that sample). This is an observed sample,
not an isolated benchmark and not an FPS guarantee for the correction.

The supplied diagnostic log records fresh scans and commodity-price changes.
It also confirms skill 116 -> 117 after one Greater Magic Wand, and a route
change from target 141 to 144 after the essence price fell from 125c to 112c.
Thus repricing does occur; the bug is not a complete absence of recalculation.
The log's older observations include foreign profession records. They are
unverified observations, not data to promote into the recipe catalogue.

## Changes in beta.12 / Änderungen in beta.12

- Prefill a newly opened managed commodity offer once. Preserve subsequent
  smaller manual quantities, including the empty intermediate typing state.
- Read-only status polls do not call native UpdateView when quantity/display
  already agree. Prices and depth are still validated before an explicit buy.
- Invalid, fractional, over-budget, mismatched or unaffordable edits disable the
  guide purchase; they are not silently replaced by the full order.
- Receipt/mail accounting continues to count only the acknowledged purchase.
- Ignore unrelated item-info/other-unit cast events as refresh triggers.
- Coalesce relevant events without indefinitely resetting the debounce timer.
- Every-three-second fallback reads the profession header; only a changed
  profession/skill/cap or loading state schedules recipe enumeration.
- Cache access eligibility once within an economic snapshot for lookahead.
  New snapshots recompute it. Prices, skill chances and vendor credits retain
  the existing model. Native craft-series deferral remains in place.

## Automated evidence / Automatischer Nachweis

25 new AHPerformanceSuite cases execute production AuctionBridge,
PurchaseState, Run and Economy functions. The Auctionator view is a contract
fixture with counted UpdateView, native selected quantity, displayed input and
price levels. The complete Auctionator addon and a live server are not loaded
by those cases. They do not measure GPU FPS or the CPU cost of every addon.

The same new cases against beta.11 production source fail 18/25; against the
correction they pass 25/25. Both runs use camelot/Windows emulation and configured
Blizzard UI via wowlua 0.13.12 on a Linux host; they are not Windows-host runs.
Every run is captured by tools/Test-CraftDeja.ps1 (log, metadata, ZIP).

Final full regression: 427 passed / 0 failed / 0 skipped (306 files, 141.38s),
with configured Blizzard UI. The existing craft-interruption regression also
caught and prompted correction of a missing resume trigger during this round.
The remaining Windows-host/brief real-client checks are recorded in TEST_RESULTS.md. No automatic purchase/craft or public release is introduced.

## Reproduce / Wiederholen

```powershell
.\tools\Test-CraftDeja.ps1 -OpenReportFolder
```

Optional focused run: `-Filter AHPerformanceSuite`.
After automated success, the remaining live check needs no bulk purchase:
open the essence offer, change 101 to 5, wait and inspect the amount and profiler.
Only a user-confirmed purchase can spend gold.


## Verified beta.12 Gaming-PC checkpoint — 2026-11-15

User supplied CraftDeja-beta12-20261115-003747.zip: nested test and install ZIPs
passed CRC verification. Windows wowlua 0.13.14, configured Blizzard UI, no filter.
Build passed; 427 passed / 0 failed / 0 skipped (306 files) in 197.37s.
All 15 runtime source hashes match the delivered correction (LF/CRLF accounted for).
Installed successfully into the Forever AddOns folder with previous version backup.
Existing W1034 remains; it did not prevent the build or tests.

Live follow-up: user reports everything appears to work. Screenshot shows native
Auctionator quantity 5 at 124c/unit, total 620c, matching CraftDeja CTA 6s20c.
Freeloader sample shows 1.03 ms/frame for ALL addons; CraftDeja row about 0.06 ms/frame.
The prior 12.89 ms/frame was a different sample: no controlled benchmark or
general performance/savings guarantee is asserted. No purchase needed for this check.

## Beta.16: erneute Untersuchung am 15.11.2026

Der beta.12-Mengenfix bleibt enthalten und getestet. Die neue Untersuchung belegt wiederholte Erwerbskostenarbeit seit beta.13 sowie sofortige Marktvergleiche bei Commodity-Bursts; siehe [Messmethodik, Ergebnisse und Grenzen](PERFORMANCE_BETA16.md). 517/0/0 im finalen Windowslauf. Keine Installation und keine behauptete Live-FPS-Verbesserung.
