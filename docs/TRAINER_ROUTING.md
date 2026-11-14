# Recipe trainer routing / Rezeptlehrer-Routing — beta.11

## Reported case

The user was in Thunder Bluff and CraftDeja suggested learning Greater Magic Wand (14807) at Jhag in Orgrimmar. The stored sampled recipe source list contained six entries: Jhag plus five Alliance examples. Neither Thunder Bluff trainer was included. Same-map distance selection already existed, but could not select absent sources.

## Correction

- `Data/RecipeSourceCorrections.lua` adds **Teg Dawnstrider (3011)** and **Mot Dawnstrider (11071)** specifically for Greater Magic Wand 14807.
- Membership is checked against the Forever recipe trainer table; the map positions remain explicitly marked as **reference** coordinates. This is not a claim of observed live coordinates.
- `sourceList` merges exact duplicates and orders compatible-faction entries on the current map first, then comparable local distance. The recipe detail list therefore agrees with the destination selection.
- Existing reference tables are not mutated. Multiple legitimate spawn locations remain distinct. Faction checks and the exclusion of drop-only sources remain in place.
- A generic profession/rank trainer is **not** assumed to teach every recipe. No source is inferred merely from profession, NPC proximity or trainer rank.
- The ordering algorithm applies to all professions; the new data correction is deliberately recipe-specific. The underlying source snapshot remains incomplete.
- No global travel-path optimization or comparison of distances across different maps is claimed. Learning fees remain outside the economic score.

## Source facts

- Forever recipe 14807 trainer membership: https://www.wowhead.com/forever/spell=14807/greater-magic-wand
- Mot NPC record: https://www.wowhead.com/forever/npc=11071/mot-dawnstrider
- Mot reference position (Thunder Bluff 44.3, 38.9): https://www.foreverdb.app/en/forever/items/11288/greater-magic-wand
- Teg reference position (Thunder Bluff 44.9, 37.5): https://www.wow-professions.com/forever/enchanting-trainers

Checked 2026-11-14. Web price estimates are not imported into the addon. In-game item values and the configured price providers still determine cost.

## Validation

**42 passed, 0 failed, 0 skipped**: 30 new TrainerRoutingSuite cases plus 12 non-UI MapSuite regressions, in a minimal wowlua 0.13.12 project without Blizzard UI. The standard PowerShell reporter generated a ZIP including scope and source hashes.

[Recorded focused output](evidence/trainer-routing-focused-2026-11-14.txt) · [Three detected faulty variants](evidence/trainer-routing-mutations-2026-11-14.txt).

Reproduce: `python tools/verify_trainer_routing.py --powershell pwsh`. On Windows use `--powershell powershell.exe` if needed. The full addon's 402 tests subsequently passed on the Gaming PC; see the verified follow-up below.

## Deutsch

Die Ursache war eine unvollständige Rezeptquellenliste, nicht das Fehlen einer Entfernungsberechnung. Für den Großen Magiezauberstab fehlten die beiden Donnerfels-Trainer. Diese konkret belegten Quellen werden ergänzt. Bei der Anzeige stehen passende Quellen auf der aktuellen Karte zuerst; innerhalb derselben Karte entscheidet die Entfernung, soweit Koordinaten vorhanden sind.

Die Auswahl bleibt rezeptbezogen: Ein beliebiger Berufs- oder Rang-Lehrer wird nicht pauschal als Rezeptlehrer eingetragen. Die Standorte sind weiterhin Referenzdaten, und die Gesamtdatenbank ist damit noch nicht vollständig.

42 gezielte Fälle bestanden; drei absichtlich fehlerhafte Varianten wurden erkannt. Der vollständige Windows-/Blizzard-UI-Lauf mit 402 Tests und die lokale Lehrer-/Rezeptkontrolle wurden anschließend bestätigt (siehe Nachtrag). Alle Windows-Läufe erstellen automatisch einen Bericht.


Validated follow-up: user Windows report CraftDeja-beta11-20261114-234149.zip
contains 402/402 passing tests (305 files, 188.39s), successful build and installation
with backup. Live screenshots show Mot's local map point, Greater Magic Wand
actually offered for 2s, and the learned recipe crafted to skill 117. User reports
that this craft was smooth. Subsequent AH lag is tracked separately in
[AH_PERFORMANCE.md](AH_PERFORMANCE.md).
