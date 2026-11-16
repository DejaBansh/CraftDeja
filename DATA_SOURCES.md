# Data provenance and limitations

## Newly authored implementation

Start.lua, Words.lua, Client.lua, Economy.lua, Screen.lua and Run.lua were written
for this rebuild from functional requirements. The old ForeverProfessionCapper
implementation, its UI code, libraries and settings are not packaged. This is a
requirements-driven rewrite, not a claim that no developer has seen earlier code.
The supplied art was independently generated for this project; no original addon
art or Blizzard extracted texture is packaged. WoW UI templates referenced by name
are supplied by the installed client.

## Licensed reference dataset

- LibProfessionDB / ProfessionDB by **Pimptasty**, version **1.9.1**.
- Project: https://www.curseforge.com/wow/addons/libprofessiondb
- Version: https://www.curseforge.com/wow/addons/libprofessiondb/files/9095167
- Archive: https://edge.forgecdn.net/files/9095/167/ProfessionDB-ProfessionDB-v1.9.1.zip
- MIT notice: **Licenses/ProfessionDB-MIT.txt**, reproduced unchanged.
- Forever profile, data build **1.60.1.69977**. Snapshot obtained 2026-11-10.

Data/Catalog.lua and Data/Names_en.lua / Names_de.lua are transformed extracts of
its Forever profile, including its already flagged Vanilla-derived metadata.
We do not embed its runtime, LibStub, wrapper, Ace3 or VersionCheck. Its upstream
README credits wago.tools client data, community source databases and AllTheThings;
those game facts do not imply ownership of Blizzard content. NPC names are English
proper names. Missing source data stays unknown. A source example is not a complete
NPC list or a current availability/location guarantee.

The source snapshot contains 2,511 records across ten skill lines. We additionally
merge one enchanting fact absent from it, yielding 2,512 stored records; four
fishing records are not exposed as supported crafting routes. The nine crafting
routes expose **2,508** records. Many are reference-only, not currently obtainable.
Alchemy has 195 records; 104 had any source category in this snapshot, and 101 of
these were marked borrowed/unconfirmed. We do not fabricate the missing 91 sources.
Other professions have similar gaps. The 229 independently captured enchanting
facts provide source labels/ranges for most of that profession's catalogue.

### Skill threshold transformation

This version's raw difficulty arrays are inconsistent with independently checked
Enchanting ranges. To avoid silently using their first pair as orange/yellow,
the data builder preserves the raw yellow/green/grey triplet and normalises:

1. Where the raw first field is 1, the raw third field is treated as yellow,
   with green the midpoint of yellow and grey.
2. Where the raw third field is the midpoint of the raw first and fourth,
   the raw first is treated as yellow; the existing third remains green.
3. Otherwise the raw second/third/fourth fields are retained.

These are reference estimates, not verified Forever thresholds for every recipe.
229 enchanting records use separately cross-checked thresholds instead. At runtime,
live colour disagreement triggers a warning and prevents green continuation/bulk
forecasting. For non-verified references, an alternative raw triplet may be used
only when it agrees with the current live colour. A matching colour at one skill
is still not proof of every future boundary. Observed one-point colour transitions
are saved separately and labelled observed; they do not validate unrelated bounds.

## Independent factual cross-check

https://www.wowhead.com/forever/de/skill=333/verzauberkunst

A separate factual capture contains 229 spell IDs, German names, reagent IDs and
counts, skill boundaries and acquisition category. No article, guide prose, recipe
effect description, webpage layout or Wowhead code is included. That capture was
used for enchanting ranges/source labels, with the one missing record added.
Live client material quantities have priority over static snapshots.

## Confidence and runtime boundaries

- Live recipe identity, known state, current colour, mandatory material groups,
  skill rank and cooldowns take precedence when the client provides them.
- Merely being in the catalogue does not put a recipe into recommendations.
- Reference-hidden recipes are not offered as learning hints; a recipe actually
  learned in Forever is still allowed, even if the older reference hid it.
- Metadata borrowed from Vanilla is explicitly unconfirmed for Forever.
- Missing reagent prices are excluded from ranking, never valued at zero.
- Unit vendor prices are actual observed purchase prices; sale values are unused.
- Relative skill-up probabilities remain an unconfirmed community model. They are
  not extracted game probabilities. Three-second updates refresh local caches.
- No crafting, shopping, chat messaging or game input is automated.
- Saved settings use a new namespace and do not alter prior addon settings.

## Artwork

Art/Workshop.tga is an uncompressed, power-of-two 512×512 conversion of the
independently generated dark violet enchanting-workbench artwork created for Tim
on 2026-11-10. It is included for use and redistribution with this addon without
additional attribution requirements. This statement does not grant Blizzard
trademark or game-content rights.

## Faction/source audit added in 3.0.1-beta.1

Data/FactionAccess.lua is a separate factual overlay covering every supported
catalogue record. It uses the nine Wowhead Forever skill/recipe-item listings,
related NPC/quest metadata, and supplementary facts from AllTheThings' generated
Forever (Camelot) database. See FACTION_AUDIT.md for counts and derivation.

AllTheThings: https://github.com/ATTWoWAddon/AllTheThings
MIT license notice: Licenses/AllTheThings-MIT.txt (preserved unchanged).
Supplementary source files are db/Camelot/Categories/{Zones,WorldDrops,Instances,
Character,Professions,...}. The source metadata is transformed into our own
small data format. No ATT runtime, parser, prose descriptions, artwork or UI is
packaged. Coordinates remain reference observations; they can change.

World of Warcraft item-list `side` labels can describe acquisition faction and
are not treated as proof of a hard item-use restriction. In particular a learned
tradeable recipe is not disabled just because its direct source is the other
faction. Complementary source references remain explicitly marked unconfirmed.


## AH integration — 3.1.0-beta.1

Shopping.lua is newly authored MIT application code. Auctionator is not bundled.
The Auctionator 345 distribution (Interface 16001 listed) was inspected locally
on 2026-11-11 to verify public API `API.v1.MultiSearchAdvanced` fields
`searchString`, `isExact`, `quantity`, `categoryKey`, `maxPrice` (copper), and
advanced-term serialization. Exact full-scan events are obtained dynamically
from `Auctionator.FullScan.Events`; their event-bus/payload interfaces are
internal, version-sensitive contracts. ModernAH `replicateInfo` and LegacyAH
`auctionInfo` tuples use count index 3 and buyout index 10, with the item ID
parsed from the accompanying itemLink. Unrecognised payloads stay locked.
Only numeric snapshot price facts are held transiently; scan records are not
saved. Public source/distribution: https://www.curseforge.com/wow/addons/auctionator
Local inspection source: https://github.com/curseforge-mirror/auctionator/releases/tag/v2026.11.11.13.31
No third-party runtime source was copied into CraftDeja for this integration.


Auctionator 344 compatibility correction (2026-11-11): inspected and locally
executed its Source_ModernAH/Tabs/Auctionator/Mixins/ScanButton.lua,
IncrementalScan/Events.lua and IncrementalScan/Mixins/Frame.lua. The normal Scan
button can choose a full summary/browse scan; it is not always a replicate scan.
Only the matched summary ScanStart -> ScanComplete sequence is accepted, after
DB processing. Result itemKey.itemID, totalQuantity and minPrice supply current
per-unit snapshot facts. Generic IncrementalScan.PricesProcessed never unlocks
shopping. The application additionally supports the replicate/get-all path.
Reference distribution: https://github.com/curseforge-mirror/auctionator/releases/tag/v2026.11.10.14.18
No Auctionator implementation source is included in the addon archive.


## Storage and merchant locations — 3.2.0-beta.1

Inventory.lua and Merchants.lua are newly authored MIT implementation modules.
Data/VendorLocations.lua contains transformed location facts for 164 matching
merchant NPCs (1,658 item-location rows), derived from the existing AllTheThings
Camelot capture joined to the 36-reagent ordinary Forever sold-by lists. The ATT
MIT attribution is retained in Licenses/AllTheThings-MIT.txt. No ATT runtime is
loaded. References are not a promise that NPCs are currently in those positions.
In-game observations store the player position at an actual vendor interaction.

Primary client API documentation inspected 2026-11-11:
- https://github.com/Gethe/wow-ui-source/blob/forever/Interface/AddOns/Blizzard_APIDocumentationGenerated/ItemDocumentation.lua
- https://github.com/Gethe/wow-ui-source/blob/forever/Interface/AddOns/Blizzard_APIDocumentationGenerated/BankDocumentation.lua
- https://github.com/Gethe/wow-ui-source/blob/forever/Interface/AddOns/Blizzard_UIPanels_Game/Camelot/BankFrame.lua

GetItemCount calls explicitly distinguish bags, personal/reagent bank and account
bank. No addon code or guide text was copied from these documentation sources.
Native bank/waypoint API calls are feature-detected; offline characters cannot be
queried. Character inventory is local SavedVariables data, not sent to a service.

## 3.3 UI and merchant API

Skin.lua, VendorBuy.lua and MapPins.lua are newly authored. Rounded window/button
and action-icon textures were drawn programmatically for this project; logo
textures use the project's Goblin duo logo. No extracted game textures are included.
Client item icons are referenced by texture ID at runtime.
Merchant pack/unit semantics were inspected on 2026-11-11 against:
https://github.com/Gethe/wow-ui-source/blob/forever/Interface/AddOns/Blizzard_UIPanels_Game/Mainline/MerchantFrame.lua
The reference source is not bundled. Runtime API feature checks remain necessary.

Beta 3 slider and resize-grip textures were drawn programmatically for CraftDeja.

## 3.4 Auctionator bridge

AuctionBridge.lua is newly authored integration code. Method contracts were
inspected from Auctionator 344 and 345 (existing local upstream references):
State.FullScanFrameRef / IncrementalScanFrameRef InitiateScan; commodity
ReceiveEvent, QuantityCheckConfirmationDialog and FinalConfirmationDialog.
The shipped addon does not include upstream implementation files. Integration
uses feature detection and secure post-hooks; unsupported variants keep their
ordinary manual workflow. No global Auctionator option is changed.

## 3.4 Beta 2 native action contracts

CraftActions.lua is newly authored. API contracts were inspected from the Forever
branch on 2026-11-11; reference files are not packaged:
- https://github.com/Gethe/wow-ui-source/blob/forever/Interface/AddOns/Blizzard_APIDocumentationGenerated/TradeSkillUIDocumentation.lua
- https://github.com/Gethe/wow-ui-source/blob/forever/Interface/AddOns/Blizzard_APIDocumentationGenerated/AuctionHouseDocumentation.lua
- https://github.com/Gethe/wow-ui-source/blob/forever/Interface/AddOns/Blizzard_Professions/Blizzard_ProfessionsCrafting.lua

Auctionator's ShowCommodityBuy event is used like its native shopping result-row
click. Purchase finalization remains a deliberate click, with the item-specific
server purchase event used for bookkeeping. No reference implementation is copied.

## 3.4 Beta 4 purchase state

PurchaseState.lua is newly authored. It correlates the two commodity success event
forms from the previously inspected Forever API docs with explicit confirmation
intent. Native Auctionator dialogs are post-hooked; no third-party function body
is replaced or bundled. Live price sources are identified separately from the
full-scan snapshot. The diagnostic ring contains at most 40 purchase events.

## 3.5 flow logging and native batches

FlowLog.lua and the batch controller are newly authored. The previously inspected
Forever TradeSkillUIDocumentation CraftRecipe numCasts and native crafting page's
CreateAll/CreateInternal establish native batch semantics; no implementation is
copied. Optional StopRecipeRepeat/legacy cancellation is feature-detected; native
manual cancellation remains the fallback. Auctionator 344 API/v1/MultiSearch.lua
uses AuctionatorTabs_Shopping:Click before searching; the direct-load bridge now
performs the same navigation before presenting commodity offers.

### 3.5 beta 2 native craft and EditBox checks

- https://github.com/Gethe/wow-ui-source/blob/forever/Interface/AddOns/Blizzard_APIDocumentationGenerated/SimpleEditBoxAPIDocumentation.lua
- https://github.com/Gethe/wow-ui-source/blob/forever/Interface/AddOns/Blizzard_ProfessionsTemplates/Blizzard_ProfessionsTransaction.lua

The native profession Create/CreateInternal and transaction methods were executed
in a local optional contract probe against their unchanged source. They are not
bundled; application code calls the client's own methods. EditBox GetNumLines is
supported; FontString GetStringHeight is not an EditBox method. Live client
behavior still needs verification with the new diagnostics.

### 3.5 beta 4 dispatch and observed runtime trace

The user-provided 1.60.1 / 70888 runtime trace was used to reproduce a quantity
accepted by the UI with no observed cast, and repeated queue-plan reconstruction.
Only the behavioral scenario is retained in tests, not the user's complete log.
The direct dispatch argument contract is compared with the original Forever
Blizzard_ProfessionsTransaction.lua CraftRecipe method (primary link above).
Camelot/Blizzard_ProfessionsCrafting.lua and schematic layout overrides were
also inspected; their presence alone does not prove a callback or addon conflict.
Client action-block events are recorded without bypassing restrictions.

### 3.5 beta 5 confirmed client action block

A later runtime trace confirms ADDON_ACTION_BLOCKED for CraftDeja at direct
CraftRecipe dispatch. Production now only selects the recipe and sets its native
quantity input, requiring a real player click on the original Create button.
No protected craft/stop API, native script handler, or native Click is invoked.
The client's SecureTemplates action paths were inspected, including their native
access/ScriptedInput constraints; no proxy or restriction bypass is implemented.
The user's full diagnostic trace is not bundled in the release.

### 3.6 UI guidance and action-boundary planning

Next-action targets reuse the addon's existing priced decision stop, current rank
cap, faction-filtered follow-up recipe and conservative material/chance rules.
No new recipe data source is introduced. The native GetCraftableCount, CreateButton
and CreateAllButton are read only to position a visual cue; none is clicked by code.
Art/ArrowDown.tga is a new code-drawn directional UI asset matching the existing
palette. Complete user logs and account-specific inventory are not distributed.

### 3.6 beta 2 scan and live-price boundary

Auctionator 344 FullScan/Mixins/Frame.lua and IncrementalScan/Mixins/Frame.lua were
inspected for ScanStart/ScanComplete ordering and native busy flags; completion is
emitted after ProcessScan's callback. Native flags are also checked before enabling
shopping. The user's later trace was used to isolate a full-target/manual-target
mismatch separately from the suspected early scan click. COMMODITY_SEARCH_RESULTS_UPDATED
uses the live C_AuctionHouse commodity result APIs; cached DB notifications never
qualify a full scan. User diagnostic files are not bundled.

Beta 3 quantity synchronization was checked against original Auctionator 344
Commodity Main.lua OnLoad/UpdateView/GetPrices in a local contract probe;
CraftDeja's guard is independently authored and no Auctionator source is bundled.

## Beta 5 rank trainer references

Data/TrainerLocations.lua contains 49 rank/location records for 44 NPCs across
nine professions, derived from the existing MIT-licensed AllTheThings Camelot
snapshot (Licenses/AllTheThings-MIT.txt retained). NPC names were resolved against
Wowhead Forever NPC pages. Book acquisition entries remain identified by item ID.
Doctor Marsh (4609), Alchemy 75–150, was supplemented using
https://www.wowhead.com/forever/npc=4609/doctor-marsh
whose g_mapperData records uiMapId 1458 and observations around 51.6,74.6.
The Journeyman role is corroborated by its Forever page's 75-skill comment and
Classic rank spell 3101. All entries remain reference facts, not live confirmations
of every current Forever rank offering; unknown ranks never receive guessed pins.
No third-party runtime code or map artwork is bundled for this addition.

## Recipe observation feature (3.7 beta)

RecipeAudit.lua is newly authored. It records only observations exposed by the
client profession APIs, separated from the licensed shared reference catalogue.
The reference package identifier 2026.11.12.1 and package date 2026-11-12 identify
this assembled snapshot, not a complete independent verification on that date.
An external weekly review is a maintenance recommendation and not an internet
updater inside the addon. No new external recipe facts were added for this feature.

## 3.8 poison planner and approved Design A artwork

Poisons (profession ID 40) are identified by the client;
https://www.wowhead.com/forever/skill=40/poisons corroborates the ID. Learned
recipes, ingredient quantities and fixed output counts come only from current
client schematics. No external poison recipe catalogue is bundled. Five vendor
price references and faction-filtered locations are documented in VENDOR_REFERENCE.md.
The existing AllTheThings MIT license remains in Licenses/AllTheThings-MIT.txt.

Ten user-approved generated Design A backgrounds were exported from their original
PNG files to power-of-two 1024x1024 RGB TGA assets, Art/Profession_<id>.tga.
Mappings: 40 poisons, 171 alchemy, 333 enchanting, 164 blacksmithing, 165
leatherworking, 197 tailoring, 202 engineering, 185 cooking, 129 first aid and
186 mining/smelting. They are decorative generated artwork, not Blizzard assets
or copied in-game screenshots. Interactive controls are separately rendered.

## 3.9 unified interface

UnifiedUI.lua is newly authored for this project. This update changes presentation and routing only; no new recipe dataset or artwork is introduced.


## Beta.11 recipe-specific trainer supplement

Data/RecipeSourceCorrections.lua supplements the sampled routes for spell 14807 with two trainer memberships checked against the Forever recipe table. Coordinates are labelled reference data; no other recipe membership is inferred from those trainers. Sources, exact coordinates and limitations: [trainer routing notes](docs/TRAINER_ROUTING.md). No web market prices were imported.

## Beta.22 trainer membership references

435 explicit recipe-to-NPC membership lists from the existing MIT ProfessionDB 1.9.1 Forever Sources.lua are now merged with independently recorded NPC positions. Lists are capped upstream at twelve NPCs and include borrowed Classic metadata; this is not complete or live-verified Forever coverage. No profession/rank-based guess creates a recipe teacher. Franklin Lloyd's Copper Tube membership is corroborated by the Forever spell page; the additional Undercity position remains a reference. Actual trainer visits save character-local identified offer snapshots at the player's conversation position. Provenance, archive SHA256, generator, technical sources, limits and live checks: docs/TRAINER_NAVIGATION_BETA22.md. No private diagnostic log is packaged.

## Beta.23 original workshop artwork

Four separate project graphics were generated with Imagegen from the user's workshop design direction: WorkshopCard, WorkshopLogoFrame, WorkshopGoblin and WorkshopAction. The existing project-owned CraftDeja Logo was used only as the goblin identity reference and remains unchanged. High-resolution transparent PNG sources are in docs/assets/workshop; reproducible format/size conversion to RGBA32 TGA is implemented by tools/Export-WorkshopTextures.ps1. No screenshot/dashboard artwork from another product was copied. Text, numbers, status and prices are native UI elements. Artwork use and dimensions: docs/WORKSHOP_BETA23.md. UI evidence uses the local official Blizzard UI in wowlua, clearly distinguished from live-client screenshots.
