#!/usr/bin/env python3
"""Isolated Lua 5.1 verification of the EconomyEvidenceSuite against src/Economy.lua.

Dependency: python -m pip install lupa==2.8
Run from any directory: python tools/verify_economy.py
This is NOT wowlua, Blizzard UI, event-loop, AH-provider or live-server validation.
The adapter removes only this suite's imports and @test declarations; the Lua test
bodies and production Economy.lua are executed unchanged in fresh Lua runtimes.
"""
from pathlib import Path
import hashlib
import re
import sys

try:
    from lupa.lua51 import LuaRuntime
except ImportError:
    sys.exit("Install the isolated runner dependency: python -m pip install lupa==2.8")

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "src/Economy.lua"
SUITE = ROOT / "tests/EconomyEvidenceSuite/economy.test.wowlua"
source = SOURCE.read_text(encoding="utf-8-sig")
suite = SUITE.read_text(encoding="utf-8-sig")
suite = re.sub(r'^import .+ from "wowlua:(?:test|mock)"\r?\n', '', suite, flags=re.M)
pattern = r'@test\("([^"\n]+)"\)\s*\nlocal function (\w+)\(\)'
cases = re.findall(pattern, suite)
if len(cases) != 20 or len(set(name for _, name in cases)) != len(cases):
    sys.exit("Unexpected suite structure; review the adapter before running.")
suite = re.sub(r'@test\("[^"\n]+"\)\s*\n', '', suite)
if '@' in suite or re.search(r'^import ', suite, re.M):
    sys.exit("Unsupported syntax in isolated suite adapter.")

bootstrap = '''
_G.CraftDeja = {options={green=true}}
local app = _G.CraftDeja
local mock = {}
function mock.stub(object,key,replacement)
    assert(object==app and (key=="unitPrice" or key=="canRecommend"),
        "Only fixture boundary stubs are permitted")
    object[key]=replacement
end
'''
print("Engine: Lua 5.1 (lupa); isolated economic module verification")
print("Economy.lua SHA256: " + hashlib.sha256(SOURCE.read_bytes()).hexdigest())
failed = 0
for title, name in cases:
    lua = LuaRuntime(unpack_returned_tuples=True)
    app = lua.table_from({"options": lua.table_from({"green": True})})
    lua.globals().CraftDeja = app
    lua.execute(source, "CraftDeja", app)
    # Bootstrap exposes the same production object, not a replacement module.
    fixture = bootstrap.replace('_G.CraftDeja = {options={green=true}}\n', '')
    try:
        lua.execute(fixture + '\n' + suite + '\n' + name + '()')
        print("PASS " + title)
    except Exception as exc:
        failed += 1
        print("FAIL " + title + "\n" + str(exc))
print(f"Result: {len(cases)-failed} passed, {failed} failed")
sys.exit(bool(failed))
