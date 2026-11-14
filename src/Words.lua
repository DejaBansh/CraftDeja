-- SPDX-License-Identifier: MIT
local _,app=...
local shoppingWords={en={
 shop_button='AH shopping',shop_title='Shopping',
 shop_open_ah='Open the auction house, then complete an Auctionator full scan.',
 shop_wait_scan='Waiting for a successful Auctionator full scan in this AH visit. Start Full Scan in Auctionator.',
 shop_scanning='Full scan running. Shopping opens after successful processing.',
 shop_scan_failed='Full scan failed. Complete a new scan before shopping.',
 shop_incompatible='This Auctionator version does not expose a supported full-scan result. Shopping stays locked.',
 shop_stale='Scan is over 30 minutes old. Complete a new full scan before shopping.',
 shop_needs_auctionator='Shopping requires Auctionator with MultiSearchAdvanced. TSM remains a price source for the adviser.',
 shop_scan_age='Successful full scan · %dm %02ds ago · Auctionator scan prices',
 shop_goal='Plan materials for +%d skill points',
 shop_bounds='Stops at recipe changes, green threshold or the allowed green exception.',
 shop_capped='Plan limited to +%d skill points: next decision / profession rank / green limit.',
 shop_limit='Unit price ceiling: scan +%d%%  ›',
 shop_unlock='Allow another search',
 shop_sent='Shopping list sent to Auctionator',
 shop_search='Find & buy materials in Auctionator',
 shop_buy_hint='Live offers and purchases are checked/confirmed in Auctionator. Yellow/green quantities are estimates.',
 shop_in_mail='Already sent: purchases may still be in your mailbox. Collect mail before another search.',
 shop_unknown_stock='Inventory cannot be read reliably. Shopping is blocked; reopen the profession and try again.',
 shop_item_loading='Item names are still loading. Try again shortly.',
 shop_nothing='No AH materials missing. Vendor materials are listed separately.',
 shop_search_failed='Auctionator could not start this search. Check the AH and addon versions.',
 shop_row='%s · buy %d · owned %s / need %d',
 shop_vendor='Vendor recommended · %s each · excluded from AH search',
 shop_unit_limit='Scan %s each · search ceiling %s each',
 shop_owned='Already owned',
 shop_total='AH limit (planned quantity): %s · vendor estimate: %s',
},de={
 shop_button='AH-Einkauf',shop_title='Einkauf',
 shop_open_ah='Auktionshaus öffnen und einen Auctionator-Vollscan abschließen.',
 shop_wait_scan='Warte auf erfolgreichen Auctionator-Vollscan bei diesem AH-Besuch. In Auctionator Vollscan starten.',
 shop_scanning='Vollscan läuft. Einkauf öffnet nach erfolgreicher Verarbeitung.',
 shop_scan_failed='Vollscan fehlgeschlagen. Vor dem Einkauf erneut vollständig scannen.',
 shop_incompatible='Diese Auctionator-Version liefert kein unterstütztes Vollscan-Ergebnis. Einkauf bleibt gesperrt.',
 shop_stale='Scan ist über 30 Minuten alt. Vor dem Einkauf erneut vollständig scannen.',
 shop_needs_auctionator='Einkauf benötigt Auctionator mit MultiSearchAdvanced. TSM bleibt Preisquelle für den Berater.',
 shop_scan_age='Vollscan erfolgreich · vor %dm %02ds · Auctionator-Scanpreise',
 shop_goal='Materialien für +%d Skillpunkte planen',
 shop_bounds='Bis Rezeptwechsel, Grünbeginn oder erlaubter Grün-Ausnahme.',
 shop_capped='Auf +%d Skillpunkte begrenzt: nächster Wechsel / Berufsrang / Grün-Limit.',
 shop_limit='Stückpreisgrenze: Scan +%d%%  ›',
 shop_unlock='Weitere Suche erlauben',
 shop_sent='Einkaufsliste an Auctionator übergeben',
 shop_search='Material in Auctionator suchen & kaufen',
 shop_buy_hint='Aktuelle Angebote und Käufe in Auctionator prüfen/bestätigen. Gelb-/Grün-Mengen sind geschätzt.',
 shop_in_mail='Schon übergeben: Käufe können im Briefkasten liegen. Vor weiterer Suche Post abholen.',
 shop_unknown_stock='Bestand nicht zuverlässig lesbar. Einkauf gesperrt; Beruf erneut öffnen und wieder versuchen.',
 shop_item_loading='Itemnamen laden noch. Gleich erneut versuchen.',
 shop_nothing='Keine AH-Materialien fehlen. Händlermaterial steht separat in der Liste.',
 shop_search_failed='Auctionator konnte die Suche nicht starten. AH und Addon-Versionen prüfen.',
 shop_row='%s · kaufen %d · vorhanden %s / benötigt %d',
 shop_vendor='Händler empfohlen · je %s · nicht in AH-Suche',
 shop_unit_limit='Scan je %s · Suchgrenze je %s',
 shop_owned='Bereits vorhanden',
 shop_total='AH-Limit (Planmenge): %s · Händler geschätzt: %s',
}}
app.professionLabels={
 en={[333]="Enchanting",[171]="Alchemy",[164]="Blacksmithing",[165]="Leatherworking",[197]="Tailoring",[202]="Engineering",[185]="Cooking",[129]="First Aid",[186]="Mining / Smelting"},
 de={[333]="Verzauberkunst",[171]="Alchemie",[164]="Schmiedekunst",[165]="Lederverarbeitung",[197]="Schneiderei",[202]="Ingenieurskunst",[185]="Kochkunst",[129]="Erste Hilfe",[186]="Bergbau / Verhüttung"}}
app.words={en={
 origin_questgiver="Quest giver",origin_pvp="PvP",origin_discovery="Discovery",origin_redemption="Exchange",npc_number="NPC #%d",quest_number="Quest #%d",map_number="Map #%d",faction_Alliance="Alliance",faction_Horde="Horde",faction_Both="Both factions",faction_Unknown="Unverified",faction_access="Source: %s",faction_use="Usable by: %s",faction_blocked="This recipe is restricted to the other faction.",faction_source_blocked="The known direct sources belong to the other faction.",access_unknown="Source faction not verified; excluded from learning hints by default.",no_verified_source="No verified recipe source for your faction. Browse the catalogue for unchecked entries.",source_unverified_n="%d unlearned recipes excluded: source faction unverified.",own_faction="My faction",all_factions="All factions",unknown_toggle="Include recipes with unverified source factions",current_link="Details / link",next_link="Details / link",recipe_page="Recipe page",craft_page="Craft spell",source_page="Source %d/%d",source_none="No source link",source_links_hint="Source button cycles through NPC/quest links. Copy the URL above.",source_route="%s: %s (%s)",source_count="%d source examples recorded; not necessarily every vendor.",cross_faction_note="Tradeable recipes may also be purchased via other players/AH; not assumed in learning hints.",

 recipe_number="Recipe #%d",missing_price="No price",unknown="Unknown",unconfirmed_short="(unconfirmed)",
 hidden_reference="Unavailable in reference; unconfirmed for Forever",example_source="Reference NPC",origin_trainer="Trainer",origin_vendor="Vendor",origin_drop="Drop",origin_quest="Quest",origin_container="Container",origin_auto="Automatic",origin_fishing="Fishing",origin_pickpocket="Pickpocketing",
 orange="Orange",yellow="Yellow",green="Green",grey="Grey",now="CRAFT NOW",learn_first="LEARN FIRST",next="NEXT · PREVIEW",next_learn="NEXT · LEARN RECIPE",none="No priced skill-up recipe",open="Open a crafting profession",unsupported="This profession has no crafting recipes.",skill="Skill %d/%d",source_chance="%s · %s · %s%d%% skill-up",approx="~",per_point="%s / craft · %s%s / skill · %s",next_at="At skill %d · %s · %s%s / skill",next_now="Now · %s · %s%s / skill",next_missing="Next recipe not priced yet",next_check="Check recipes and prices at skill %d.",stage="Until skill %d: %s%d crafts",green_saving="Green exception active; fixed limit: skill %d.",refresh_note="Rechecked after crafts. Prices use your last AH scan.",chance_note="Yellow/green: unconfirmed community estimate.",conflict="Client colour differs: ranges need verification.",rank_full="Train the next profession rank first.",no_prices="Scan Auctionator or provide TSM prices.",recipes="Recipes",materials="Materials",settings="Settings",link="Link",close="Close",search="Search name, source or recipe ID",known="Known",learn="Not learned",unchecked="Not confirmed in client",source="Source",range="Skill ranges",cost="Materials / craft",count="%d–%d of %d",previous="Previous",forward="Next",only_useful="Useful at my skill",scroll_hint="Click a recipe for details and its material plan.",catalog_title="Recipe catalogue",detail="Recipe details",target="Target skill",calculate="Calculate",until_green="Until green",next_stop="Next stop",inventory="Inventory",total="Total",buy="Buy",plan_summary="Skill %d → %d · %s%d crafts",ingredient="%s: %d total · %s owned · %d buy",plan_note="Bags + bank when available. Purchase estimate: %s",model_note="Expected amounts, not guarantees. Recipe acquisition costs extra.",choose="Select a recipe first.",no_ranges="No reliable colour limits; plan one craft at a time.",no_progress="This recipe cannot give skill points here.",target_low="Target must be above current skill.",green_rejected="Green continuation needs a cheaper current comparison.",other_prof="Open this profession to calculate materials.",plan_capped="Target capped at the next decision point.",basis="Range data: %s",verified="cross-checked reference",reference="licensed reference snapshot",observed="observed in this client",options_title="Display and price options",language="Language",prices="Price provider",green_toggle="Allow up to five cheaper green skill points",enabled="On",disabled="Off",scale="Scale",auto="Automatic",language_auto="Game language",vendor_cached="Vendor (observed)",tsm_market="TSM market estimate",source_unknown="Unconfirmed source data",cooldown="On cooldown",reload="Rescan profession",source_note="Source information may be borrowed from Classic; unconfirmed entries are marked.",boot="CraftDeja %s · /cdj · /cdj scale 70",help="/cdj · /cdj recipes · /cdj materials · /cdj options · /cdj scale 70 · /cdj lang en|de|auto · /cdj source auto|auctionator|tsm",scan_pending="Recipe data is still loading.",reset_position="Centre window",range_line="Orange %s · Yellow %s · Green %s",grey_at="Grey at %d",ranges_unknown="Colour thresholds unavailable",stock_unknown="?",not_ready="Open a profession to read your current recipes.",price_missing_n="%d useful recipes have missing prices.",needs_tools="Tool or station requirements may still apply.",vendor_note="Vendor prices are remembered observations, not live stock guarantees."},
 de={
 origin_questgiver="Questgeber",origin_pvp="PvP",origin_discovery="Entdeckung",origin_redemption="Eintausch",npc_number="NPC Nr. %d",quest_number="Quest Nr. %d",map_number="Karte Nr. %d",faction_Alliance="Allianz",faction_Horde="Horde",faction_Both="Beide Fraktionen",faction_Unknown="Ungeprüft",faction_access="Quelle: %s",faction_use="Benutzbar: %s",faction_blocked="Dieses Rezept ist auf die andere Fraktion beschränkt.",faction_source_blocked="Die bekannten direkten Quellen gehören zur anderen Fraktion.",access_unknown="Quellfraktion ungeprüft: standardmäßig kein Lernvorschlag.",no_verified_source="Keine geprüfte Rezeptquelle für deine Fraktion. Ungeprüfte Einträge stehen im Katalog.",source_unverified_n="%d ungelernte Rezepte wegen ungeprüfter Quellfraktion ausgeschlossen.",own_faction="Meine Fraktion",all_factions="Alle Fraktionen",unknown_toggle="Rezepte mit ungeprüfter Quellfraktion einschließen",current_link="Details / Link",next_link="Details / Link",recipe_page="Rezeptseite",craft_page="Herstellung",source_page="Quelle %d/%d",source_none="Kein Quelllink",source_links_hint="Quellen-Button wechselt NPC-/Quest-Links. URL oben kopieren.",source_route="%s: %s (%s)",source_count="%d Quellbeispiele gespeichert; nicht zwingend alle Händler.",cross_faction_note="Handelbare Rezepte können auch über Spieler/AH erhältlich sein; für Lernvorschläge wird das nicht vorausgesetzt.",

 recipe_number="Rezept Nr. %d",missing_price="Preis fehlt",unknown="Unbekannt",unconfirmed_short="(unbestätigt)",
 hidden_reference="In Referenz nicht erhältlich; für Forever unbestätigt",example_source="Referenz-NPC",origin_trainer="Trainer",origin_vendor="Händler",origin_drop="Drop",origin_quest="Quest",origin_container="Behälter",origin_auto="Automatisch",origin_fishing="Angeln",origin_pickpocket="Taschendiebstahl",
 orange="Orange",yellow="Gelb",green="Grün",grey="Grau",now="JETZT HERSTELLEN",learn_first="ZUERST LERNEN",next="ALS NÄCHSTES · VORSCHAU",next_learn="ALS NÄCHSTES · REZEPT LERNEN",none="Kein bepreistes Skillrezept",open="Herstellungsberuf öffnen",unsupported="Dieser Beruf enthält keine Herstellungsrezepte.",skill="Skill %d/%d",source_chance="%s · %s · %s%d%% Skillchance",approx="ca. ",per_point="%s / Craft · %s%s / Skill · %s",next_at="Ab Skill %d · %s · %s%s / Skill",next_now="Jetzt · %s · %s%s / Skill",next_missing="Folgerezept noch nicht bepreist",next_check="Bei Skill %d neue Rezepte und Preise prüfen.",stage="Bis Skill %d: %s%d Herstellungen",green_saving="Grün-Ausnahme aktiv; feste Grenze: Skill %d.",refresh_note="Nach Crafts neu geprüft. Preise aus dem letzten AH-Scan.",chance_note="Gelb/Grün: unbestätigtes Community-Schätzmodell.",conflict="Spielfarbe weicht ab: Grenzen müssen geprüft werden.",rank_full="Zuerst den nächsten Berufsrang lernen.",no_prices="Auctionator scannen oder TSM-Preise bereitstellen.",recipes="Rezepte",materials="Material",settings="Optionen",link="Link",close="Schließen",search="Name, Herkunft oder Rezept-ID suchen",known="Erlernt",learn="Noch lernen",unchecked="Im Client ungeprüft",source="Herkunft",range="Skillbereiche",cost="Material / Craft",count="%d–%d von %d",previous="Zurück",forward="Weiter",only_useful="Passend zu meinem Skill",scroll_hint="Rezept anklicken: Details und Materialplanung.",catalog_title="Rezeptkatalog",detail="Rezeptdetails",target="Zielskill",calculate="Berechnen",until_green="Bis Grün",next_stop="Planende",inventory="Bestand",total="Gesamt",buy="Kaufen",plan_summary="Skill %d → %d · %s%d Herstellungen",ingredient="%s: %d gesamt · %s vorhanden · %d kaufen",plan_note="Taschen + Bank, soweit lesbar. Einkauf geschätzt: %s",model_note="Erwartete Mengen, keine Garantie. Rezeptbeschaffung kostet extra.",choose="Zuerst ein Rezept auswählen.",no_ranges="Keine verlässlichen Grenzen: nur einzelne Crafts planen.",no_progress="Dieses Rezept gibt hier keine Skillpunkte.",target_low="Das Ziel muss über dem aktuellen Skill liegen.",green_rejected="Grün nur nach einem günstigeren aktuellen Kostenvergleich.",other_prof="Diesen Beruf für die Materialplanung öffnen.",plan_capped="Ziel auf den nächsten Entscheidungspunkt begrenzt.",basis="Farbgrenzen: %s",verified="abgeglichene Referenz",reference="lizenzierter Datenstand",observed="im Client beobachtet",options_title="Anzeige und Preisquellen",language="Sprache",prices="Preisquelle",green_toggle="Bis zu fünf günstigere grüne Skillpunkte erlauben",enabled="An",disabled="Aus",scale="Skalierung",auto="Automatisch",language_auto="Spiel-Sprache",vendor_cached="Händler (beobachtet)",tsm_market="TSM-Markt-Schätzung",source_unknown="Unbestätigte Herkunftsdaten",cooldown="Abklingzeit aktiv",reload="Beruf neu einlesen",source_note="Herkunftsdaten können aus Classic stammen; unbestätigte Einträge sind markiert.",boot="CraftDeja %s · /cdj · /cdj scale 70",help="/cdj · /cdj recipes · /cdj materials · /cdj options · /cdj scale 70 · /cdj lang en|de|auto · /cdj source auto|auctionator|tsm",scan_pending="Rezeptdaten werden noch geladen.",reset_position="Fenster zentrieren",range_line="Orange %s · Gelb %s · Grün %s",grey_at="Grau ab %d",ranges_unknown="Farbgrenzen nicht verfügbar",stock_unknown="?",not_ready="Beruf öffnen, um aktuelle Rezepte einzulesen.",price_missing_n="Bei %d passenden Rezepten fehlen Preise.",needs_tools="Werkzeug- oder Arbeitsplatzanforderungen können zusätzlich gelten.",vendor_note="Händlerpreise sind gespeicherte Beobachtungen, keine Garantie für aktuelle Bestände."}}

for lang,words in pairs(shoppingWords)do for key,value in pairs(words)do app.words[lang][key]=value end end

local guideWords={en={
 guide_button='Guide',guide_back='Adviser',guide_intro='Welcome! Get started in five steps.',
 guide_requirements='Prices: Auctionator OR TSM with AH data.\nShopping specifically requires Auctionator.',
 guide_step1_title='Open your profession',
 guide_step1_body='Open the crafting profession you want to level. Use /cdj to show CraftDeja. Your skill and learned recipes are read from the profession.',
 guide_step2_title='Update auction prices',
 guide_step2_body='At the AH: Auctionator → Full Scan. Wait for it to finish. Only a successful full scan opens shopping; TSM alone provides price advice.',
 guide_step3_title='Check the craft and next recipe',
 guide_step3_body='Top: current craft by estimated cost per skill point. Middle: next step. Details / link shows recipe sources and copyable Wowhead links.',
 guide_step4_title='Choose skill points and materials',
 guide_step4_body='In AH shopping, choose skill points with the slider. Review the actual target, missing materials and price ceiling. Recipe/green limits apply.',
 guide_step5_title='Confirm purchases, then craft',
 guide_step5_body='Send the search to Auctionator and confirm purchases there. Collect your mail, then craft in your profession. Advice is rechecked after crafts.',
 guide_note='Yellow/green quantities are estimates. Reopen this guide anytime with Guide or /cdj help.',
 guide_start='Got it · Open adviser',
},de={
 guide_button='Leitfaden',guide_back='Berater',guide_intro='Willkommen! In fünf Schritten starten.',
 guide_requirements='Preise: Auctionator ODER TSM mit AH-Daten.\nFür den Einkauf wird ausdrücklich Auctionator benötigt.',
 guide_step1_title='Herstellungsberuf öffnen',
 guide_step1_body='Öffne den Beruf, den du skillen möchtest. /cdj zeigt CraftDeja. Skill und erlernte Rezepte werden aus dem Berufsfenster eingelesen.',
 guide_step2_title='Auktionspreise aktualisieren',
 guide_step2_body='Im AH: Auctionator → Vollscan. Abschluss abwarten! Nur ein erfolgreicher Vollscan öffnet den Einkauf. TSM allein liefert Preisempfehlungen.',
 guide_step3_title='Aktuelles und nächstes Rezept prüfen',
 guide_step3_body='Oben: aktueller Craft nach geschätzten Kosten je Skillpunkt. Mitte: nächster Schritt. Details / Link zeigt Herkunft und Wowhead-Links zum Kopieren.',
 guide_step4_title='Skillziel und Materialien wählen',
 guide_step4_body='Im AH-Einkauf Skillpunkte per Regler wählen. Tatsächliches Ziel, Fehlmengen und Preisgrenze prüfen. Rezeptwechsel und Grün-Limit begrenzen den Plan.',
 guide_step5_title='Käufe bestätigen und herstellen',
 guide_step5_body='Suche an Auctionator senden und dort Käufe bestätigen. Post abholen, dann im Berufsfenster craften. Nach Crafts wird die Empfehlung neu geprüft.',
 guide_note='Gelb-/Grün-Mengen sind geschätzt. Leitfaden jederzeit über Leitfaden oder /cdj help öffnen.',
 guide_start='Verstanden · Berater öffnen',
}}
for lang,words in pairs(guideWords)do for key,value in pairs(words)do app.words[lang][key]=value end end

app.words.en.session_cached='Saved profession'
app.words.de.session_cached='Beruf vorgemerkt'
app.words.en.session_stale='A craft finished after closing the profession. Close the AH and reopen the profession before shopping.'
app.words.de.session_stale='Nach Schließen des Berufs wurde noch gecraftet. AH schließen und Beruf vor dem Einkauf erneut öffnen.'
app.words.en.guide_step2_body='Close the crafting window; CraftDeja keeps your profession. Open AH → Auctionator → Full Scan. Wait until the shopping panel opens.'
app.words.de.guide_step2_body='Berufsfenster schließen; CraftDeja merkt sich den Beruf. AH öffnen → Auctionator → Vollscan. Warten, bis sich der Einkauf öffnet.'

app.words.en.shop_ready='AH scan complete. Open AH shopping to choose your skill target.'
app.words.de.shop_ready='AH-Scan abgeschlossen. Über AH-Einkauf jetzt das Skillziel wählen.'
app.words.en.shop_wait_scan='In Auctionator → Auctionator tab → Scan. Wait for the complete scan to finish; then shopping opens automatically.'
app.words.de.shop_wait_scan='In Auctionator → Reiter Auctionator → Scannen. Vollständigen Abschluss abwarten; dann öffnet sich der Einkauf automatisch.'

app.words.en.vendor_reference='Vendor (reference)'
app.words.de.vendor_reference='Händler (Referenz)'
app.words.en.shop_vendor_reference='Ordinary vendor · reference %s each · excluded from AH search'
app.words.de.shop_vendor_reference='Normaler Händler · Referenz je %s · nicht in AH-Suche'
app.words.en.shop_ah_below_vendor='AH search stays strictly below vendor: %s each'
app.words.de.shop_ah_below_vendor='AH-Suche bleibt strikt unter Händlerpreis: je %s'
app.words.en.shop_counts='Material types: %d AH · %d vendor · %d already covered by stock'
app.words.de.shop_counts='Materialarten: %d AH · %d Händler · %d durch Bestand gedeckt'
app.words.en.shop_sent_counts='Sent to Auctionator: %d material types. Vendor: %d. Already covered by stock: %d. Only missing quantities are searched.'
app.words.de.shop_sent_counts='An Auctionator: %d Materialarten. Händler: %d. Durch Bestand gedeckt: %d. Gesucht werden nur Fehlmengen.'
app.words.en.shop_vendor_only='Only vendor materials are missing; buy them from a merchant. Other ingredients are already owned. Reference prices can vary; visiting the vendor records your actual price.'
app.words.de.shop_vendor_only='Es fehlen nur Händlermaterialien: beim Händler kaufen. Andere Reagenzien sind vorhanden. Referenzpreise können abweichen; Händler öffnen erfasst deinen Preis.'

app.words.en.shop_ready='AH scan valid for 30 minutes from completion, including after reopening the AH. Use AH shopping to choose your skill target.'
app.words.de.shop_ready='AH-Scan ab Abschluss 30 Minuten gültig, auch nach erneutem Öffnen des AH. Über AH-Einkauf das Skillziel wählen.'
app.words.en.guide_step2_body='CraftDeja keeps your profession. At the AH: Auctionator → Scan. A successful scan stays valid for 30 minutes, including after reopening the AH.'
app.words.de.guide_step2_body='CraftDeja merkt sich den Beruf. Im AH: Auctionator → Scannen. Ein erfolgreicher Scan gilt 30 Minuten, auch nach erneutem Öffnen des AH.'

local stockWords={en={
 inventory_unknown='not recorded',inventory_you='You: bags %s · personal bank %s',
 inventory_bank_live='Bank open · checked %s',inventory_bank_saved='Personal bank, saved/API count · %s',
 inventory_visit_bank='Bank not recorded yet: open it once to refresh the location.',
 inventory_shared='Account bank: %d · saved %s',
 inventory_alt='%s: bags %d · personal bank %s',inventory_alt_date='Saved: bags %s · bank %s',
 inventory_alt_not_deducted='Display only: other faction or item binding not confirmed transferable.',
 inventory_alts_count='Alt stock: deduct',inventory_alts_show='Alt stock: display only',
 inventory_material='%s · need %d · still buy %d',inventory_take_bank='→ Collect %d from your personal bank.',
 inventory_transfer_alt='→ Alt stock counted: up to %d. Transfer it before crafting.',
 merchant_button='Nearby vendors / map',merchant_title='Vendors for missing supplies',merchant_pin='Map pin',
 merchant_place='%s · %.1f, %.1f',merchant_row='Vendor: %s · %s',merchant_reference='Reference location',merchant_observed='Recorded at vendor visit',
 merchant_unknown='No compatible vendor coordinates recorded. Visit a vendor to record them.',
 merchant_announce='Vendor nearby: %s · %s',merchant_marked='Map point set: %s · %s. Open your map to view it.',
 merchant_no_pin='This client cannot set that map point. Coordinates: %s',
 merchant_no_need='No missing vendor supplies in this plan.',
 merchant_note='Nearest recorded compatible vendor is preferred on your current map. Reference NPC positions may differ. Map pins do not guarantee a route or stock.',
},de={
 inventory_unknown='nicht erfasst',inventory_you='Du: Taschen %s · persönliche Bank %s',
 inventory_bank_live='Bank geöffnet · geprüft %s',inventory_bank_saved='Persönliche Bank, gespeicherter/API-Stand · %s',
 inventory_visit_bank='Bank noch nicht erfasst: einmal öffnen, um den Standort zu aktualisieren.',
 inventory_shared='Accountbank: %d · gespeichert %s',
 inventory_alt='%s: Taschen %d · persönliche Bank %s',inventory_alt_date='Gespeichert: Taschen %s · Bank %s',
 inventory_alt_not_deducted='Nur Anzeige: andere Fraktion oder Übertragbarkeit nicht bestätigt.',
 inventory_alts_count='Alt-Bestände: anrechnen',inventory_alts_show='Alt-Bestände: nur anzeigen',
 inventory_material='%s · benötigt %d · nachkaufen %d',inventory_take_bank='→ %d von deiner persönlichen Bank holen.',
 inventory_transfer_alt='→ Alt-Bestand angerechnet: bis zu %d. Vor dem Craften übertragen.',
 merchant_button='Händler in der Nähe / Karte',merchant_title='Händler für fehlende Materialien',merchant_pin='Kartenpunkt',
 merchant_place='%s · %.1f, %.1f',merchant_row='Händler: %s · %s',merchant_reference='Referenzposition',merchant_observed='Beim Händlerbesuch erfasst',
 merchant_unknown='Keine passenden Händlerkoordinaten gespeichert. Händlerbesuch erfasst den Standort.',
 merchant_announce='Händler in der Nähe: %s · %s',merchant_marked='Kartenpunkt gesetzt: %s · %s. Zum Anzeigen die Karte öffnen.',
 merchant_no_pin='Dieser Client kann den Kartenpunkt nicht setzen. Koordinaten: %s',
 merchant_no_need='Für diesen Plan fehlen keine Händlermaterialien.',
 merchant_note='Passende Händler im aktuellen Gebiet werden bevorzugt. Referenzpositionen können abweichen. Kartenpunkte garantieren weder Laufweg noch Bestand.',
}}
for lang,words in pairs(stockWords)do for key,value in pairs(words)do app.words[lang][key]=value end end
app.words.en.inventory_me='You'
app.words.de.inventory_me='Du'
app.words.en.inventory_owner='%s (you): bags %s · personal bank %s'
app.words.de.inventory_owner='%s (du): Taschen %s · persönliche Bank %s'
app.words.en.guide_step4_body='Check skill target and storage locations in Shopping. Log in alts and open their bank once. Nearby vendors / map shows supplier coordinates.'
app.words.de.guide_step4_body='Im Einkauf Skillziel und Lagerorte prüfen. Alts einmal einloggen und Bank öffnen. Händler / Karte zeigt passende Händler und Koordinaten.'
local newUI={en={
 compact_info='Shopping details',compact_hover='Hover an icon for details',compact_search='Search AH',compact_sent='Sent',
 hint_book='Recipe catalogue and recipe sources.',hint_bag='Material plan, inventory and missing quantities.',hint_gear='Language, prices and display settings.',
 hint_coin='Auction prices and shopping. Review quantities and ceilings before buying.',hint_help='Open the five-step in-game guide.',
 hint_hammer='Current crafting advice.',hint_link='Recipe and source links to copy.',hint_map='Set a map point for the selected supplier.',
 hint_alts='Switch between displaying and deducting compatible saved alt stock.',hint_merchant='Suppliers for missing materials, coordinates and map points.',
 hint_unlock='Allow another AH search after checking your mail and current inventory.',hint_refresh='Refresh the relevant data or review an unconfirmed vendor purchase.',
 hint_filter='Filter the displayed recipes.',hint_language='Switch the interface language.',hint_center='Return the window to the centre.',
 hint_green='Allow the bounded green skill-up exception.',hint_check='Apply this selection.',hint_info='Move the mouse over material icons for location and purchase details.',
 hint_close='Close this window.',hint_prev='Previous page.',hint_next='Next page.',hint_plus='Increase the value.',hint_minus='Decrease the value.',
 vendor_buy_title='Vendor purchase',vendor_buy_retry='Check stock / retry',vendor_buy_amount='missing %d · buy %d · pack %d',
 vendor_buy_cost='Total for this click: %s',vendor_buy_button='Buy %d items · %s',
 vendor_buy_one_stack='Click an item to select it. One click buys at most one stack, rounded to the vendor pack size. Confirmed bag stock unlocks the next purchase.',
 vendor_buy_changed='The plan changed. Review the new quantity and price before clicking again.',vendor_buy_gold='Not enough gold for this purchase.',
 vendor_buy_pending='Purchase requested; waiting for bag confirmation.',vendor_buy_wait='Purchase not confirmed. Check your bags, then use the refresh button to retry.',
 vendor_buy_done='Purchase confirmed in your bags.',vendor_buy_failed='The purchase could not be sent. Check the merchant and try again.',
 vendor_buy_unsupported='This client does not expose the supported merchant purchase function.',
 map_pin_hint='Large CraftDeja supplier marker. Ctrl-click removes this logo marker.',merchant_custom_pin='CraftDeja map marker ready. Coordinates: %s',
},de={
 compact_info='Einkaufsdetails',compact_hover='Maus über ein Symbol: Details',compact_search='AH durchsuchen',compact_sent='Übergeben',
 hint_book='Rezeptkatalog und Bezugsquellen öffnen.',hint_bag='Materialbedarf, Bestand und Fehlmengen anzeigen.',hint_gear='Sprache, Preise und Anzeige einstellen.',
 hint_coin='AH-Preise und Einkauf. Mengen und Preisgrenzen vor dem Kauf prüfen.',hint_help='Den Leitfaden in fünf Schritten öffnen.',
 hint_hammer='Aktuelle Herstellungsempfehlung.',hint_link='Rezept- und Quellenlinks zum Kopieren.',hint_map='Einen Kartenpunkt für den gewählten Händler setzen.',
 hint_alts='Gespeicherte passende Alt-Bestände nur anzeigen oder anrechnen.',hint_merchant='Händler für fehlende Materialien, Koordinaten und Kartenpunkte.',
 hint_unlock='Weitere AH-Suche erlauben, nachdem du Post und Bestand geprüft hast.',hint_refresh='Daten aktualisieren oder einen unbestätigten Händlerkauf prüfen.',
 hint_filter='Angezeigte Rezepte filtern.',hint_language='Sprache der Oberfläche wechseln.',hint_center='Das Fenster wieder zentrieren.',
 hint_green='Begrenzte günstigere grüne Skillpunkte zulassen.',hint_check='Diese Auswahl übernehmen.',hint_info='Materialsymbole mit der Maus berühren: Lagerorte und Kaufdetails.',
 hint_close='Dieses Fenster schließen.',hint_prev='Vorherige Seite.',hint_next='Nächste Seite.',hint_plus='Wert erhöhen.',hint_minus='Wert verringern.',
 vendor_buy_title='Händlerkauf',vendor_buy_retry='Bestand prüfen / erneut freigeben',vendor_buy_amount='fehlen %d · Kauf %d · Paket %d',
 vendor_buy_cost='Gesamtpreis für diesen Klick: %s',vendor_buy_button='%d Stück kaufen · %s',
 vendor_buy_one_stack='Material anklicken zum Auswählen. Pro Klick höchstens ein Stapel, auf Händlerpakete gerundet. Der nächste Kauf wird nach Bestätigung im Taschenbestand frei.',
 vendor_buy_changed='Der Plan hat sich geändert. Neue Menge und Preis vor dem nächsten Klick prüfen.',vendor_buy_gold='Für diesen Kauf reicht dein Gold nicht.',
 vendor_buy_pending='Kauf angefragt; warte auf Bestätigung im Taschenbestand.',vendor_buy_wait='Kauf nicht bestätigt. Taschen prüfen, dann über Aktualisieren erneut freigeben.',
 vendor_buy_done='Kauf im Taschenbestand bestätigt.',vendor_buy_failed='Kauf konnte nicht gesendet werden. Händler prüfen und erneut versuchen.',
 vendor_buy_unsupported='Dieser Client bietet die unterstützte Händler-Kauffunktion nicht an.',
 map_pin_hint='Großer CraftDeja-Händlermarker. Strg-Klick entfernt diesen Logo-Marker.',merchant_custom_pin='CraftDeja-Kartenmarker bereit. Koordinaten: %s',
}}
for lang,words in pairs(newUI)do for key,value in pairs(words)do app.words[lang][key]=value end end
app.words.en.vendor_buy_help=app.words.en.vendor_buy_one_stack
app.words.de.vendor_buy_help=app.words.de.vendor_buy_one_stack
app.words.en.vendor_buy_one_stack='One click buys at most one stack. Check the pack quantity and price.'
app.words.de.vendor_buy_one_stack='Pro Klick höchstens ein Stapel. Paketmenge und Preis vor dem Kauf prüfen.'
app.words.en.compact_hover='Hover: details'
app.words.de.compact_hover='Maus: Details'

app.words.en.resize_title='Resize window';app.words.en.resize_help='Drag the bottom-right corner. Each window remembers its own scale.'
app.words.de.resize_title='Fenster skalieren';app.words.de.resize_help='Unten rechts ziehen. Jedes Fenster merkt sich seine eigene Skalierung.'

app.words.en.guide_step2_title='Open the AH: prices refresh automatically'
app.words.en.guide_step2_body='Keep the AH open while Auctionator scans. CraftDeja starts a full scan when needed and refreshes after 30 minutes.'
app.words.de.guide_step2_title='AH öffnen: Preise automatisch aktualisieren'
app.words.de.guide_step2_body='Lass das AH während des Auctionator-Scans offen. CraftDeja startet den Vollscan bei Bedarf und nach 30 Minuten automatisch.'
app.words.en.shop_wait_scan='The automatic full scan starts shortly. Keep the AH open.'
app.words.de.shop_wait_scan='Der automatische Vollscan startet gleich. Lass das AH offen.'
app.words.en.shop_stale='Prices expired. CraftDeja will automatically start another full scan.'
app.words.de.shop_stale='Preise abgelaufen. CraftDeja startet automatisch einen neuen Vollscan.'
app.words.en.shop_scan_failed='Full scan failed. CraftDeja retries automatically while the AH is open.'
app.words.de.shop_scan_failed='Vollscan fehlgeschlagen. CraftDeja versucht es bei geöffnetem AH automatisch erneut.'

app.words.en.guide_step5_body='Send the search to Auctionator. CraftDeja fills the planned commodity quantity; check the price and confirm. Collect mail, then craft.'
app.words.de.guide_step5_body='Suche an Auctionator senden. CraftDeja füllt die geplante Reagenzienmenge aus; Preis prüfen und bestätigen. Post abholen, dann craften.'
local actionWords={en={
 step_planned_crafts='Planned: %d crafts',step_craft_count='Craft %s%d x %s. Materials are ready.',step_craft_help='The button starts one craft per click, then recalculates the recommendation.',step_mail_confirmed='Purchase confirmed: collect %d x %s from your mailbox.',
 action_craft_one='Prepare 1 craft',action_combat='Finish combat before opening or crafting.',action_choose_profession='Open the desired profession from your spellbook once.',action_open_unsupported='This client cannot open the profession through this button. Use your spellbook.',action_open_failed='The profession could not be opened. Check that you have learned it.',action_opening='Opening the native profession window. Click again there to craft.',action_busy='A craft is already in progress.',action_recipe_missing='Open your profession and learn the recommended recipe first.',action_changed='The plan or price changed. Check the updated button, then click again.',action_enchant_target='Enchanting needs a target item. Select the enchantment and target in the profession window.',action_materials='Collect the required materials into your bags first.',action_craft_unsupported='Crafting API unavailable. Use the native profession craft button.',action_craft_failed='Craft could not start. Check the native profession window and any error message.',action_craft_started='One craft requested. Waiting for the game to finish it.',
 ah_load_body='Prepare offers for %d x %s. Nothing has been bought yet.',ah_load_button='Load planned purchase',ah_confirm_body='Confirm %d x %s for %s. Nothing is recorded as purchased until the game confirms it.',ah_confirm_button='Confirm purchase: %s',ah_check_dialog='Check the Auctionator price warning or cancel its purchase dialog.',ah_check_dialog_button='Check purchase dialog',ah_wait_quote='Waiting for the current price quote from the AH.',ah_wait_button='Waiting for AH',ah_no_affordable='No offers within your price limit. Refresh offers or wait.',ah_ready_body='Buy %d x %s for %s. Click to request the final quote.',ah_buy_button='Buy %d: %s',ah_select_native='Select this material in Auctionator. This client does not expose the direct commodity panel.'},
 de={step_planned_crafts='Geplant: %d Herstellungen',step_craft_count='Stelle %s%d x %s her. Materialien sind bereit.',step_craft_help='Pro Klick wird ein Craft gestartet und danach die Empfehlung neu geprüft.',step_mail_confirmed='Kauf bestätigt: Hole %d x %s aus dem Briefkasten.',
 action_craft_one='1 Craft vorbereiten',action_combat='Beende den Kampf, bevor du den Beruf öffnest oder craftest.',action_choose_profession='Öffne den gewünschten Beruf einmal über dein Zauberbuch.',action_open_unsupported='Dieser Client kann den Beruf hier nicht öffnen. Nutze dein Zauberbuch.',action_open_failed='Der Beruf konnte nicht geöffnet werden. Prüfe, ob du ihn erlernt hast.',action_opening='Das normale Berufsfenster wird geöffnet. Dort erneut zum Craften klicken.',action_busy='Eine Herstellung läuft bereits.',action_recipe_missing='Öffne deinen Beruf und lerne zuerst das empfohlene Rezept.',action_changed='Plan oder Preis geändert. Prüfe den aktualisierten Knopf und klicke erneut.',action_enchant_target='Verzaubern benötigt ein Zielitem. Wähle Verzauberung und Ziel im Berufsfenster.',action_materials='Hole zuerst die benötigten Materialien in deine Taschen.',action_craft_unsupported='Craft-API nicht verfügbar. Nutze den Herstellen-Knopf im Berufsfenster.',action_craft_failed='Herstellung konnte nicht starten. Prüfe das Berufsfenster und die Fehlermeldung des Spiels.',action_craft_started='Eine Herstellung angefordert. Warte auf den Abschluss im Spiel.',
 ah_load_body='Bereite Angebote für %d x %s vor. Es wurde noch nichts gekauft.',ah_load_button='Geplanten Kauf vorbereiten',ah_confirm_body='Bestätige %d x %s für %s. Erst die Spielbestätigung zählt als Kauf.',ah_confirm_button='Kauf bestätigen: %s',ah_check_dialog='Prüfe die Auctionator-Preiswarnung oder brich den Kaufdialog ab.',ah_check_dialog_button='Kaufdialog prüfen',ah_wait_quote='Warte auf das aktuelle Preisangebot des AH.',ah_wait_button='Warte auf AH',ah_no_affordable='Keine Angebote innerhalb deiner Preisgrenze. Angebote neu laden oder warten.',ah_ready_body='Kaufe %d x %s für %s. Ein Klick fordert das endgültige Preisangebot an.',ah_buy_button='%d kaufen: %s',ah_select_native='Wähle das Material in Auctionator aus. Dieser Client stellt den direkten Reagenzien-Kaufdialog nicht bereit.'}}
for lang,entries in pairs(actionWords)do for k,v in pairs(entries)do app.words[lang][k]=v end end
app.words.en.shop_in_mail='Search submitted, not purchased. Continue the purchase in Next step or Auctionator.'
app.words.de.shop_in_mail='Suche übergeben, noch kein Kauf. Kaufe über Nächster Schritt oder Auctionator weiter.'
app.words.en.guide_step5_body='Submit the search. In Next step, load the purchase, check quantity/price and confirm. Collect mail only after confirmed success, then craft.'
app.words.de.guide_step5_body='Suche senden. In Nächster Schritt Kauf vorbereiten, Menge/Preis prüfen und bestätigen. Erst nach Kauferfolg Post abholen, dann craften.'

app.words.en.action_enchant_select='Select enchantment';app.words.de.action_enchant_select='Verzauberung auswählen'

app.words.en.step_units='items';app.words.de.step_units='Stück'

app.words.en.profession_loading='Profession is open. Waiting for skill and recipe data to load.';app.words.en.profession_loading_button='Loading recipes...'
app.words.de.profession_loading='Beruf ist geöffnet. Warte, bis Skill und Rezeptdaten geladen sind.';app.words.de.profession_loading_button='Rezeptdaten werden geladen...'

app.words.en.step_review_button='Review recipes';app.words.de.step_review_button='Rezepte prüfen'
app.words.en.ah_pending_body='Purchase sent. Waiting for the game result; another purchase is blocked.'
app.words.de.ah_pending_body='Kauf gesendet. Warte auf die Spielantwort; weiterer Kauf ist gesperrt.'
app.words.en.ah_uncertain_body='Purchase result is unconfirmed. Check mail, bags and diagnostics before retrying. No automatic repeat purchase.'
app.words.de.ah_uncertain_body='Kaufergebnis unbestätigt. Prüfe Post, Taschen und Diagnose. Kein automatischer Wiederholungskauf.'
app.words.en.ah_batch_done='This skill/craft plan has already used its purchase allowance. Waiting for inventory reconciliation or the next completed craft.'
app.words.de.ah_batch_done='Die Kaufmenge dieses Skillplans ist abgearbeitet. Warte auf den Bestandsabgleich oder den nächsten abgeschlossenen Craft.'
app.words.en.ah_diagnose_button='Purchase diagnostics'
app.words.de.ah_diagnose_button='Kaufdiagnose'
app.words.en.ah_live_repriced='Live price updated: %s each. Route and purchase cost re-evaluated.'
app.words.de.ah_live_repriced='Livepreis aktualisiert: %s je Stück. Route und Einkauf neu bewertet.'
app.words.en.ah_stock_breakdown='Needed %d / owned %d / confirmed mail %d / still to buy %d'
app.words.de.ah_stock_breakdown='Bedarf %d / Bestand %d / bestätigte Post %d / noch kaufen %d'

app.words.en.ah_stock_breakdown='Needed %d | Owned %d | Mail %d\nPurchase pending %d | Still to order %d'
app.words.de.ah_stock_breakdown='Bedarf %d | Bestand %d | Post %d\nIm Kauf %d | Noch bestellen %d'

app.words.en.shop_limit='Unit-price limit: latest price +%d%%';app.words.de.shop_limit='Stückpreisgrenze: aktueller Preis +%d%%'
local flowWords={en={flow_log_title='Flow log',flow_copy='Select / Ctrl+C',flow_refresh='Refresh',flow_clear='Clear log',flow_enable='Enable log',flow_disable='Disable log',flow_log_status='%d / %d entries. Copy with Ctrl+C and paste into the chat.',flow_log_tip='Open the diagnostic flow log. Copy with Ctrl+C. Also available via /cdj log.',
 craft_native_confirm='Prepared: %d crafts. Click the highlighted Create button in the normal profession window.',craft_native_hint='The game requires your click in the profession window. Use Create, not Create all.',craft_native_show='Show Create button',craft_native_back='Back',craft_native_missing='Use the normal profession window. Its quantity control could not be prepared; no craft was started.',craft_queue_waiting='Requested %d crafts. Waiting for the game to confirm the first cast.',craft_no_start='No craft start confirmed. No automatic retry. See /cdj log and the native craft button.',craft_client_blocked='The game blocked this addon action: %s. Use the native craft button; the block is recorded in the log.',craft_batch_started='Requested a batch of up to %d crafts.',craft_batch_incomplete='The native batch ended early: %d crafts remain. See the log before retrying.',craft_batch_stopped='Batch stopped.',craft_stop_native='Recommendation changed or stop API unavailable. Stop the batch in the native profession window.',craft_queue_attention='Stop the batch in the normal profession window or press Esc before following another recipe.',craft_queue_running='Batch running: %d crafts remaining. No new shopping while materials are being used.',craft_queue_button='Crafting...',craft_stock_count='Ready now: %d | Batch: %d',craft_use_stock='Use your materials first: %d crafts available in bags. The batch is limited by the next switch (skill %d).',craft_stock_priority='Use available bag materials before buying for the rest of the plan.',craft_all_button='Prepare all (%d)',craft_stop_button='Stop: Esc',craft_all_tip='Prepare a bounded quantity in the native profession window. Click the highlighted native Create button yourself to start.'},
 de={flow_log_title='Verlaufsprotokoll',flow_copy='Markieren / Strg+C',flow_refresh='Aktualisieren',flow_clear='Log leeren',flow_enable='Log einschalten',flow_disable='Log ausschalten',flow_log_status='%d / %d Einträge. Mit Strg+C kopieren und im Chat einfügen.',flow_log_tip='Verlaufsprotokoll öffnen. Mit Strg+C kopieren. Auch über /cdj log erreichbar.',
 craft_native_confirm='Vorbereitet: %d Crafts. Klicke im normalen Berufsfenster auf den hervorgehobenen Erstellen-Knopf.',craft_native_hint='Der Start braucht deinen Klick im Berufsfenster. Nutze Erstellen, nicht Alle erstellen.',craft_native_show='Erstellen-Knopf zeigen',craft_native_back='Zurück',craft_native_missing='Nutze das normale Berufsfenster. Die Stückzahl konnte nicht vorbereitet werden; es wurde kein Craft gestartet.',craft_queue_waiting='%d Crafts angefordert. Warte auf die Startbestätigung des Spiels.',craft_no_start='Kein Craft-Start bestätigt. Kein automatischer Neuversuch. Prüfe /cdj log und den normalen Herstellen-Knopf.',craft_client_blocked='Das Spiel hat diese Addon-Aktion blockiert: %s. Nutze den normalen Herstellen-Knopf; die Blockierung steht im Log.',craft_batch_started='Sammelherstellung für bis zu %d Crafts angefordert.',craft_batch_incomplete='Die native Serie endete vorzeitig: noch %d Crafts. Prüfe vor dem nächsten Versuch das Log.',craft_batch_stopped='Sammelherstellung gestoppt.',craft_stop_native='Empfehlung geändert oder Stop-API nicht verfügbar. Stoppe die Sammelherstellung im normalen Berufsfenster.',craft_queue_attention='Stoppe die Serie im normalen Berufsfenster oder mit Esc, bevor du einem anderen Rezept folgst.',craft_queue_running='Sammelherstellung läuft: noch %d Crafts. Währenddessen kein neuer Einkaufsauftrag.',craft_queue_button='Herstellung läuft',craft_stock_count='Sofort: %d | Sammelmenge: %d',craft_use_stock='Nutze zuerst deinen Bestand: %d Crafts aus den Taschen möglich. Sammelmenge bis zum nächsten Wechsel begrenzt (Skill %d).',craft_stock_priority='Vorhandene Taschenmaterialien zuerst verbrauchen; danach den restlichen Plan einkaufen.',craft_all_button='Alle vorbereiten (%d)',craft_stop_button='Stoppen: Esc',craft_all_tip='Begrenzte Stückzahl im Berufsfenster vorbereiten. Zum Start den hervorgehobenen normalen Erstellen-Knopf selbst anklicken.'}}
for lang,entries in pairs(flowWords)do for k,v in pairs(entries)do app.words[lang][k]=v end end

app.words.en.guide_step5_body='Use stock first: Craft 1 or Craft all. Then buy, confirm and collect mail. Problems: /cdj log, Ctrl+C.'
app.words.de.guide_step5_body='Bestand zuerst: 1 oder Alle herstellen. Danach nachkaufen, bestätigen und Post abholen. Probleme: /cdj log, Strg+C.'
app.words.en.help=app.words.en.help..' · /cdj log';app.words.de.help=app.words.de.help..' · /cdj log'

local actionWords={en={
 goal_manual_summary='Manual +%d | %s',goal_rank_task='Visit your profession trainer: %s.',goal_rank_button='Visit profession trainer',task_important='! IMPORTANT - NEXT ACTION',craft_cue_click='Click here: craft %d',
 goal_review='Review recipes and prices',goal_learn='Learn %s',goal_switch='Switch to %s',goal_rank='Train profession rank %d-%d',
 goal_auto_title='Plan until skill %d',goal_mode_next='Goal: next action',goal_mode_manual='Goal: manual',
 goal_route_count='Until skill %d: %s%d crafts',goal_route_at='At skill %d',
},de={
 goal_manual_summary='Manuell +%d | %s',goal_rank_task='Geh zum Berufslehrer: %s.',goal_rank_button='Berufslehrer aufsuchen',task_important='! WICHTIG - JETZT ERLEDIGEN',craft_cue_click='Hier klicken: %d herstellen',
 goal_review='Rezepte und Preise neu prüfen',goal_learn='%s lernen',goal_switch='Zu %s wechseln',goal_rank='Berufsrang %d-%d lernen',
 goal_auto_title='Plan bis Skill %d',goal_mode_next='Ziel: nächste Aktion',goal_mode_manual='Ziel: manuell',
 goal_route_count='Bis Skill %d: %s%d Herstellungen',goal_route_at='Bei Skill %d',
}}
for language,values in pairs(actionWords)do for key,value in pairs(values)do app.words[language][key]=value end end

for language,values in pairs({en={scan_locked_button='Wait for current scan',scan_locked_title='Updating auction prices',scan_processing='Scan results are being processed. Shopping unlocks only after successful completion.'},de={scan_locked_button='Warte auf aktuellen Scan',scan_locked_title='AH-Preise werden aktualisiert',scan_processing='Scan-Ergebnis wird verarbeitet. Der Einkauf wird erst nach erfolgreichem Abschluss freigegeben.'}})do
 for key,value in pairs(values)do app.words[language][key]=value end
end

app.words.en.shop_limit='Unit price limit: current AH data +%d%%'
app.words.de.shop_limit='Stückpreisgrenze: aktuelle AH-Daten +%d%%'

-- Net ranking is separate from the gross gold required to buy reagents.
app.words.en.per_point="%s materials/craft · %s%s net/skill · %s"
app.words.de.per_point="%s Material/Craft · %s%s netto/Skill · %s"
app.words.en.next_at="At skill %d · %s · %s%s net/skill"
app.words.de.next_at="Ab Skill %d · %s · %s%s netto/Skill"
app.words.en.next_now="Now · %s · %s%s net/skill"
app.words.de.next_now="Jetzt · %s · %s%s netto/Skill"
app.words.en.net_breakdown="Per craft: %s materials - %s vendor value = %s net. Assumes you sell the output; buying materials still needs the full purchase amount."
app.words.de.net_breakdown="Pro Craft: %s Material - %s Händlerwert = %s netto. Gilt bei Verkauf des Ergebnisses; zum Materialkauf brauchst du weiterhin den vollen Einkaufsbetrag."
app.words.en.net_unverified="No confirmed vendor credit available; comparison uses full material cost."
app.words.de.net_unverified="Kein bestätigter Händlererlös verfügbar; Vergleich mit vollen Materialkosten."
app.words.en.net_minimum="Vendor value uses the confirmed minimum output, not the maximum or average. No AH resale income included."
app.words.de.net_minimum="Händlerwert anhand der bestätigten Mindestausbeute, nicht Maximum oder Durchschnitt. Keine AH-Verkaufserlöse eingerechnet."
