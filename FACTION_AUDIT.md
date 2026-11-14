# Faction and source audit — 3.0.1-beta.1

Snapshot: 2026-11-10. All 2,508 supported catalogue records were evaluated.
This audit classifies known acquisition routes, not ownership of the recipe
item, and does not claim every current server source was verified in-game.

| Profession | Records | Both factions | Alliance route | Horde route | Unknown |
| --- | ---: | ---: | ---: | ---: | ---: |
| Verzauberkunst | 262 | 180 | 0 | 0 | 82 |
| Alchemie | 195 | 146 | 0 | 0 | 49 |
| Schmiedekunst | 512 | 347 | 2 | 6 | 157 |
| Lederverarbeitung | 603 | 376 | 7 | 1 | 219 |
| Schneiderei | 477 | 345 | 1 | 0 | 131 |
| Ingenieurskunst | 275 | 186 | 1 | 1 | 87 |
| Kochkunst | 133 | 72 | 23 | 7 | 31 |
| Erste Hilfe | 33 | 28 | 0 | 0 | 5 |
| Verhüttung | 18 | 14 | 0 | 0 | 4 |

Total: **1,743 classified, 765 unknown**. The accompanying FACTION_AUDIT.json
contains every profession/spell ID, classification, route count and reference status.

## Evidence and derivation

- Primary facts: nine Wowhead Forever profession/recipe-item listings and
  available related NPC/quest tables, captured separately from the implementation.
  Example: https://www.wowhead.com/forever/skill=185/cooking
- Supplementary faction inheritance and coordinates: AllTheThings generated
  Forever/Camelot database, licensed MIT; 3,544 recipe-source records evaluated.
  https://github.com/ATTWoWAddon/AllTheThings/tree/master/db/Camelot
- Existing ProfessionDB MIT source-name dictionary supplies NPC proper names.
- AllTheThings license: Licenses/AllTheThings-MIT.txt, unchanged. No ATT runtime
  code, prose, UI or graphics is shipped.
- Faction inheritance in that reference: r=1 Horde, r=2 Alliance; applicable
  classic race lists are also considered. NPC/quest/object context is preserved.
  Sources marked unavailable in that reference are excluded.
- Explicit live-listed source categories supersede stale borrowed categories;
  for example, Kaldorei Spider Kabob no longer includes an invented trainer route.
- Sources with uncertain associations remain marked as reference/unconfirmed.
- Only factual IDs, names, routes, faction labels and coordinates are packaged.

## Policy

The current character faction is read from UnitFactionGroup. Learning hints
require an own-faction or shared source. Known opposite-faction acquisition routes
are excluded even when the option for unknown sources is enabled. Unknown sources
default to excluded from learning hints and remain visible as unchecked catalogue
entries. The optional setting is an explicit opt-in for unknown data, not an
override for known opposing sources.

A recipe already learned and usable in the client is not rejected merely because
its direct source is the other faction. World of Warcraft list-view side labels
can reflect acquisition rather than a hard use restriction; they are not turned
into blanket item-use bans. Cross-faction player trading/AH is not assumed for
learning hints. Other quest, reputation, level, class or specialization conditions
can still apply; this feature only evaluates faction availability.

## Reported regression

Kaldorei Spider Kabob: spell 6412, recipe item 5482, Alliance quest 4161,
quest giver Zarrin (NPC 6286), map 1438 at approximately 57.0, 61.2.
It is excluded as an unlearned Horde suggestion, retained for Alliance, and
allowed when already learned. The quest and NPC have separate source links.
https://www.wowhead.com/forever/quest=4161/recipe-of-the-kaldorei

## Limitations

Coverage is finite. Unknown entries are not silently treated as shared. Multiple
routes may have been sampled rather than exhaustively listed; a classified route
does not certify absence of every other possible route. Server changes can make
reference data stale. Map names use the client API when available; NPC names
and uncached quest names may follow the English reference. Craft probabilities
and materials forecasts retain the existing explicitly approximate model.
