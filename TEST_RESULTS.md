# Validation — 3.9.0-beta.4

## beta.20 — finale Checkpoint-/Bankprüfung, 16.11.2026

**572 bestanden, 0 fehlgeschlagen, 0 übersprungen; 319 Dateien; 232.55s.** Release-Build bestanden, Windows/Camelot/Blizzard-UI, wowlua 0.13.14. ZIP reports/tests/20261116-165128-c7c8c3.zip. Alle 48 Laufzeit-, 320 erfassten Test-/Profilquellen und drei Build/Testinput-Hashes passen exakt zum finalen Code. Neun neue Checkpoint-/Bank-/Bootregressionen, bisherige Suites mitgeprüft.

Unveränderte beta.19: dieselben zwei Ereignissturm-Reproduktionen 0/2/0, reports/route-checkpoints-ab/beta19/reports/tests/20261116-164051-9e6d65.zip. Korrigierte Version: laufende echte Coroutine unter Ereignissen genau einmal aufgebaut und ohne UI-Neuöffnung abgeschlossen. Verschiedene Testumfänge/Laufzeiten sind kein FPS-Vergleich.

Zwischenlauf 164100-73b28d meldete 570 bestandene Einzeltests, aber Datei-Ladefehler in CraftPerformanceSuite/11; deshalb ausdrücklich failed_or_incomplete. Früher Welt-Eintritt vor bereitstehendem Routenmodell nun abgesichert und mit neuem Bootstrap-Fall sowie bestehendem Craft-Fall geprüft (10/0/0, 164649-c1178b). Versuch 164631-c960a2 fand wegen falscher Filterübergabe 0 Tests und ist kein Prüferfolg. Finale Freigabe ausschließlich anhand obigem vollständigen Hashnachweis.

Automatisierte Source-Emulation, kein Ausführen des kompilierten Release-Bundles und keine abgeschlossene Live-Abnahme. Beta.20 wegen laufendem WoW noch nicht installiert. Live-Testplan und Analyse: docs/ROUTE_CHECKPOINTS.md.


## beta.19 — finale Mehrstufen-Routenprüfung, 16.11.2026

Release-Build bestanden; Windows/Camelot, Blizzard-UI aktiviert, wowlua 0.13.14. **563 bestanden, 0 fehlgeschlagen, 0 übersprungen; 318 Testdateien; 210.33 Sekunden.** Vollständiger Nachweis: reports/tests/20261116-060955-1159db.zip. Alle erfassten Laufzeitquellen, Testdateien und Build-/Testinputs stimmen mit dem finalen Stand überein. Native JSON-Ergebnisse und Referenzabbildungen sind automatisch im ZIP enthalten.

34 neue gezielte Fälle in RouteCoreSuite plus bisherige Regressionen. Kontrollierter Engineering-1–75-Vergleich 436 gegen 476 Kupfer (40 Ersparnis), Rutenvergleich AH/Alt/Gilde und Quelle/Bindung/Alter/Opt-out/AH-Abwahl/Trainer/Nativplan-Fälle. Vollständige Abnahmezuordnung und offene Live-Prüfung: docs/MULTI_STAGE_ROUTES.md. GUI zusätzlich gerendert und Überlagerung korrigiert; isolierte UI-Prüfung reports/tests/20261116-060452-360149.zip.

Zwischenlauf 20261116-054836-b6b39e hatte 23/1/0: echte vollständige Engineering-Referenz deckte auf, dass kurze Beam-Präfixe vor Budgetende vollständige Teileketten verdrängten. Zusätzliche vollständige Wechselketten vor der begrenzten Suche korrigieren den reproduzierten Fall. Weitere erfolgreiche Zwischenläufe bleiben lokale Entwicklungsspuren und ersetzen den obigen abschließenden Hashnachweis nicht.

Grenzen: Source-Emulation, keine Ausführung des kompilierten Release-Bundles und keine bestätigte Zwei-Spieler-/Liveserver-Abnahme; keine FPS-Garantie. Bekannte W1034 unverändert.


1985 assertions pass in the final suite; production-load cold start also passes. Added real-event observer tests: unobserved steps remain
waiting, actual profession opening and closing progress, mismatched AH quantity
fails while matching quantity passes, native preparation alone does not pass
crafting, and user start plus successful same-recipe craft does. Skips remain
skips in exported reports; export text survives polling. Stock7/target20 records
missing13, unknown data waits. Tests assert existing goal and poison state identity
are preserved. Diagnostic code contains no purchase, craft or profession-open API
calls; it wraps existing events/logging and observes user-triggered actions.
No live Forever client available; system check itself requires initial live validation.

# Validation — 3.9.0-beta.3

1965 assertions pass in the standard suite. Reproduced completed poison order,
manual guide close, profession close and three vendor re-visits; new visits reopen,
same-visit updates respect dismissal and no purchase occurs without a click.
Normal profession pages cover skill goals, general setting toggles, all menu tabs,
catalogue, vendors, recipe reports, flow log, purchase diagnostics, details, tutorial,
and return to the guide; tested Enchanting and Alchemy contexts. Hosted theme
headers stay hidden after refresh, with a separate shared title/logo layer above
embedded pages and non-intercepting mouse handling.

Profession-transition checks reject old poison lists under an enchanting header,
then accept the newly loaded enchanting list while excluding foreign records.
Loading disables primary actions and order editing. Mixed foreign/unknown lists
on initial login remain unconfirmed. A 220-report repeated audit does not append
duplicate audit log entries or evict the latest user action. Existing stock,
purchase, mail, scan and native-craft contracts remain passing.
No live WoW Forever/TSM session was available; actual client retest remains required.

# Validation — 3.9.0-beta.2

1754 assertions pass. Added exact finished-item stock scenarios: target20/bags20
creates no job and disables the redundant draft action; target25/bags20 plans
five ingredient sets; incoming stock reduces an existing refill to complete.
Explicit extra20 still plans20 even with25 owned. Two output IDs are counted
separately. Missing stock data disables refill rather than inventing a deficit.
Fresh profile default is refill; fixture extra mode is now explicit. Existing
price, quantity, vendor queue, mail and native crafting checks remain passing.
No live Forever client was available. Existing saved extra plans remain extra
and must be deliberately cancelled/switched by the user.

# Validation — 3.9.0-beta.1

1730 assertions pass with liblua 5.4. Existing engine/legacy presentation tests
run before loading UnifiedUI; unified integration scenarios then exercise the
production overrides. Additional production-order cold-start smoke passes six
assertions: first-login help, hidden adviser, profession opening, and restoration
of the visible guide action. UI preview fixtures use test icons and approximate
texture layering, not an actual WoW renderer.

Unified checks cover one visible top-level frame, saved poison drafts, embedded
quantity/goal editors, child scale inheritance, vendor quotes and price changes,
ordinary reagent buying, gear tabs, embedded logs/reference pages, Back navigation,
profession closing, AH scan freshness, and native crafting requiring a physical
native click. No live Forever/TSM client was available; client layout and input
integration still need testing.

# Validation — 3.8.0-beta.7

1549 assertions across 128 simulated scenario groups pass with liblua 5.4.
New checks show every registered top-level CraftDeja window, close the native
profession and assert only Next step remains visible. Order targets, job and
pending receipt identities are preserved. Late merchant acknowledgements and
updates do not reopen windows on the same visit; a new visit restores the planner.
Visibility polling and explicit close events both clean up the UI; reopening
restores the adviser. Existing AH event-order checks now assert the requested
hidden adviser while retaining read-only cached planning and explicit purchases.
No live client was available for validation.

# Validation — 3.8.0-beta.6

1490 assertions across 126 simulated scenario groups pass with liblua 5.4.
Added merchant-open checks with no active order and a hidden MerchantFrame
(TSM-style UI), once-per-visit dismissal, delayed item-list loading, exclusion
of ordinary vial vendors, restoration of a valid session-40 context while closed,
exact missing-material offers without automatic purchase, fresh-login prompt,
explicit click requesting profession 40, prompt scaling/theme and invalidated
session rejection. Existing vendor price/quantity/receipt safeguards still pass.
No live Forever/TSM session was available; the reported merchant needs live retest.

# Validation — 3.8.0-beta.5

Existing 1455 assertions passed. Inspected mock previews for a single learned
poison (580x386 logical window units), multiple poisons with a three-row viewport
(580x594, scrolling for further rows), and the adviser planner button. Recipe
labels, stock text, inputs and footer buttons remain within the content bounds.
The preview uses fixture item icons and approximates native scroll clipping.
No live client was available; actual scaling and scrolling need in-game checking.

# Validation — 3.8.0-beta.4

1455 assertions across 121 simulated scenario groups pass with liblua 5.4.
Added station projection tests for unconfirmed purchases vs confirmed mail,
vendor deficits, complete aggregate poison jobs during partial native batches,
real craft success/GUID dedup, completed/cancelled jobs, bank collection counts,
scan uncertainty, stable ordinary route boundaries, saved record isolation,
EN/DE tooltips and the direct order command. Existing commerce and craft tests
remain passing. Mock layout inspected; external item icons are fixture
placeholders and attention-text layering is approximated in this mock renderer.
No live WoW Forever client was available for validation.

# Validation — 3.8.0-beta.3

Existing 1399 assertions passed after the adviser geometry adjustment. A rendered
mock of the narrower and shorter cards was inspected for text/button bounds and
background margins. No live client rendering was available.

# Validation — 3.8.0-beta.2

1399 assertions across 117 simulated scenario groups passed with liblua 5.4.
New scenarios cover separate persistent bag-stock targets, 7-owned/20-target
producing 13, bank/alt exclusion for finished products, aggregate ingredient
quantities, satisfied targets creating no job, missing bag/output API data,
fixed-yield batch rounding and duplicate output rejection. Incoming finished
items shrink the unstarted plan; consumption never silently enlarges an approved
order. A simulated native three-craft batch with bag events before success events
reaches the goal without double decrement or unattended refill loops. Reopening
and switching modes preserve their independent quantities. A mock rendering of
the restock controls was inspected. No live WoW Forever client was available.

# Validation — 3.8.0-beta.1

1340 assertions across 112 simulated scenario groups passed with liblua 5.4.
Added automatic poison planner opening, per-recipe target sliders/edit boxes,
shared ingredient aggregation, saved targets, edit locks, grey recipe preparation,
fixed output validation, material drift rejection, fresh scan shopping gate and
frozen per-order purchase budgets. Native batches are prepared at exact counts;
only player spell-success events decrement the queue and trigger next preparation.
No protected craft call is issued by the addon. Vendor checks cover rounded packs,
full-price approval, per-purchase inventory acknowledgements, price increases and
merchant close. Aggregate popup, scaling and ten theme mappings are covered.
A mock rendering of both new windows was inspected; placeholder item icons in
that mock are fixture data. No live Forever client was available. The new poison
UI/API compatibility and real vendor/crafting flow need in-game validation.

# Validation — 3.7.0-beta.1

1242 assertions across 105 simulated scenario groups passed with liblua 5.4.
Recipe checks cover canonical reagent groups and alternatives; unknown vs known
recipes; live ingredient priority without reference mutation; repeat-read dedup;
incomplete client schematics; difficulty evidence across skill changes; resolution
on a new reference revision; persistence across initialization; 200-record bounds;
flow-log disabled operation; bounded log excerpts; EN/DE UI, report command/button,
clear action and scaling. Existing 1205 flow/crafting/shopping/trainer checks pass.
Original Auctionator 344 numeric input, quote, confirmation and purchase-event
contract probes also pass. A rendered mock preview was inspected for the new adviser status/button and the
report window. This is not an in-game render; live client validation remains needed.

# Validation — 3.6.0-beta.6

1205 assertions across 100 simulated scenario groups passed with liblua 5.4.
Added character level 7 vs Alchemy 75–150's required level 10: prominent warning,
optional trainer action, no automatic trainer marking, and immediate ungating on
PLAYER_LEVEL_UP even when UnitLevel still reports 7. Exact-level eligibility and
unknown level fallback are covered. Existing purchase, mailbox, crafting and
trainer-map tests remain passing. No live client was available for validation.

# Validation — 3.6.0-beta.5

1193 assertions across 99 simulated scenario groups passed with liblua 5.4.
New checks cover all nine profession data groups, coordinate/rank invariants,
exact faction and rank matching, same-map preference, unknown-faction/data fallback,
Undercity Alchemy Journeyman vs Expert vs Artisan selection, automatic logo marker,
click-to-open target map, and task transition after the client cap changes.
Existing 1168 purchase/mail/vendor/crafting/scan assertions remain passing.
No live game client was available to verify the current Forever trainer offerings.

# Validation — 3.6.0-beta.4

1168 assertions across 97 simulated scenario groups passed with liblua 5.4.
Added a complete two-material purchase/collection/vendor/crafting scenario:
both confirmed receipts appear together; the mailbox action does not open recipe
details or erase uncollected stock; partial collection retains the remaining amount;
full collection changes Next step to vendor vials; receiving the vials exposes
available crafts. Uses the real task renderer and refresh path after AH closure.
No in-game mailbox or merchant interaction was available for live verification.

# Validation — 3.6.0-beta.3

1152 assertions across 96 simulated scenario groups passed using liblua 5.4.
Added full-route native input synchronization, a 59-unit purchase spanning two
price levels, clamped selection, mismatched visible input and wrong-total guards.
No quote request is issued when these checks fail. Existing scan/purchase tests pass.

A separate local contract probe executes original Auctionator 344 OnLoad,
OnTextChanged, UpdateView and GetPrices: 39 units at 17 copper plus 20 at 18
copper show quantity 59 and total 1023 copper; a two-unit native clamp is rejected.
The three original native confirmation/event/receipt contract probes also pass.
No Auctionator code is bundled. Not verified inside the user's game client.

# Validation — 3.6.0-beta.2

1137 assertions passed across 95 scenario groups with liblua 5.4 and simulated
WoW API/frame objects. All 345 previous assertions remain passing. New scenarios
cover successful full scans vs unrelated DB updates; failed/malformed/empty scans;
late completion after AH close/reopen; scan expiry; current snapshot pricing vs
old Auctionator/TSM caches; slider limits; inventory changes; missing stock;
vendor exclusions; exact quantities and copper price ceilings (including sub-copper stack prices); search failures;
repeat-search lock; bilingual UI, scale and preserved profession context.

The new guide tests cover first-login display, acknowledgement persistence, no
repeat popup on later login, help command/button reopening, language switching
and adviser/guide visibility. The guide layout was inspected in both languages.

AH regression scenarios cover both close/show event orders, a pending debounce at AH
opening, missing recipe APIs, zero profession reads while at the AH, generic skill
notifications, queued crafts finishing after closing the profession, manual hide,
reopening with /cdj, profession switching and an Alchemy shopping plan from the
saved profession. The native Blizzard crafting/AH panel manager is not modified.

A separate local contract probe executed Auctionator 345's actual public
MultiSearchAdvanced implementation and advanced search serializer/parser. Exact
names, quantities and copper maxPrice survived the real API conversion. That
third-party source is NOT included in this archive. Both inspected modern and
legacy full-scan payload shapes are covered by the application tests.

Captured UI objects were rendered and visually inspected in German and English.
This verifies layout with test data, not actual WoW rendering, live market depth,
server throttling, purchased mail, protected actions or a specific installed
Auctionator fork. Full-scan events use a version-sensitive internal Auctionator
hook. An unsupported version fails closed rather than buying with old data.

Manual test still required in Forever: open a profession; open AH; complete Full
Scan; confirm the panel appears only then; choose +5 points; inspect quantities
and ceiling in Auctionator; confirm a purchase; collect mail; repeat after a price
change. Also test scan cancellation, AH close/reopen and the client's scan
cooldown. Publish this update as Beta until this workflow has been verified.


Auctionator 344 regression: a local integration probe executes its actual
ScanButton mixin, IncrementalScan event constants and IncrementalScan frame code
with mocked AH/DB objects. Clicking the real Scan-button method, supplying browse
results and completing DB processing opens CraftDeja shopping. A separate probe
executes the actual 344 MultiSearchAdvanced API and serializer/parser: exact
names, quantities and copper ceilings, including fractional copper, round-trip.
New application scenarios cover summary-only integrations, per-unit minPrice,
pet rows, mismatched scan completions, malformed results and visible feedback.
This is local integration validation, not a claim of testing inside the game.


Vendor regression cases cover the screenshot's five-craft herb stock, no prior
vendor visit, missing vials, all herbs missing together, AH prices below/equal/above
vendor, bundle unit conversion, reference-vs-observed preference, strict ceilings
with +20% tolerance, faction references and limited merchant exclusions. UI count
summaries and handoff explanations are verified. A lifecycle scenario verifies
reuse across AH visits, retained original timestamp and mail lock, validity at
exactly 1800 seconds, expiration at 1801 seconds and late/aborted completion.
Both shopping languages were visually inspected using captured UI objects.


New storage scenarios verify separate bags/personal/shared counts; current-bank
withdrawals to zero; unavailable API preservation; persistent GUID-based alt
snapshots; realm/faction boundaries; optional deduction and unconfirmed binding;
shared-bank deduplication; zeroing removed alt inventory; bank-collection text;
bilingual shopping controls; nearest compatible vendor selection; observed vendor
capture; native map pin and unsupported fallback; announcement throttling and scale.
All tests run with simulated APIs; no game client is connected here. Current
Forever GetItemCount argument order and bank/waypoint interfaces were inspected
against Gethe/wow-ui-source's forever branch. UI objects/layout were inspected in
both languages; actual scroll clipping and game rendering require in-game checking.

Manual first test: log in main and each alt; open banks; log back to main; open
profession then AH; scan once; check location counts and Alt stock toggle. Visit
a normal supplier, reopen shopping, check vendor coordinates and Map pin. Test
withdrawals, mailed transfers after collecting mail, account bank and /reload.

3.3 tests add semantic button textures, glyph fallbacks, compact shopping/tooltips,
merchant popup bundle rounding, no purchase without click, pending-click blocking,
price-change revalidation, insufficient money, limited/currency exclusions, cheaper
AH exclusion, bag confirmation, timeout/manual retry, dismissal, world-map canvas
placement/map switching and Ctrl-click removal. The merchant API contract was
inspected against the Forever MerchantFrame source; BuyMerchantItem receives item
units, and pack step/price comes from stackCount. All packaged TGA textures have
power-of-two dimensions. Captured test frames were visually inspected with the new
skin. These tests do not exercise native protected purchase actions or live game
map rendering. No Blizzard source is packaged.

Beta 2 adds action selection, exact quantities, map success/failure text, marker
deduplication, explicit dismiss, changed task, bank/craft/mail/AH/unknown stock
transitions and bilingual range colours. Next-step layout inspected with test data.

Beta 3 verifies separate drag grips on all eight window types; right-button
rejection; scale change, clamps, persistence and global reset; foreground icon
layering; zero/empty icon fallback; custom slider endpoints, thumb and limits.
Skin layout inspected using captured test frames. Actual game frame layering,
cursor anchoring, clamping and native item image loading remain manual tests.

3.4 tests cover profession/AH opening restoration, shopping closure, scan wait,
recipe/no-profile states, auto-start delay, freshness/expiry, closed-AH deferral,
mail-lock preservation, busy buy panel, cooldown, throttling, failure backoff,
replicate/summary choice and scoped quantity prefill. Unknown items, excess units,
excess cost, expired orders and vendor materials are rejected; confirmed success
reduces remaining units and failure does not.

Two additional local probes execute actual Auctionator 344 code: automatic
InitiateScan -> complete summary scan -> shopping unlock, and the commodity
QuantityCheckConfirmationDialog SetDetails/ConfirmPurchase methods. The latter
shows the quantity is filled without a purchase call; only explicit confirmation
sends it, and unrelated-item quantities remain empty. Third-party test sources are
not bundled. Live hardware-event behaviour, server throttling and actual user
interaction still require in-game testing.

Beta 2 regression: real profession opener dispatch and visible failures; craft
output texture/count; one native craft per click with bag and recipe revalidation;
search/quote vs actual purchase separation; generic success without item evidence;
partial purchase/rest quantity; bag collection; direct commodity offer loading,
changed-price rejection, quote preparation and explicit confirmation.

The actual Auctionator 344 BuyClicked, ForceStartPurchase, GetPrices, CheckPurchase
and QuantityCheckConfirmationDialog methods were executed in a separate local
probe. No purchase is sent while preparing; explicit confirmation emits a mocked
synchronous COMMODITY_PURCHASED event before the API returns and correctly records
its item/quantity. No Blizzard/Auctionator implementation is included in this ZIP.

Forever generated API docs and native crafting page were inspected: OpenTradeSkill
returns opened; CraftRecipe takes recipeSpellID/numCasts; CommodityPurchased carries
itemID/quantity whereas CommodityPurchaseSucceeded carries no payload. Native
recipe-page SelectRecipe takes recipeInfo rather than a raw numeric ID. These are
source/API contract checks, not an in-game test of protected calls or server orders.

A replenishment regression also verifies that collected materials consumed by
crafting can be planned again on a later explicit click, without reusing a zero
remaining allowance or treating the previous mail as a new purchase.

Beta 3 reproduces a profession opened from the AH without a native show event:
OpenTradeSkill succeeds, the AH remains open and the recipe reader must replace
an invalidated cache with the current profession/skill. A late AH_SHOW preserves
that visible native profession. Separate scenarios supply nil profile data and
empty recipe IDs before data becomes ready, verify a visible loading task and a
single window-opening call, then confirm automatic recovery. Native visibility
also repairs a missed event; hidden native panels trigger zero recipe reads.
Previous AH-only isolation/event-order cases remain passing. These are controlled
API/frame simulations; no live game client is connected.

Beta 4 adds frozen purchase batches, four repeated two-unit attempts, quote-intent
correlation, generic-only synchronous success, event deduplication, no-result
reservation persistence, failure release, live one-copper repricing and native
quantity clearing. A completed craft permits a new batch; stale bag data, simple
polls and scans do not. The original 344 dialog/BuyClicked probe now also emits
only generic success synchronously and then a duplicate item-specific success;
only one receipt is booked. Live-price hooks and zero native quantity are tested.
See AUDIT_EINKAUF.md for findings and remaining in-game validation.

Additional mail regression: an unrelated bag gain after the direct-delivery
window cannot erase pending mail. Actual collection while MAIL_SHOW is active
reduces it. A generic receipt after lost reload context stays uncertain; an
item-specific receipt can resolve it.

3.5 regressions reproduce four available crafts versus a five-craft plan, separate
single/batch API quantities, per-cast progress, interruption and stop dispatch,
conservative boundary counts, and a hidden Shopping parent brought forward before
commodity loading. Log tests verify 500-entry bounds, persistence, unchanged-state
suppression, pause/re-enable, export UI and selective forwarding of own Lua errors.
The new Next-step button layout was rendered from captured test frames and inspected.
This does not prove hardware-restricted cancellation or native rendering in game.

## Beta 2 regression checks

The mock now denies GetStringHeight on EditBox, as the Forever widget API does.
The actual Next-step Info callback and /cdj log dispatcher open and reopen the
export without that method. Existing pause/clear/persistence/export checks pass.
Native quantity 4, selected recipe and reagent allocation reach one request;
quantity clamping and setter exceptions fail without an unintended second craft.
The default suite has 992 assertions / 79 scenarios. With CDJ_NATIVE_SOURCE set
to the separately downloaded Forever UI directory, an opt-in test executes the
original Create, CreateInternal and transaction:CraftRecipe functions and reaches
1000 assertions / 80 scenarios. Primary code is not distributed in the addon.
This is API-contract validation, not an in-game/server integration test.

## Beta 3 client-confirmed regression

The supplied runtime screenshot reports SetFont: missing argument 3 (flags).
All five non-test SetFont calls now explicitly pass a string for flags. The mock
requires it, and the regression test reproduces the missing-argument failure,
opens the corrected log, checks direct chat error reporting and recovery, and
checks /cdj version. 999 default assertions / 80 scenarios, or 1007 / 81 with the
optional original native source probe. Crafting logic is unchanged from beta 2;
the observed in-game multicraft problem remains under investigation.

## Beta 4 recorded no-start path

The supplied 3.5 beta 3 trace records accepted=4 and a nil native Create result,
then completed=0 / remaining=4; input quantities remain 5/4/6. This establishes no
observed craft start, not a server error or a proven conflict with another addon.
New regression coverage: a UI Create callback that must never be invoked; direct
API dispatch with all selected native arguments; four confirmed completions;
nil API return with no start (no retry); requested-to-running start event;
synchronous ADDON_ACTION_BLOCKED; fixed four-craft material rows during repeated
rendering; unchanged reads and unrelated spells/addon loads excluded from log.
1017 assertions / 83 default scenarios. Optional original native transaction
argument comparison: 1032 / 84. Live result remains pending.

## Beta 5 explicit native confirmation

The new 1.60.1 trace records CraftDeja ADDON_ACTION_BLOCKED / UNKNOWN() synchronously
with the direct craft dispatch. Consequently that production path is removed.
Tests now distinguish preparation from a separate user/native click, reject any
addon-issued CraftRecipe/Click/Create and stop function, preserve native handlers,
verify exact native input 1/4 and highlighting, and track only actual cast events.
Quantity clamping, setter errors, preparation persistence, manual edits, Back,
profession close and relevant client block reporting are covered. The obsolete
native-transaction dispatch probe is removed because it no longer tests the current
production path. 1030 assertions / 83 simulated scenarios. German task layout rendered
and inspected with synthetic data. Real server crafting remains unverified.

## 3.6 next-action planning, task emphasis and native cue

Six new scenario groups cover a full 15-to-73 learning route (64 estimated crafts
rather than 5), exact missing quantities handed to Auctionator, manual mode/return
and persistence, rank cap 75 and learning required now, pending purchase safety,
unchanged-goal no-unlock, readable opaque mail text with background-only pulse,
and a native cue selecting safe Create all versus a bounded prepared Create button.
The cue never dispatches a craft or modifies native handlers. Hidden native buttons
and unsafe all-counts hide it. Old purchase, storage, faction and profession contracts
remain covered; their skill-target fixtures explicitly use the retained manual mode.
1090 assertions / 89 scenarios pass. German mail/ready/shopping layout mockups were
rendered and visually inspected; native item textures/slider motion in the test
renderer are placeholders, not live screenshots. No new live-client claim is made.
The user's newer trace does confirm four prepared native crafts completed and later
two native crafts raised the profession from 19 to 21.

## 3.6 beta 2 scan lock and purchase target regression

The new trace reports fresh=true before the Search click; early protocol completion
versus a changing market cannot be settled from that older trace because scan events
were not yet logged. Its full next-action search list versus two-unit item load does
confirm the leftover explicit shoppingPlan(shopping.points) calls. Both are removed.
New scenarios cover disabled UI and stale callbacks during scanning, complete-but-busy
staging, new-price release at native idle, an eight-hour wall-clock jump with unchanged
client timer, old generation plan rejection, full next-action load quantity, raw live
commodity updates, pending purchase receipt preservation, and AH-close pending
completion invalidation. 1137 assertions / 95 scenarios pass. The external actual
Auctionator 344 probe now declares a fresh scan context, matching the hardened
contract, and its three native quote/confirmation/receipt cases pass. No in-game
purchase or scan-completion claim is made for this version.

## Gaming-PC validation — 2026-11-14

CraftDeja 3.9.0-beta.9
Windows, wowlua 0.13.14, Blizzard UI 1.60.1.70938.
302 passed, 0 failed, 0 skipped; 198.23 seconds.
Build passed. IconTexture generated correctly through addon.icon-texture.
Remaining compiler warning: W1034 in src/UnifiedUI.lua.
Automated tests do not replace complete in-game validation.

## Economic evidence module verification — 2026-11-14

Source base d3b02173457ecc691a3b77e0641a0ffd8fd73d47; addon 3.9.0-beta.9.
20 new cases passed in isolated Lua 5.1 (lupa 2.8), loading actual src/Economy.lua.
Only price-provider and access boundaries are fixtures. No production Lua changed.
Four deliberately broken temporary variants were detected by the suite.
See [inputs, expected outputs, raw results and limitations](docs/ECONOMY_EVIDENCE.md).
The new Windows/wowlua + configured Blizzard UI execution also passed 20/20, as recorded below. The earlier 302-pass run above is separate; no fresh combined 322-case run is claimed.

Additional isolated wowlua 0.13.12 validation: same 20-case file, unchanged Economy.lua,
minimal namespace bootstrap, camelot/Windows emulation, no Blizzard UI: 20 passed,
0 failed, 0 skipped in 1.15s. The same economic suite also passed within the full addon with configured Blizzard UI on the Gaming PC, as recorded below.


## Economic evidence — Gaming-PC Windows validation — 2026-11-14

CraftDeja 3.9.0-beta.9; command: `wowlua test EconomyEvidenceSuite`.
User supplied the successful output from C:\Users\Tim\Projects\CraftDeja.
20 passed, 0 failed, 0 skipped (1 file) in 4.99s; file execution 3.50s.
The full addon used its configured Blizzard UI; exact client build and tool version
were not reprinted in this output. Existing W1034 in UnifiedUI.lua remains.
No production Lua changes and no claim of live-server or combined 322-case validation.
[Transcribed output summary](docs/evidence/economy-windows-2026-11-14.txt).


## Beta.10 net-cost development — focused verification — 2026-11-14

Based on 711d463. Production Start/Words/Client/Economy modules and test bodies
were copied unchanged into a minimal wowlua 0.13.12 project, without Blizzard UI.
50 new NetCostSuite cases + 20 EconomyEvidence cases + 17 existing AutoSkill
economic cases: 87 passed, 0 failed, 0 skipped (19 files).
[Raw focused output](docs/evidence/net-costs-focused-2026-11-14.txt).
Six deliberately broken temporary variants were detected by the suite.
[Mutation output](docs/evidence/net-costs-mutations-2026-11-14.txt).
Run.lua/CraftActions.lua unchanged. Full Windows/Blizzard-UI regression and build for beta.10 later passed, as recorded below. Prior beta.9 results are separate; no combined pass
count or live-server result is asserted. [Rules and reproduction](docs/NET_COSTS.md).


## Beta.10 first complete Gaming-PC run — 2026-11-14

User-supplied output: build passed; 369 passed, 3 failed, 0 skipped (304 files)
in 216.40s. Failures: NetCostSuite cases 26, 27 and 46. W1034 remains.
The existing Poisons.lua quote wrapper discarded the new third memo argument.
The focused runner now includes that production wrapper: the same three failures
were reproduced (84/87), then forwarding sellPrices yielded 87/87.
[Before](docs/evidence/net-wrapper-before-fix-2026-11-14.txt) /
[After](docs/evidence/net-wrapper-after-fix-2026-11-14.txt).
The corrected full Windows run later passed all 372 cases; see the validated report record below.
Automatic per-run ZIP reporting is available through tools/Test-CraftDeja.ps1.


## Beta.10 corrected complete Gaming-PC validation — 2026-11-14

Build passed. wowlua 0.13.14; complete addon with configured Blizzard UI.
**372 passed, 0 failed, 0 skipped (304 files) in 195.46s.**
Report timestamp: 22:03:54–22:07:10 Europe/Berlin.
The user supplied 20261114-220354-b7fccb.zip; CRC, metadata and full output were checked.
Five reported source hashes match the corrected source allowing LF/CRLF conversion.
The previously failing NetCostSuite 26/27/46 now pass. W1034 remains.
No exact client build was printed, and no live-server validation is claimed.
[Verified Windows record](docs/evidence/net-costs-windows-2026-11-14.txt).


## Beta.11 trainer-routing focused validation — 2026-11-14

30 new TrainerRoutingSuite cases plus 12 existing non-UI MapSuite cases:
42 passed, 0 failed, 0 skipped (13 files), minimal wowlua 0.13.12 project
WITHOUT Blizzard UI. Standard PowerShell reporter created report/metadata/log ZIP.
[Focused output](docs/evidence/trainer-routing-focused-2026-11-14.txt).
Three faulty variants detected: omitted correction, ignored current-map ordering,
and relaxed faction eligibility. [Results](docs/evidence/trainer-routing-mutations-2026-11-14.txt).
User report CraftDeja-beta11-20261114-234149.zip verified: full 402 passed, 0 failed, 0 skipped (305 files) in 188.39s, wowlua 0.13.14 on Windows with Blizzard UI; build passed. Local Mot routing, actual wand offer and a smooth one-craft 116 -> 117 were subsequently observed/reported. This does not validate all recipes or all performance conditions.
Net-cost implementation and native crafting guards are unchanged from tested beta.10.


## Beta.12 AH quantity/event regressions — 2026-11-15

25 new AHPerformanceSuite cases, wowlua 0.13.12, camelot Windows emulation,
configured Blizzard UI on Linux. Production source with a contract fixture for
Auctionator's view; no full Auctionator/live-server or real FPS measurement.
Against beta.11 source: 7 passed / 18 failed / 0 skipped (4.32s).
Against correction: 25 passed / 0 failed / 0 skipped (3.48s).
Every run used the PowerShell ZIP reporter; see [scope and changes](docs/AH_PERFORMANCE.md).
First full beta.12 run: 426 passed / 1 failed / 0 skipped; the existing craft
interruption-resume case caught a lost invalidation. Explicit own-player craft
start/failure/interruption scheduling restored it. Focused AH + CraftPerformance
then passed 50/50. Final full beta.12 build and regression passed:
**427 passed, 0 failed, 0 skipped (306 files), 141.38s**.
Report 20261114-232733-4c0340.zip; wowlua 0.13.12, configured Blizzard UI,
camelot Windows emulation on Linux. All 15 recorded source hashes verified.
Windows-host/live performance verification remains pending. W1034 remains.
[Full log](docs/evidence/ah-performance-full-2026-11-15.txt) /
[Old-source reproduction](docs/evidence/ah-performance-before-2026-11-15.txt).


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


## Beta.13 acquisition module — 2026-11-15

Fresh base f26799d, feature/acquisition-costs. Added AcquisitionSuite.
First focused run: 29/30 passed; the NaN fixture used 0/0, which WoW correctly
throws for. Replaced with math.huge - math.huge, as in the existing net tests.
Intermediate full source: 457/457 passed (307 files, 127.30s).
Then added four fee-source/horizon edge cases and fixes. Final focused cases:
34/34 passed, 4.00s. Latest full-source regression pending below.
All runs wowlua 0.13.12, camelot Windows emulation on Linux with Blizzard UI;
PowerShell ZIP reporter used. Trainer services are fixtures, not live evidence.
Windows and actual trainer-link validation remain pending.


Final beta.13 automated validation: build passed; 461 passed, 0 failed,
0 skipped (307 files), 143.22s. wowlua 0.13.12, camelot Windows emulation
on Linux with Blizzard UI. Report 20261114-235923-cabb11.zip checked; all
18 runtime source hashes match. At that Linux checkpoint Windows-host and real
trainer-link/fee observation were pending; see the verified Windows checkpoint
in CONTINUE.md / TEST_RESULTS.md. W1034 remains.

## Verified beta.13 Windows checkpoint — 2026-11-15

Existing local report reports/tests/20261115-010908-b537ed.zip inspected in full
(summary, metadata and process log). beta.13, wowlua 0.13.14 on Windows,
configured Blizzard UI, no filters. Build passed; 461 passed, 0 failed,
0 skipped (307 files), 212.88s. Start/end: 01:09:08–01:12:42 +01:00.
All 18 recorded SHA256 source hashes match the current working files exactly.
The report records base f26799d1a383d3c4e6280bc9c36aa3fb32c34001 and then-uncommitted
beta.13 source on feature/acquisition-costs. It is source evidence, not a claim
that beta.13 had already been committed. No new run needed for this documentation
handoff; runtime source unchanged. W1034 remains. Raw report stays local.

Open user-reported live case: Mot Dawnstrider, recipe 7771, recipe item 6345,
trainer link nil, learning fee 200 copper. beta.13 requires an exact spell/enchant
link and cannot associate this nil-link fee. This is an unresolved trainer bug,
not proof of successful fee capture. Fix follows separately. Beta.14 has not
been delivered or installed. This handoff does not change main or the game installation.

## Beta.14 guarded Mot nil-link fix — 2026-11-15

Base 3ca5bbcc2aee639f91575f4b58a2eaf666a004ee, feature/acquisition-costs,
clean initial working tree. beta.13 derived recipe identity only from an exact
spell/enchant service link and therefore discarded the reported 200c fee when
Mot Dawnstrider's link was nil (NPC 11071 / recipe 7771 / recipe item 6345).
The fix uses that explicitly observed relationship plus exact client spell name
and rank, NPC GUID, catalog item relationship and ambiguity rejection. No fuzzy
matching or hardcoded fee; other unsupported nil-link offers stay unknown.

24 new tests cover successful fee capture/quote/refresh, wrong or missing NPC,
duplicate equal/conflicting offers, same-name/rank spell collisions across
professions, rank differences, missing/malformed client data, changed item
relationship, live fee changes/zero/invalid fees, exact-link precedence,
row movement, DE/EN and zero trainer/spell reads during native crafting.
All NPC/service/spell values are controlled API fixtures with the real catalog
7771 -> 6345 relationship. This does not prove successful live trainer capture.

All runs used tools/Test-CraftDeja.ps1 with automatic ZIP, full log and metadata:

- First focused attempt 20261115-135846-dc5d9d: new file failed compilation on
  two fixture type declarations; 34 existing tests passed but exit code was 1.
  Fixed fixture declarations; this is NOT a successful 34-case full scope.
- Focused intermediate 20261115-135934-962010: build passed, 58/0/0, 2 files, 6.15s.
- First full intermediate 20261115-135958-d95b4e: build passed, 485/0/0,
  308 files, 201.24s. Then the saved fee origin was standardized to existing
  source=trainer (avoids an internal identifier in recipe details).
- FINAL 20261115-140332-96c718: build passed; 485 passed, 0 failed, 0 skipped,
  308 files, 204.91s. Windows host, wowlua 0.13.14, Camelot, configured Blizzard UI,
  no filters. All 18 recorded SHA256 source hashes match the FINAL source exactly.
  ZIP summary/metadata/log inspected. This final run supersedes intermediates.

Shareable report: reports/tests/20261115-140332-96c718.zip (kept local, not uploaded).
Metadata identifies parent commit 3ca5bbc plus then-uncommitted beta.14 source;
recorded hashes bind the tested source to this correction. Existing W1034 remains.
No game installation, main merge or addon release. Successful live observation
at Mot is still pending after a separately authorized installation/retest.

## Beta.14 — Abschlussprüfung am 15.11.2026

- Trainerfix-Commit: 014381f3cc8c5197e3e268b1a35c7418a371cc8f, Branch feature/acquisition-costs; Ausgangsarbeitsbaum sauber.
- Vorhandenen Windowsbericht 20261115-140332-96c718.zip erneut geprüft: Build erfolgreich, 485 bestanden, 0 fehlgeschlagen, 0 übersprungen, 204.91s. Alle 18 aufgezeichneten Quellprüfsummen exakt identisch.
- Code, Tests, Manifest/Lockfile und Testskript unverändert; diese Abschlussrunde aktualisiert nur Dokumentation. Kein neuer Testlauf erforderlich oder behauptet.
- Automatisierte Prüfung bestanden, Live-Prüfung der Lerngebühr bei Mot Dawnstrider noch offen.
- Nächste Installation mit Backup und festem _forever_-Ziel in docs/LIVE_TEST_BETA14.md vorbereitet; wowlua install-Optionen lesend geprüft. Kein eigenes Installationsskript vorhanden. Installation nicht ausgeführt, kein Merge nach main.
- Aktuellen Abschlusscommit mit git log -1 bestimmen; Remote-Gleichheit nach Push über git ls-remote origin refs/heads/feature/acquisition-costs prüfen.

## Beta.15 — bestätigter API-Unterschied und Korrektur, 15.11.2026

- Neue Nutzer-Chatdiagnose: `1 Umhang - Schwacher Schutz available 135913 200 nil`. Bei der verwendeten Ausgabe bedeutet dies Serviceindex, Name, Status, Icon-ID, 200 Kupfer, nil-Link. Der aktuelle Client liefert kein Rangfeld zwischen Name und Status.
- Konkrete beta.14-Ursache: Acquisition.lua interpretierte available als Rang und 135913 als Status; der Fallback lehnte deshalb ab. Die bisherigen Tests benutzten nur die ältere name/rank/status-Form. Ausbleibende Ausgabe des alten GetSpellInfo-Befehls deutet zusätzlich auf fehlende globale API; das ist nicht separat live bewiesen.
- Beta.15 erkennt beide Layouts anhand bekannter Statuswerte und Typen. Bei ranglosen Angeboten wird C_Spell.GetSpellInfo mit name/spellID bevorzugt, Legacy bleibt abgesichert verfügbar. Keine erfundenen Ränge; gleiche Namen sind ohne Rangfeld mehrdeutig, auch bei verschiedenen Legacy-Rängen. Abweichende Spell-IDs/Overrides, doppelte Angebote und unklare Daten werden abgelehnt.
- NPC/Rezept/Gegenstand-Beziehung, aktuelle Gebühr, exakte Namen, vorrangige Links und native Craft-Sperre bleiben unverändert. Keine zusätzlichen Timer, Käufe oder Quellenlistenänderungen.
- 20 neue Forever-API-Regressionen. Mit beta.14-Code 70 bestanden / 8 fehlgeschlagen / 0 übersprungen (3 Dateien, 7.14s): reports/tests/20261115-184454-006099.zip. Mit Korrektur fokussiert 78/0/0 (6.77s): 20261115-184533-2afad6.zip.
- Finaler beta.15-Windows/Camelot-Lauf mit Blizzard-UI, wowlua 0.13.14: Build erfolgreich, 505 bestanden, 0 fehlgeschlagen, 0 übersprungen (309 Dateien), 213.08s. ZIP: reports/tests/20261115-184607-d24132.zip. ZIP-Protokoll geprüft; alle 18 aufgezeichneten Quellprüfsummen stimmen exakt. W1034 bleibt bekannt.
- Entwicklungsversion src/Start.lua und wowlua.json: 3.9.0-beta.15. Ausgangscommit 1186209b0f3caa66265d627a1aee4aa9db6b5f78 auf feature/acquisition-costs; vorhandene vier lokale Übergabeänderungen aus der Installations-/Live-Runde vollständig erhalten und mitgeführt.
- Im Spiel bleibt beta.14 installiert. Beta.15 wurde in dieser Runde NICHT installiert; kein Merge nach main, kein Addon-Release. Live-Erfassung bei Mot weiterhin offen. Nächster Schritt: beta.15 separat bei geschlossenem WoW mit Backup installieren und den frischen Beleg für Rezept 7771 prüfen. Keine weiteren alten GetSpellInfo-Diagnosen nötig.

## Mot-Livebeleg bestätigt — 15.11.2026, Screenshot 19:10

- Nutzerbild zeigt `CraftDeja 3.9.0-beta.15` und `7771: 200 trainer 1794766159 1794766291`.
- Damit ist die gespeicherte Lerngebühr für Rezept 7771 (Umhang - Schwacher Schutz, Rezeptgegenstand 6345) mit 200 Kupfer und Herkunft trainer im echten Client belegt. Sie passt zum zuvor ausgegebenen Mot-Angebot `available 135913 200 nil`.
- Beobachtungszeitpunkt 1794766159, Diagnosezeit 1794766291: der Beleg war bei der Abfrage 132 Sekunden alt. Es wird kein neuer Schreibvorgang exakt im Moment der Chatabfrage behauptet.
- Der konkrete Nil-Link-/API-Layout-Fall ist damit live bestätigt. Dies belegt weder alle Trainer/Rezepte noch eine vollständige wirtschaftliche Route oder die Anzeige aller Detailansichten. Das Fehlen von Mot in der separaten Referenzquellenliste wurde hier nicht korrigiert.
- Automatisierter beta.15-Testnachweis bleibt 505/0/0 (213.08s), reports/tests/20261115-184607-d24132.zip; geprüfte Installation: reports/install/beta15-20261115-185829-bericht.zip. Nur Dokumentation/Übergabe geändert, kein neuer Testlauf oder erneute Installation nötig.
- Trainerfix-Quellcommit: 106c61fa7b838096449dec6b18570d82e08a1ee7. Kein Merge nach main und kein Addon-Release. Nächster Schritt: normale Nutzung; weitere konkrete Abweichungen getrennt mit Belegen untersuchen. Für diesen Gebührenbeleg ist kein weiterer Diagnosebefehl nötig.

## Aktueller Stand — beta.16 Performance, 15.11.2026

- Nutzerauftrag: hohe CPU/Ruckler anhand Code und identischer Camelot-Messfälle untersuchen und beheben; ausdrücklich KEINE Installation und kein Merge nach main. Diese auftragsspezifische Ausnahme geht der allgemeinen Auto-Installregel vor. Im Spiel bleibt beta.15 mit bestätigter Mot-Gebühr.
- Ausgang: sauberer Branch feature/acquisition-costs, Commit 9cf3669700b55ba6bc2603ad60624021004d8ffc. Neuer Feature-Branch codex/performance-refresh, Entwicklungsversion 3.9.0-beta.16. Aktuellen Sicherungscommit mit git log -1 bestimmen und nach Push mit Remote vergleichen.
- Nachgewiesen: bekannte Erwerbskosten-Kanten wurden seit beta.13 für jeden Kandidaten/Skill erneut ausgewertet; jetzt einmal pro Snapshot/Skill und billigste Kante je gleichem Punktgewinn. Neue Snapshots invalidieren korrekt. Unabhängige vollständige kleine Routenenumerationen prüfen gleiche Lernentscheidung/Kosten auch mit negativen Nettokosten und mehreren Punkten.
- Beide Commodity-Ereigniskanäle speicherten Preise und lösten sofort volle Marktvergleiche aus. Preise bleiben synchron gespeichert; mehrere Meldungen vor einem Frame werden einmal auf dem nächsten OnUpdate verarbeitet. Explizite Kauf-/Quote-/Suchaktionen rechnen synchron neu; native Craft-Sperren erhalten. Kein zusätzlicher Zeit-Throttle/Timer.
- Versteckte Rezeptkataloge werden aus allgemeinem UI-Refresh ausgeschlossen; Öffnen und sichtbare Kataloge aktualisieren weiter. Alte manuelle Mengenregeln unverändert; vorhandene 25 AHPerformance-Fälle bestanden. Kein aktueller 101-Rücksetzfehler behauptet.
- Identische Stress-Fixture (262 Rezepte, 200 bekannt, 62 synthetische Erwerbsgebühren, Skill 117 bis Cap 150): drei Snapshots 1,235,310 -> 27,510 Wahrscheinlichkeitsauswertungen, Quotes unverändert 786. 24 Preisereignisse vor einem Frame: Markt-/UI-Berechnungen 24 -> 1, letzter Preis erhalten; 0 Rezept-Neueinlesungen. 100 gleiche Preise: 0 -> 0 Marktberechnungen.
- Nativer wowlua bench, gleicher Windows-Host/Camelot/Dev-Profil, 7 Batches à 100ms Zielgröße, identische Fixture SHA256: 2141.9962 -> 53.16255 ms je Entscheidung (unoptimiert 2162.1248 -> 54.56185 ms). Adaptive Aufrufzahl je Batch normiert. Reine Emulatorlaufzeiten, KEINE gemessene FPS-/Spiel-Framezeitverbesserung!
- Finale breite Windows/Blizzard-UI-Regressionssuite: 517 bestanden, 0 fehlgeschlagen, 0 übersprungen, 311 Dateien, 183.59s, wowlua 0.13.14. Report reports/tests/20261115-195119-54e166.zip. 12 neue Tests plus unabhängige Referenzfälle; 38 Lua-Quellhashes und sämtliche Testeingabehashes geprüft. W1034 bleibt bekannt.
- Teilbare Gesamt-ZIP: reports/performance/beta16-20261115-195714.zip. Enthält Ursachen, Änderungen, Audit, Vergleichs-JSON, Umgebung, Hashes, Vorher-/Nachher-Benchmark-ZIPs, negative Baseline-Grenzen und finale Testberichte, Grenzen und Liveplan. Rohberichte bleiben lokal. Details/Reproduktion in docs/PERFORMANCE_BETA16.md; automatische Erstellung über tools/New-PerformanceReport.ps1.
- Standardmäßig AUS: /cdj perf start aktiviert höchstens 30s feste Funktions-/Eventzählungen, inklusive/exklusive/max Zeiten; /cdj perf stop stellt Originalfunktionen/Handler wieder her, /cdj perf show zeigt kopierbaren Bericht. Keine Argumente/Chat-/Charakter-/Kontodaten, kein dauerhaft laufender Diagnose-Timer. Generierten Dev-Code gegen gestapelte Monitor-Wrapper geprüft.
- Noch offen: Zuordnung der konkreten Live-Spitzen (historisch 12.89 ms/f, neu gezeigt 2.66 ms/f) und tatsächliche Spielverbesserung. Lokales Auctionator 346 lesend geprüft; Vertragstests laden nicht das vollständige Addon. Nach später separat beauftragter Installation exakt 30s AH-Angebot öffnen, kleinere manuelle Menge eingeben, warten, /cdj perf show kopieren; kein Kauf nötig. Bis dahin keine Live-CPU-Besserung behaupten.

## Beta.17 — Folgeprüfung nach Live-Aufnahme, 15.11.2026

- Nutzer meldet beta.16 besser, verbleibendes Ruckeln. Screenshot: CraftDeja 10.9%, 3.89ms/f; kein kontrollierter Vergleich. 30s-CPU-Aufnahme: 9 Refreshs, max. 171.212ms; 216 selectionAt, 63984 probability; 363 Gegenstandsereignisse. Messoverhead enthalten, keine konkrete Auctionator-Endlosschleife bewiesen.
- Weitere nachgewiesene Arbeit korrigiert: unmögliche Skill-/Zugangs-/Statuskandidaten vor Wahrscheinlichkeit ausschließen, ungeprüfte Quellen gesondert erhalten; Gegenstandsinteresse per Rezepttabelle indizieren statt vollständiger Suche je Metadatenereignis. Index nach Rezeptlesung invalidiert. Keine neue Drossel oder Mengenänderung.
- Identische synthetische gemischte 262-Rezept-Fixture: 8908 -> 1088 Wahrscheinlichkeitsauswertungen; native Windows/Camelot/wowlua 0.13.14-Zeit 35.421267 -> 9.928720ms je Entscheidung (unoptimiert 34.950167 -> 9.915473ms), sieben Samples. Nicht die echte Katalogzusammensetzung, kein Spiel-FPS-Beleg. 480 differenzielle Auswahlvergleiche bestehen.
- Finale suite beta.17: Build bestanden, 520/0/0, 312 Dateien, 207.86s. reports/tests/20261115-202609-aaf84c.zip. Gesamtbericht reports/performance/beta17-20261115-202609.zip mit Live-CPU-Auszug, Roh-ZIPs, Vergleich und 38 Quellprüfsummen. W1034 bleibt bekannt.
- Branch codex/performance-refresh, Basiscommit 243cf9803e7b783161bd33d8565de7c2b7481fc1; Quellsicherungscommit mit git log bestimmen. Vorhandene drei lokale Installationsübergaben beta.16 vollständig erhalten und mitgeführt. Details, verworfener Versuch und Grenzen: docs/PERFORMANCE_BETA17.md.
- Aktuell zur Installation vorbereitet; bestätigten Installationsbericht separat beachten. Offen bleibt die tatsächliche Wirkung von beta.17 im Client. Nächster Schritt: gleicher AH-Ablauf, kleine manuelle Menge; zunächst ohne Diagnose, dann 30s /cdj perf start und /cdj perf show. Kein Kauf nötig, Spitzen nach Phase unterscheiden. Kein Merge nach main.

## Peak >100 / Speicherhypothese: Dev-Release-Vergleich vorbereitet — 15.11.2026

- Neue Beobachtung: mehr aktive Addons scheinen Ruckeln zu verstärken. Paar CraftDeja+Kela und anschließend kumulativ Companion/Loot Sparkles/Quest Tint, ForeverQuestMark/GearQuest, LFG Bulletin Board, RogueEnergyCombo, ForeverDungeonJournal jeweils flüssig. Weitere Addons dann ohne vollständige Liste aktiviert, Freeze wieder vorhanden. Kein einzelner Partner isoliert.
- Lokalen Freeloader-Code verifiziert: Peak >100 = vom Client CraftDeja zugeordnete Framezeit über 100ms, keine RAM-Prozentanzeige. Spitzenwert ca. 10s gehalten; daraus keinen zehnsekündigen Freezezyklus ableiten. Screenshot 9.4%, 3.34ms/f, 28FPS und KB/s-Striche enthält keine Speichertrendmessung. GC/Heapdruck plausibel, Speicher voll/Leak unbelegt.
- Installierter beta.17-dev+59bee85 sammelt zusätzlich zur optionalen /cdj-perf-Aufnahme ständig automatische wowlua-Funktions-/Handler-/Zeit-/Speicherstatistiken. Dieser gemeinsame Kostenfaktor wurde bisher nicht im kontrollierten Livevergleich entfernt. Keine weiteren Addons einzeln als Verursacher behaupten.
- Gleicher Quellcode als Release-Vergleich gebaut: dist/release/CraftDeja, automatische Compilerkennung 3.9.0-beta.17-alpha+a1362f0. Kein automatisches __wl.prof/__wl.mon/__wl.perf gefunden; TOC ohne Dev-Runtime/Dev-SavedVariable. 73 Dateien, 2757338 Lua-Bytes gegen 117/3005234 im Dev-Artefakt; Dateigrößen sind keine gemessenen Heap-/CPU-Werte.
- tools/Test-CraftDeja.ps1 unterstützt jetzt -Profile dev|release für Build/Benchmark (Default dev). Native test hat KEINEN Profilselektor; Metadaten trennen buildProfile und source-emulator testMode. Erster Versuch 213806-e02211 scheiterte nach Build am falschen test --profile, keine Tests als bestanden ausgegeben; nach Hilfeprüfung korrigiert.
- Release-Build erfolgreich und komplette Quellsuite 520/0/0, 312 Dateien, 221.77s: reports/tests/20261115-213837-0c6669.zip. Dies ist keine Ausführung des gebündelten Release-Artefakts und kein Live-FPS-/GC-Beleg. W1034 bleibt bekannt. Laufzeitquellen unverändert gegen beta.17; keine neue Fachkorrektur.
- Bericht/gesicherter Kandidat unter reports/performance/dev-release-ab-20261115-213935; teilbare ZIP gleichnamig. Details docs/PERFORMANCE_RUNTIME_AB.md. Spielinstallation bleibt beta.17-dev+59bee85; Release-Kandidat in dieser Untersuchungsrunde nicht installiert. Nächster gezielter Vergleich: abgesicherter Dev->Release-Wechsel bei gleichem Addonset/Ort/Fenster, dann 60–90s Leerlauf; keine gleichzeitige Änderung von Grafik, scriptProfile oder Addongruppen. Kein Merge/Releasepublish.

## beta.18 Kostenübersicht und Produktanalyse — 16.11.2026

- Ausstehende beta.17-Uploadnotizen auf codex/performance-refresh gesichert: 03d1b9bb749515f1cbe93b93c2ecd47edd50afaf, Remote bestätigt. Upload-ZIP und DE/EN-Patchnotes unverändert in dist/packages; kein CurseForge-Upload durch den Agenten.
- Neue Arbeit isoliert auf codex/plan-cost-overview, Basis 03d1b9b. Ziel: zuverlässiges, günstiges Forever-Leveln; kein unbelegtes Bestes-Addon-/Globaloptimum-Versprechen. Code und primäre Projektseiten geprüft. Priorisierte Analyse samt Abnahmebedingungen: docs/PRODUCT_PLAN.md.
- Erster implementierter Baustein beta.18: Rezeptdetails trennen Materialwert des angezeigten Plans, verwendeten eigenen Bestand, geschätzten Zukauf und Nettomaterialwert mit bestätigtem Händlererlös. Bei unbekanntem Bestand explizite Schätzung; Lern-/Rezept-/Voraussetzungskosten können extra sein. Post/Pendenzen und Packungsreste erklärt. Kein neues Kaufbudget, keine Änderung von Rankings/Kaufmengen/Spielaktionen.
- Kosten werden aus vorhandener Quote und Materialplanung berechnet: keine zusätzlichen Preis-/Inventarabfragen, keine neuen Timer/Scans. Details DE/EN, Gifte-Sonderpläne ohne Kostenblock unverändert. Produktion ab 300 und vollständige Mehrrezeptroute damit noch nicht erweitert.
- Neun neue fokussierte Tests: 9/0/0, reports/tests/20261116-043301-ae0b92.zip. Finaler Release-Build erfolgreich; komplette Windows/Camelot-Quellsuite 529/0/0, 313 Dateien, 208.60s, wowlua 0.13.14: reports/tests/20261116-043439-116912.zip. Quellhashes vollständig aufgezeichnet. Native Quellemulation bleibt von Ausführung des kompilierten Release-Bundles getrennt; keine neue Live-Bestätigung behaupten. W1034 unverändert bekannt.
- README-Version/Teststand und widersprüchliche alte Erwerbskostenangaben korrigiert. Produktziel-Roadmap: P0 Release-Betrieb, P1 Kostenklarheit (erster Baustein umgesetzt), danach vollständiger Zielskill-Vergleich bekannter Rezepte, mehrstufige Erwerbs-/Voraussetzungskosten, Zwischenprodukte, Budget/Preistiefe, Datenvertrauen und wiederaufnehmbare Mehrschritt-Aufträge.
- Installationsstatus separat anhand aktuellem Bericht prüfen; bis zur bestätigten Installation bleibt beta.17 Release im Spiel. Nächster Live-Check beta.18: gleiche Addons, 60–90s Leerlauf, Rezeptdetail mit Teil-/Vollbestand; Zukauf ändert sich mit Bestand, Materialwert nicht. Keine weitere Profession/Quelle als garantiert geprüft ausgeben.
