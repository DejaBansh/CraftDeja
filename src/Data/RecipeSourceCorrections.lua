-- SPDX-License-Identifier: MIT
local _,app=...
-- Recipe-specific supplementation of the sampled source snapshot.
-- These are reference coordinates, not an observation from the user's client.
-- Membership checked against WoW Forever spell 14807 trainer data (2026-11-14).
app.recipeSourceCorrections={
    [14807]={
        {kind='trainer',id=3011,name='Teg Dawnstrider',side='Horde',map=1456,x=44.9,y=37.5,reference=true},
        {kind='trainer',id=11071,name='Mot Dawnstrider',side='Horde',map=1456,x=44.3,y=38.9,reference=true}
    }
}
