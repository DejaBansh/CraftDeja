// Run from the CraftDeja root with a checkout of the pinned upstream revision.
import fs from 'node:fs';
import path from 'node:path';
import { execFileSync } from 'node:child_process';

const revision = 'd66ac9b9cdb47c0a4152e835b137bef85bdc127f';
const checkout = process.argv[2];
if (!checkout || execFileSync('git', ['-C', checkout, 'rev-parse', 'HEAD'], {encoding:'utf8'}).trim() !== revision)
    throw Error('Expected OneForAll checkout at ' + revision);
// Read committed objects so local changes cannot alter provenance.
function read(file) {
    return execFileSync('git', ['-C', checkout, 'show', revision + ':OneForAll/Data/' + file], {encoding:'utf8',maxBuffer:32e6});
}
function table(file, name) {
    const start = 'FLT.' + name + ' = {\n';
    const body = file.split(start)[1];
    if (!body) throw Error('Missing table ' + name);
    return body.split('\n}')[0];
}
const sides = {A:'Alliance', H:'Horde', AH:'Both'};
const q = JSON.stringify;
const routes = new Map(), items = new Map(), byItem = new Map(), vendors = new Map(), stocks = new Map();
function route(spell, entry) {
    if (!routes.has(spell)) routes.set(spell,new Map());
    routes.get(spell).set(q(entry),entry);
}
function stock(item, ids) {
    if (!stocks.has(item)) stocks.set(item,new Set());
    for (const id of ids.split(',')) if (id) stocks.get(item).add(Number(id));
}
const reagentFile=read('ReagentSources.lua'), stockFile=read('VendorReagents.lua');
for (const [,id,name,map,x,y,side] of table(reagentFile,'REAGENT_VENDORS').matchAll(/\[(\d+)\]=\{("(?:\\.|[^"\\])+"),(\d+),([\d.]+),([\d.]+)(?:,"(A|H)")?\}/g))
    vendors.set(+id,{npc:+id,name:JSON.parse(name),side:sides[side] || 'Both',map:+map,x:+x,y:+y});
for (const [,id,name,side,map,x,y] of table(stockFile,'REAGENT_VENDOR_NPCS').matchAll(/\[(\d+)\]=\{("(?:\\.|[^"\\])+")\s*,"(A|H|AH)",(\d+),([\d.]+),([\d.]+)\}/g))
    vendors.set(+id,{npc:+id,name:JSON.parse(name),side:sides[side],map:+map,x:+x,y:+y});
for (const [,item,ids] of table(stockFile,'VENDOR_REAGENTS').matchAll(/\[(\d+)\]=\{([\d,]*)\}/g)) stock(+item,ids);
for (const [,item,ids] of table(reagentFile,'REAGENT_SOURCES').matchAll(/^\s*\[(\d+)\]=\{[^\n]*?\bv=\{([\d,]+)\}/gm)) stock(+item,ids);

for (const profession of ['Alchemy','Blacksmithing','Cooking','Enchanting','Engineering','FirstAid','Leatherworking','Tailoring']) {
    for (const line of read('Professions/'+profession+'.lua').split('\n')) {
        const spell = Number(line.match(/^\s*\{s=(\d+),/)?.[1]);
        if (!spell) continue;
        const scroll = Number(line.match(/\bri=(\d+)/)?.[1]);
        if (scroll) {
            items.set(spell,scroll);
            if (!byItem.has(scroll)) byItem.set(scroll,new Set());
            byItem.get(scroll).add(spell);
        }
        const src = line.split('src={')[1];
        if (!src) continue;
        for (const [,field,rows] of src.matchAll(/\b(v|d|qs)=\{((?:\{[^{}]+\}(?:, )?)+)\}/g)) {
            for (const [,id,name,rest] of rows.matchAll(/\{(\d+),\s*"([^"]+)"([^}]*)\}/g)) {
                const [,zone,map,x,y] = rest.match(/,\s*"([^"]+)",\s*(\d+),\s*([\d.]+),\s*([\d.]+)/) || [];
                const npc = field==='v' && vendors.get(+id);
                const side = sides[rest.match(/fac="([^"]+)"/)?.[1]] || (npc && npc.side) || 'Unknown';
                const entry={kind:({v:'vendor',d:'drop',qs:'quest'})[field],id:+id,name,side};
                if (map) Object.assign(entry,{zone,map:+map,x:+x,y:+y});
                else if (npc) Object.assign(entry,{map:npc.map,x:npc.x,y:npc.y});
                route(spell,entry);
            }
        }
    }
}
for (const [,id,ids,name] of read('Professions/BossDrops.lua').matchAll(/^\s*\[(\d+)\] = \{([\d, ]+)\}, -- ([^\r\n]+)/gm)) {
    for (const item of ids.split(',')) for (const spell of byItem.get(+item)||[]) {
        if (![...routes.get(spell)?.values()||[]].some(r=>r.kind==='drop' && r.id===+id))
            route(spell,{kind:'drop',id:+id,name,side:'Unknown'});
    }
}
const trainerRows=new Map();
for (const ids of stocks.values()) {
    for (const id of ids) if (!vendors.has(id)) throw Error('Missing merchant location for ' + id);
}
for(const [,id,name,side,map,x,y] of read('ProfessionTrainers.lua').matchAll(/\{(\d+),"([^"]+)","[^"]*","(A|H|AH)",(\d+),([\d.]+),([\d.]+),/g)){
    const row={id:+id,name,side:sides[side],map:+map,x:+x,y:+y};
    trainerRows.set(q(row),row);
}
const luaRow=r=>'{'+Object.entries(r).map(([k,v])=>k+'='+q(v)).join(',')+',reference=true,origin="OneForAll-Forever"}';
const lines=['-- SPDX-License-Identifier: GPL-3.0-only','-- Generated reference data. See Licenses/OneForAll-NOTICE.txt and tools/Import-OneForAll.mjs.','local _,app=...'];
function keyed(name,entries,format) {
    lines.push('app.'+name+'={');
    for (const [key,value] of [...entries].sort(([a],[b])=>a-b)) lines.push(' ['+key+']='+format(value)+',');
    lines.push('}');
}
keyed('ofaRecipeSources',routes,rows=>'{'+[...rows.values()].map(luaRow).join(',')+'}');
keyed('ofaRecipeItems',items,String);
keyed('ofaMerchants',vendors,luaRow);
keyed('ofaStock',stocks,ids=>'{'+[...ids].sort((a,b)=>a-b).join(',')+'}');
lines.push('app.ofaTrainerLocations={',...[...trainerRows.values()].map(row=>' '+luaRow(row)+','),'}');
fs.writeFileSync(path.join('src','Data','OneForAllSources.lua'),lines.join('\n')+'\n');
console.log({recipes:routes.size,scrolls:items.size,merchants:vendors.size,reagents:stocks.size,trainerLocations:trainerRows.size});
