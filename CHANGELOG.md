# CraftDeja 3.9.0-beta.20

# CraftDeja 3.9.0-beta.23

- DE: Neues Goblin-Werkstattpult mit Navigation, Rezeptabschnitten und Schrittdetails; eigenständiger Guide mit sichtbaren Gründen, aufklappbaren Details und neuem grünen Hauptbutton. Eigene hochauflösende Smoke-Glass-/Messing-/Goblin-Assets, aktuelle Materialprojektion und abgesicherte Aktionswechsel.
- EN: New goblin workshop console with navigation, recipe sections and step details; standalone guide with visible status, expandable details and a new green primary action. Original high-resolution glass/brass/goblin assets, current material projection and guarded action changes.
- Patchnotes: docs/PATCHNOTES_beta23_DE_EN.md. Implementierung, Quellen, Emulatoransichten und offener Live-Test: docs/WORKSHOP_BETA23.md. Finale Suite 612/0/0; vier UI-Fälle je 12/0/0.

# CraftDeja 3.9.0-beta.22

- DE: Erweiterte ortsabhängige Lehrerwahl, zuverlässiges Wiederöffnen über das Berufsfenster, verschiebbarer Minimap-Button und direkter Eintrag in Optionen → Addons.
- EN: Expanded location-aware trainer selection, reliable profession-window reopening, draggable minimap access and a dedicated Options → AddOns entry.
- Patchnotes: docs/PATCHNOTES_beta22_DE_EN.md. Nachweise und Grenzen: docs/TRAINER_NAVIGATION_BETA22.md; breite Suite 600/0/0.

# CraftDeja 3.9.0-beta.21

- DE: Geplante Bankmaterialien gezielt einlagern und später entnehmen, bestätigte Mengen und klare Fortsetzung bei Platzmangel. Automatisches Öffnen beim Händler dauerhaft einstellbar.
- EN: Deposit planned bank supplies and withdraw them later, with confirmed quantities and clear continuation when space is limited. Persistent setting for automatically opening at merchants.
- Spielertexte: docs/PATCHNOTES_beta21_DE_EN.md. Analyse und offene Live-Prüfung: docs/BANK_FLOW.md. Automatisierte Prüfung: 589/0/0, TEST_RESULTS.md.

- DE: Feste Routenabschnitte, zuverlässiger Abschluss laufender Vergleiche bei Inventarereignissen und Bankhinweise für spätere Materialien. Native Herstellung bleibt sichtbar; aktuelle Kaufprüfungen erhalten.
- EN: Fixed route sections, route searches that finish despite inventory updates, and bank guidance for later supplies. Native crafting stays visible while purchase checks remain current.
- Player notes: docs/PATCHNOTES_beta20_DE_EN.md. Cause, regression evidence and live retest: docs/ROUTE_CHECKPOINTS.md.

# CraftDeja 3.9.0-beta.19

- DE: Mehrstufige Levelrouten mit Zwischenprodukten, Mengenpreisstufen und getrennten Zahlungs-/Nettokosten. Geplante Lehrerrezepte, eigene Twinks und optionale Gildenquellen für ausgewählte Werkzeuge. Gespeicherte Aufträge mit dauerhaft wählbarem AH-Weg.
- EN: Multi-stage leveling routes with intermediate outputs, quantity price tiers and separate payment/net estimates. Planned trainer recipes, your alts and opt-in guild sourcing for selected tools. Saved orders with a persistent AH preference.
- Full player patch notes: docs/PATCHNOTES_beta19_DE_EN.md. Calculation evidence, explicit bounds and live acceptance: docs/MULTI_STAGE_ROUTES.md; automated results: TEST_RESULTS.md.

# CraftDeja 3.7.0-beta.1

- Add local recipe observations while reading the opened profession window:
  unknown IDs, complete ingredient-group differences and difficulty discrepancies.
- Client ingredient data continues to drive the current character's cost/material
  calculations. Observations never automatically rewrite the shipped catalogue.
- Ignore incomplete ingredient data for comparisons. Canonicalize ingredient/group
  and alternative-item ordering to avoid false reports. Deduplicate repeated reads.
- Preserve observations across sessions and skill changes. Resolve matching older
  observations only when a new reference-data revision is inspected. Bound storage
  to 200 observations per character; count evictions explicitly.
- Add Recipe check in the adviser, a visible data-package date and report count,
  and the copyable /cdj data (alias /cdj audit) report window with corner scaling.
- Include recipe/profession IDs, ingredient changes, client build, locale, faction,
  character level and profession skill in reports. No character name, account, realm
  or chat text is exported. Show a single local chat notice per profession/session.
- Append at most 20 recent observations to /cdj log; the full report remains in
  /cdj data. Copying/sharing stays voluntary; there is no upload from the addon.
- Package date 2026-11-12 / reference revision 2026.11.12.1 describes the bundled
  snapshot, not a claim that all recipes were reverified that day. External review
  is recommended weekly and after major patches; the addon does not access websites.

# CraftDeja 3.6.0-beta.6

- At a profession cap, compare the known rank requirement with the player's
  character level. Below that level, the main instruction now says to level first,
  rather than directing the player straight to a trainer.
- Show required and current character level prominently in Next step and adviser.
  Keep an optional Show trainer for later action; do not auto-mark a new trainer
  while the character-level gate is active.
- React immediately to PLAYER_LEVEL_UP, including the interval before UnitLevel
  reflects the event. Restore normal trainer guidance once the requirement is met.
- Unknown player levels or missing requirements do not produce invented blocks.

# CraftDeja 3.6.0-beta.5

- At a profession skill cap, automatically mark a matching rank trainer using the
  CraftDeja map logo. Next step shows the name, coordinates and rank requirements.
- Enable Show trainer on map to open the target map and restore the marker.
- Select by exact profession/rank and faction; prefer a known location on the current
  map. Do not infer that a nearby apprentice teaches higher ranks.
- Add 49 rank/location entries for 44 NPCs across nine professions. The existing
  licensed AllTheThings Camelot snapshot supplies rank/location facts; Doctor Marsh's
  Undercity Journeyman location is supplemented from Wowhead Forever npc 4609.
- Clearly label reference locations. Book-based rank sources instruct buying/using
  the book. Unknown trainers remain an explicit fallback, without a guessed pin.
- Re-evaluate automatically when the client reports the new profession cap.

# CraftDeja 3.6.0-beta.4

- Show all confirmed outstanding material deliveries together in Next step,
  instead of overwriting the mailbox instruction with the last purchased item.
- Show the following vendor quantities and crafting stage below the collection list.
- Replace the mailbox task's misleading Material details action with Check collected
  mail. It polls real stock and refreshes the task, without declaring collection.
- Size mailbox task text and continuation panels to their row counts.
- Automatic inventory polling continues to advance partial collection, vendor buying
  and crafting availability; no remote mailbox access or automatic travel is implied.

# CraftDeja 3.6.0-beta.3

- Synchronize Auctionator's native quantity field with the full affordable route
  quantity as soon as offers are displayed, including purchases spanning price levels.
- Before requesting a quote, read back the native selected quantity, visible numeric
  input and aggregate price. Block the action on a mismatch or failed update.
- Log requested/selected/displayed amounts and copper total as ah.quantity.check.
- Retains Beta 2's full-route quantity fix and scan-generation/freshness locks.

# CraftDeja 3.6.0-beta.2

- Lock Next step's price-dependent actions and the AH shopping button until a
  successful current full scan is ready and Auctionator's native scanner is idle.
  Hide stale adviser cost/route fields while waiting. Guard search, offer loading,
  quantity prefill, quote registration and confirmation again at the action entry.
- Stage ScanComplete data when the native scanner is still busy; release it only
  after idle in the same AH epoch. Closing the AH drops pending completion.
- Expire the 30-minute price window using both wall clock and client timer so an
  eight-hour pause cannot preserve freshness if the client timer stopped. Reuse
  within 30 minutes across AH visits remains supported; live quotes do not extend it.
- Fix two leftover purchase-path calls that silently forced the remembered manual
  +5 target. Loading a commodity and registering its quote now respect Next action.
- Tie displayed plans and quotes to the successful scan generation. Old callbacks
  are rejected after a new scan; generation is intentionally excluded from purchase
  budget keys so rescanning never restores already-bought quantities.
- Pause managed native quantity/quote controls on invalidation while preserving
  confirmed pending transactions and later receipt/mail bookkeeping.
- Observe COMMODITY_SEARCH_RESULTS_UPDATED directly to reprice live offers even
  if a widget hook misses the update. Label the limit as current AH data + tolerance.
- Log scan start, validated completion, release and blocked purchase actions.

1137 assertions across 95 simulated scenarios pass, plus three original Auctionator
344 commodity confirmation/purchase contract probes. The supplied trace had already
received a completion before Search was clicked; it does not prove use of yesterday's
scan. It does prove the full-route list was reduced back to the manual five-point
quantity during item loading. New guards and that reduction are covered separately.
Live-client validation remains pending.

# CraftDeja 3.6.0-beta.1

- Default shopping to the next decision/action instead of the remembered +5 skill
  points: recipe switch/learning, profession rank cap or the safe review boundary.
  Automatic plans may exceed 50 skill points. Preserve manual 1-50 planning as an
  explicit slider mode, with a button to return to Next action. Existing inventory,
  confirmed mail, vendor prices and per-purchase reservations still apply.
- Show remaining estimated crafts, target skill and the following action in Next
  step. Show rank training (e.g. 75-150) or an immediately required learned recipe
  before shopping past it. Vendor planning uses the same selected target.
- Emphasize important mail/vendor/bank/learning/native-confirmation tasks with a
  larger golden message, IMPORTANT title and pulsing background. Text stays opaque
  and readable; the effect ends when the task changes.
- Add a non-interactive, pulsing downward arrow anchored to the real profession
  button. Point to Create all only when its actual craftable count equals the safe
  planned amount. Otherwise point to the exact prepared Create button. Hide during
  casting, unrelated recipe selection, closed/hidden controls and queue execution.
- Keep physical native confirmation. No protected craft/start/stop call or scripted
  native button click is added. The new user trace confirms the previous prepared
  four-craft native series completed, as well as a later two-craft series.
- Retain the frozen purchase budget; goal changes are blocked while a purchase
  awaits its result and unchanged goal values never unlock an existing batch.

1090 assertions across 89 simulated scenarios pass. German Next-step/mail and
shopping layouts rendered and inspected with test data. The new in-game arrow,
pulse and automatic-goal integration still require live-client validation.

# CraftDeja 3.5.0-beta.5

- Respond to the client-confirmed ADDON_ACTION_BLOCKED from beta 4's CraftRecipe
  dispatch. Remove addon-issued craft/start/stop calls and scripted native clicks.
- Prepare the selected native recipe and an exact bounded quantity only. Highlight
  its real Create button; the player confirms there. Rename adviser buttons to
  Prepare 1 / Prepare all (N), with a clear native-confirmation task and Back.
- Do not claim that preparation started crafting. Only actual player cast-start or
  success events begin batch tracking; native completion/interruption updates it.
- Preserve the real native button handler. Recipe/quantity changes and profession
  closure clear the pending handoff/highlight. The helper never clicks a native
  button, calls its handler, or retries protected actions automatically.
- Stopping is an instruction to use native controls/Esc, not a silently blocked
  stop API or a claim that the cast was cancelled.
- Update the compact CurseForge description to state the native confirmation step.

1030 assertions across 83 simulated scenarios pass. Regressions reject any addon
CraftRecipe / Click / Create dispatch, verify prepared 1/4 counts and unchanged
native handlers, and simulate a separate user's native click plus four completions.
The German prepared-state layout was rendered and inspected. Real-client
confirmation of the prepared native craft still needs testing.

# CraftDeja 3.5.0-beta.4

- Address the recorded no-start path: the native UI accepted quantity 4 and
  returned nil without a craft cast or material change. Dispatch directly to the
  documented C_TradeSkillUI.CraftRecipe once per user click, passing the selected
  native transaction's reagent allocation, recipe level and concentration flag.
  Do not call the UI Create callback or automatically retry a nil-return request.
- Track requested versus confirmed-running batches. A start or successful cast
  event confirms activity. An idle unconfirmed request expires after five seconds
  with a no-start notice and log entry, rather than pretending a batch ran.
- Capture ADDON_ACTION_BLOCKED / FORBIDDEN for CraftDeja, including synchronous
  rejection, without bypassing the client's restrictions or starting a second request.
- Keep queue material rows tied to the requested/remaining craft count. Every
  renderer uses the queue plan, preventing the recorded 5/64-plan oscillation.
- Log changed profession-read summaries, omit unrelated addon-load and spell
  events, and keep meaningful cast-start, dispatch, result and block information.

1017 assertions across 83 default scenarios pass. An opt-in comparison against
Forever's original transaction:CraftRecipe reaches 1032 assertions / 84 scenarios.
These are local contract/simulation checks. The log identifies the no-start path
but does not establish why the old UI callback did not issue a cast on the client;
server-side success of the new dispatch still needs in-game verification.

# CraftDeja 3.5.0-beta.3

- Fix the client-confirmed log-window failure: FontInstance:SetFont requires
  explicit font flags on this client. Supply an empty flags string in both
  diagnostic EditBoxes and all shared plain-font calls.
- Match that contract in tests: missing flags now raise an error, including in
  the UI mock. Both /cdj log and the Info button reach the corrected EditBox.
- Report future log-window construction/export errors directly in the chat,
  with addon version, instead of leaving a silent button.
- Add /cdj version. Keep the beta 2 crafting path unchanged pending the client's
  actual craft log; this release does not claim to solve the unconfirmed batch issue.

999 assertions in 80 default scenarios; 1007 assertions in 81 scenarios with the
unchanged Forever native craft source probe. Real client verification is pending.

# CraftDeja 3.5.0-beta.2

- Fix /cdj log and the Info button: remove the unsupported EditBox:GetStringHeight
  call, use EditBox:GetNumLines and keep the window construction retryable.
- Correct the UI mock to reject FontString-only methods on EditBox. Test both the
  real Info-button callback and slash-command dispatcher, including reopening.
- Prefer the native profession Create path: select/verify the recipe, set and
  verify its quantity control, then call native Create with its reagent transaction
  and recipe level. Do not fall back to a second request after a native failure.
  Clients without that native page retain the documented direct API fallback.
- Log native quantity acceptance, creation result and early queue termination with
  completed/remaining amounts. Catch native setup errors without leaving a stale batch.

992 assertions in 79 simulated scenarios pass. An additional opt-in probe uses
Forever's original Create, CreateInternal and transaction:CraftRecipe functions:
1000 assertions in 80 scenarios pass with that probe. Real client validation remains
pending; this does not claim four server-confirmed in-game crafts.

# CraftDeja 3.5.0-beta.1

- Prefer crafts already possible from current bag materials before buying the
  remaining shopping-plan amount. Four available crafts no longer become an AH
  task merely because the full five-craft plan is one reagent short.
- Add separate Craft 1 and Craft all (N) buttons. Native batches are bounded by
  bag stock and a conservative skill/recipe boundary; track progress, interruptions
  and queue end. Stop is offered while running; unsupported cancellation reports
  that the native profession window must be used.
- Add an enabled-by-default persistent flow log capped at 500 entries per character.
  Record changed task/material states, explicit UI clicks, profession/AH events,
  API requests/results, purchase state and relevant game/Lua errors. Repeated
  unchanged state is suppressed. Existing Lua-error handlers still receive errors.
- Add an Info log button to Next step and /cdj log with selectable export, refresh,
  pause and clear controls. No chat or account credentials are recorded.
- Foreground Auctionator's Shopping tab before loading a planned commodity when
  its parent is hidden; use actual visibility rather than merely IsShown.

972 assertions across 76 simulated scenarios pass, plus the existing actual
Auctionator 344 purchase-contract probes. Native in-game validation is pending.

# CraftDeja 3.4.0-beta.4

- Freeze each purchase batch's remaining allowance. Polls, automatic scans, AH
  close/reopen and stale inventory cannot restore a completed quantity. A genuine
  completed craft, changed skill goal/material choice or explicit new-plan action
  is required for a new batch; confirmed mail remains deducted.
- Reserve an explicit commodity confirmation until its game result. Handle both
  item-specific and generic success, correlating the latter with confirmation
  intent even when success is synchronous. Deduplicate both event variants.
- A missing result blocks repeated buying and exposes diagnostics; a confirmed
  failure releases the reservation without pretending that anything was bought.
- Clear the managed native Auctionator quantity when its batch is complete and
  disable the zero-quantity button. Unrelated items remain outside this control.
- Consume fresh commodity offers/quotes as live price observations and re-evaluate
  route/cost/price ceilings. A one-copper change no longer silently relies on the
  previous full-scan minimum; updated costs still require an explicit click.
- Show needed, owned, confirmed-mail, in-flight and outstanding counts. Add
  /cdj diagnose with recent purchase events and batch/transaction state.

924 assertions across 70 simulated scenarios pass, plus three real Auctionator
344 code probes, including generic-only synchronous purchase success. No live
client session is available; in-game verification remains necessary.

# CraftDeja 3.4.0-beta.3

- Fix profession recognition when the AH and native profession are open together.
  The old AH guard blocked all recipe reads, even after an explicit profession
  opening. Allow reads with a genuine profession-open signal/visible native panel.
- A successful profession-opening button now registers the opened profession
  directly and schedules data reads, even if the usual show event is missing.
- Keep loading separate from closed: retry delayed profile/empty recipe data,
  retain the task window and show a loading message until client data arrives.
- Preserve a visible profession across AH-show event ordering. A cheap native
  visibility check repairs missed show events; hidden AH panels still do not read
  profession recipes or reopen the crafting window.
- Allow the actual one-craft action with both native windows visible; do not
  repeatedly reopen an already-open profession just because the AH flag is set.
- No suitable priced recipe now offers recipe review, rather than falsely asking
  to open an already-recognized profession.

859 assertions across 64 simulated scenarios pass. This includes simultaneous
AH/profession visibility, delayed data, empty recipe lists and missing show events.
Live client behaviour still needs verification.

# CraftDeja 3.4.0-beta.2

- Fix Next step buttons that previously only showed the adviser: open the real
  native profession via OpenTradeSkill, select the recommended recipe when the
  native page supports it, and start one ordinary craft per deliberate click.
  Revalidate recipe and bag reagents first; report unsupported/blocked actions.
  Enchanting still needs a manually selected target in the profession window.
- Show the craft output/spell icon and planned craft count in Next step. Show
  output item quantity/range as well when the client supplies yield data.
- Fix the search-submitted -> mailbox error. A submitted list is not a purchase.
  Track COMMODITY_PURCHASED itemID/quantity, including synchronous confirmation,
  partial purchases and collected materials. Generic success alone proves no item.
- Add explicit Next step commodity-buy actions: load the planned item, show live
  affordable quantity/cost, request the quote, then confirm it by a user click.
  Recheck changed prices, cap by available offers and preserve price warnings.
- Keep manual/native Auctionator buying available; unsupported item categories
  give a visible instruction instead of a false purchase status.

826 assertions across 61 simulated scenarios pass, plus actual Auctionator 344
quantity-confirmation and BuyClicked/quote/purchase-event contract probes.
Native rendering, crafting and live purchases still need in-game verification.

# CraftDeja 3.4.0-beta.1

- Keep Next step independent from the shopping result. Restore it every time a
  profession or AH opens; replace its task during scans, recipe changes and missing
  data instead of hiding it. Closing shopping no longer dismisses the task window.
- Start an Auctionator full scan automatically when prices are missing/expired at
  the AH, including a new scan after the 30-minute validity period. Follow the
  configured replicate/summary mode, respect cooldowns and throttling, defer while
  the commodity buy panel is open, and retry failed attempts after a backoff.
- Keep the previous mail/repeat-search lock across automatic refreshes.
- Fill CraftDeja commodity quantities in Auctionator's purchase and extra quantity
  confirmation fields. Only matching planned items, remaining quantities and
  price ceilings qualify; unrelated purchases are untouched. A purchase still
  needs the user's confirmation click. Successful purchases reduce the allowance.
- Update the in-game guide for automatic scanning and quantity preparation.

771 simulated assertions / 57 scenarios pass. Additional probes execute the real
Auctionator 344 scan and confirmation-dialog code. Live game testing is pending.

# CraftDeja 3.3.0-beta.3

- Add a bottom-right drag grip to every addon window. Scale each window separately;
  saved scales survive reload. Main +/- buttons and /cdj scale reset all windows.
- Move button and reagent icons to an explicit foreground layer; place native
  button backgrounds behind them. Reject empty/zero item icon IDs and add API
  fallbacks plus a visible question mark while item data is unavailable.
- Replace the stock shopping slider with a wide violet track, golden circular
  thumb and boxed 1 / 50 endpoints matching the shopping artwork.

Validation: 724 assertions across 52 scenarios using simulated client APIs.
Live frame layering and mouse interactions still require checking in Forever.

# CraftDeja 3.3.0-beta.2

- Add a small Next step window with concrete quantities and actions: vendor,
  AH search, mailbox collection, bank withdrawal, alt transfer or crafting.
- Automatically mark the suggested compatible vendor and display whether the
  marker could be set; otherwise keep coordinates visible.
- Keep walking instructions after leaving the AH, update from inventory changes,
  and respect closing the instruction window until the task changes.
- Colour each skill-range label and its numbers orange, yellow, green or grey.

Automated validation: 682 assertions / 49 scenarios. Native map and merchant
behaviour still requires testing inside WoW Forever.

# CraftDeja 3.3.0-beta.1

- New rounded Goblin-themed windows, CraftDeja branding and distinct colored action icons.
- Compact shopping panel with material icons, counts, status colors and hover details
  for storage locations, vendor suppliers, prices and buying rules.
- Larger CraftDeja logo marker on supported world-map canvases, alongside the native
  waypoint. Hover for supplier details; Ctrl-click the logo to remove it.
- A matching reagent vendor now opens a compact purchase popup automatically.
  Select a material and explicitly buy at most one stack per click.
- Show actual bundle-rounded quantity and total gold price before buying; recheck
  prices, stock and available money, then wait for bag confirmation before another purchase.
- Exclude limited-stock/currency offers and vendors that are more expensive than
  a known AH quote. Keep the 30-minute full-scan requirement for AH shopping.
- Replace unsupported text glyphs that appeared as squares.

Beta: native merchant purchases and map rendering still require testing in Forever.

# CraftDeja 3.2.0-beta.1

- Redesigned shopping view with clear storage locations: current bags, personal
  bank, account bank and saved material counts on other characters.
- Per-character persistent snapshots with timestamps; log in each alt and open
  its bank once. Unknown banks remain visibly unknown.
- Optional alt-stock deduction, off by default. Only confirmed unbound items on
  same-realm/same-faction characters can reduce the shopping quantity.
- Count the shared account bank once, independent of the number of alt snapshots.
- Highlight amounts to collect from your bank or transfer before crafting.
- Add compatible merchant locations/coordinates for ordinary supplies, including
  164 NPC references; record actual unlimited-stock vendor visits as well.
- Prefer the closest recorded compatible vendor on the current map; local nearby
  notices are throttled. Vendor dialog includes coordinates and a Map pin button.
- Native waypoint support is feature-detected; unsupported clients get coordinates.
- Keep the 30-minute scan lifetime, vendor price ceilings and all previous fixes.

New bank/character/map workflow still requires testing inside WoW Forever.

# CraftDeja 3.1.0-beta.5

- Successful AH scans are valid for 30 minutes from completion and survive
  closing/reopening the AH during this login session; no rescan on every visit.
- Retain the repeat-search/mail lock across AH visits as well.
- Add faction-aware reference buy prices for 36 ordinary vendor reagents from
  unlimited, gold-only merchant offers; actual observed prices take precedence.
- Prefer vendor reagents when the AH is equal or more expensive. Allow cheaper
  AH offers with a strict vendor ceiling even when scan-price tolerance is enabled.
- Show AH/vendor/already-owned material counts and explain stock deductions.
- Include all missing non-vendor reagents in the same Auctionator search.

# CraftDeja 3.1.0-beta.4

- Fix: recognize both Auctionator full-scan modes: replicate/get-all and complete
  summary/browse scans, including the Scan button in Auctionator 344.
- Read summary item IDs, per-unit minimum prices and quantities from the completed
  scan result; do not treat ordinary price/search updates as a full scan.
- Show shopping wait/error/ready messages directly in CraftDeja's main window.
- Preserve all previous profession-window, guide and shopping fixes.

# CraftDeja 3.1.0-beta.3

- Fix: CraftDeja remains independent when opening the AH closes Blizzard's crafting panel.
- Retain the last fully read profession, skill and recipes for AH shopping.
- Cancel queued profession refreshes at AH opening and avoid live recipe reads there.
- Generic skill notifications no longer discard the cached profession.
- A known queued craft finishing after closing the profession invalidates its old snapshot.
- Keep the adviser visible after handing shopping to Auctionator; respect manual hiding.
- Update German/English guide and show a saved-profession label.

# CraftDeja 3.1.0-beta.2

- New five-step in-game guide on the first page at first login after this update.
- Explains profession setup, Auctionator/TSM requirements, full scanning, craft
  advice, skill-target shopping, purchase confirmation and collecting mail.
- Remembers acknowledgement; reopen anytime with Guide or /cdj help /cdj guide.
- German/English guide uses the existing compact main window and scaling.
- Shopping logic and recipe data unchanged from beta.1.

# CraftDeja 3.1.0-beta.1

- New compact AH shopping panel; opens only after a successful Auctionator full scan.
- Slider for 1–50 desired skill points; caps at the next recipe/rank/green limit.
- Fresh scan prices, inventory deduction, separate vendor materials and estimates.
- Exact-name, quantity and per-unit price-ceiling handoff to Auctionator.
- Adjustable +0/5/10/20% scan-price ceiling; purchases confirmed in Auctionator.
- Scan failure/closure/expiry protection and repeat-search/mail reminder.
- English/German UI, shared scaling and retained shopping preferences.
- Requirements moved to the beginning of the CurseForge description.
- Existing faction filters and independent current/next source links retained.

Beta: new AH workflow still needs in-game testing in WoW Forever.

# 3.0.1-beta.1

- Added separate Details / link actions for the current and next recipe.
- Recipe-item, craft-spell, quest and NPC URLs can be selected independently.
- Source details include quest givers and map coordinates where available.
- Audited all 2,508 catalogue records for acquisition faction: 1,743 classified,
  765 unknown. Unknown unlearned sources are excluded by default, with an opt-in.
- Added automatic character-faction filtering to recommendations and a catalogue
  switch between own/all factions. Existing settings and window scale are retained.
- Fixed the Kaldorei Spider Kabob learning hint for Horde characters; its Alliance
  quest and Zarrin source are preserved for browsing. Learned tradeable recipes
  remain usable across source factions.
- Added attributed MIT faction/source reference facts from AllTheThings Forever.
- 345 assertions passed with simulated WoW APIs; the update still needs in-game testing.

# 3.0.0-beta.2

- Renamed to CraftDeja: folder, TOC, title, global namespace and saved variables.
- Commands /cdj and /craftdeja; /edj retained as a compatibility alias.
- Complete existing multi-profession catalogue retained.

# 3.0.0-beta.1

- Fresh implementation in a separate application/settings namespace.
- Nine crafting professions, including Enchanting and Alchemy.
- German/English interface and reference recipe names; live game-language names first.
- Compact scalable, draggable adviser with independent generated artwork.
- Current craft, next recipe/learn hint, sources and colour ranges.
- Searchable offline catalogue, explicit client-unconfirmed states and data provenance.
- Price-aware skill-point comparison, bounded green continuation and shopping estimates.
- Live mandatory reagent choices, owned material subtraction and Alchemy cooldowns.
- Event-driven recalculation after casts, plus three-second local-cache refresh.
- MIT first-party source, preserved MIT data attribution; no old Capper runtime.
- Mocked API/UI tests. In-game Forever testing remains required before stable release.
