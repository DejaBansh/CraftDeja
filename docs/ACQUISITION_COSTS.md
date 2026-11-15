# One-time recipe costs / Einmalige Rezeptkosten — beta.14

## Implemented / Implementiert

- A learned recipe has no NEW learning payment. A recipe item already owned
  likewise needs no additional purchase (collection/travel are separate).
- Exact `spell:` / `enchant:` links retain priority. Beta.14 additionally supports
  the narrowly verified nil-link Mot offer described below. All other nil-link
  services remain unknown; no fuzzy, output-item or row-index matching.
- Fees are character-local observations, expire after seven days, and are
  refreshed by trainer events. No trainer enumeration during native crafting.
- For an identified recipe item, use the cheaper of its current available unit
  quote and the observed trainer fee. Existing price-provider limitations apply;
  an AH quote is an estimate, not a guaranteed obtainable listing.
- Unknown acquisition cost is NOT stored as zero. An otherwise promising
  unknown recipe remains a provisional source-check suggestion; the CTA says
  `Check learning cost` / `Lernkosten prüfen`. It is not a verified cheaper route.

## Beta.14 nil-link trainer identity / Trainerzuordnung ohne Link

The reported case is Mot Dawnstrider (NPC 11071), recipe spell 7771,
recipe item 6345, nil service link and 200 copper. Beta.13 read the fee but
discarded it because it derived identity exclusively from the service link.

Beta.14 keeps an explicit, deliberately narrow observed relationship for this
NPC/spell/item triple. It additionally requires a Creature GUID for that NPC,
the unchanged catalog spell-to-recipe-item relationship, an available or
unavailable service, and an exact name AND rank match against client GetSpellInfo.
The addon UI language and an open profession are not identity evidence.

Duplicate service rows are rejected, even with equal prices. A second catalog
spell with the same client name and rank is rejected across all professions.
An unresolved catalog spell with the same localized reference name also blocks
assignment. Missing client spell data cannot be replaced by a dictionary guess.
An existing non-spell link never activates the nil-link fallback. Exact links
retain their existing precedence. No substring, case folding, row-index matching,
output-item inference or hardcoded fee is used; 180c/0c would be observed as such.

Other nil-link trainer offerings remain unknown until supported by their own
concrete relationship evidence. This is not a generic name resolver or a claim
of complete trainer coverage. Repeated trainer events reread current offers;
no timer or polling was added. Catalog identity checks run only for a matching
verified nil-link offer, outside native crafting (the existing busy guard remains).
No trainer filters are changed, no spell is learned and nothing is purchased.

The 24 new regression scenarios simulate the reported API contract and its
ambiguity/failure paths with the real catalog relationship. Successful capture
in Mot's real client window still requires a separate in-game retest.

## Economic comparison / Wirtschaftlicher Vergleich

For a candidate with known acquisition cost, compare already-known recipes with
those same recipes plus this ONE candidate. The horizon is the candidate's grey
boundary or the current profession cap, whichever comes first; with green
recipes disabled, stop at the candidate's green boundary.

At skill `s`, expected cost of using a recipe is:

```
(material cost - confirmed minimum vendor credit) / p(s)
+ remaining cost at min(target, s + skill points awarded)
```

Dynamic programming computes both routes backwards. Add the learning/recipe
fee ONCE to the route with the candidate. Request learning now only if that
route is strictly cheaper AND its first craft uses the candidate. Otherwise
keep the existing recipe. The calculation is cached within the economic
snapshot; new skill/price/fee snapshots recompute it.

Example with ten guaranteed points: known recipe 100c per craft, new recipe
80c plus 100c learning. Known route 1000c; new route 900c. At a fee of 201c,
new route 1001c: do not request learning merely because 80c is less than 100c.

This filters recommendations using one-candidate route comparisons. The final
candidate selection retains the existing per-point ordering among eligible
candidates. It does NOT claim joint/global optimization of several unknown
recipes, full 1–300 paths, travel, tools, rank fees, or intermediate products.
Limited-charge/cooldown and conflicting-range candidates are explicitly left
unassessed rather than given a false precise repayment calculation. Known
limited-charge recipes are excluded from the reusable-route baseline. Model
skill chances remain estimates; these exclusions can change the real optimum.

## UI and purchasing / Anzeige und Einkauf

Recipe details show known one-time payment, unknown status, and the bounded
route comparison where finite. The main guide keeps a short CTA. Material
shopping remains gross; it is not reduced by future vendor proceeds, and the
fee is not quietly converted into a material row. Learning/buying/using a recipe
still requires user action. No automatic trainer purchase or tool purchase.

## Evidence / Nachweise

34 new AcquisitionSuite cases cover one-time payments, expensive unlearned
recipes, probabilities, multiple awarded points/cap clipping, vendor credit,
owned/quoted recipe items, invalid/expired fees, exact-link observation,
unknown-status handling, caching, green settings and craft-busy guards.
All trainer services/prices in these cases are explicit fixtures; this is NOT
proof that every Forever trainer exposes the required links. A short real
trainer check remains necessary after the complete Windows regression passes.

Primary API reference inspected during development:
https://github.com/Gethe/wow-ui-source/blob/classic_era/Interface/AddOns/Blizzard_TrainerUI/Blizzard_TrainerUI.lua
The trainer UI uses GetTrainerServiceCost. Exact service links are consumed only
if the client provides them; missing links are never inferred from this reference.

Every run uses tools/Test-CraftDeja.ps1 and generates a ZIP report. See
TEST_RESULTS.md for versions, actual totals and validation limits.


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
