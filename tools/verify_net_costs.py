#!/usr/bin/env python3
"""Run 87 focused economic cases in a temporary minimal wowlua project.

Usage: python tools/verify_net_costs.py --wowlua /path/to/wowlua
Requires Python stdlib and wowlua only. No WoW installation / Blizzard UI is used.
This does NOT replace `wowlua test` against the full addon and Blizzard UI.
Production source files and test bodies are copied unchanged. The small bootstrap
initializes the namespace and supplies non-UI helpers for selected legacy tests.
"""
import argparse
import json
from pathlib import Path
import shutil
import subprocess
import tempfile


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--wowlua', default='wowlua')
    args = parser.parse_args()
    executable = shutil.which(args.wowlua)
    if not executable:
        parser.error('wowlua executable not found')
    root = Path(__file__).resolve().parents[1]
    version = subprocess.check_output([executable, '--version'], text=True).strip()
    print('Focused module validation: ' + version + '; camelot/Windows emulation, NO Blizzard UI', flush=True)
    with tempfile.TemporaryDirectory(prefix='craftdeja-net-') as tmp:
        dest = Path(tmp)
        (dest / 'src').mkdir()
        (dest / 'tests').mkdir()
        sources = ['Start.lua', 'Words.lua', 'Client.lua', 'Economy.lua', 'Poisons.lua']
        for name in sources:
            shutil.copyfile(root / 'src' / name, dest / 'src' / name)
        (dest / 'src/Bootstrap.lua').write_text(
            'local _,a=...\na.initialize()\na.shopping={}\n'
            'a.showCentralGuide=function()end\n'
            'a.inventoryFor=function()return {total=0,bags=0,bank=0,alts={}}end\n', encoding='utf-8')
        for suite in ['EconomyEvidenceSuite', 'NetCostSuite']:
            shutil.copytree(root / 'tests' / suite, dest / 'tests' / suite)
        legacy = dest / 'tests/AutoSkillSuite'
        legacy.mkdir()
        chosen = [p for p in (root / 'tests/AutoSkillSuite').glob('*.test.wowlua')
                  if p.name[:2].isdigit() and 1 <= int(p.name[:2]) <= 17]
        if len(chosen) != 17:
            parser.error('Expected exactly 17 legacy economic cases; review the selection')
        for path in chosen:
            shutil.copyfile(path, legacy / path.name)
        manifest = {
            'package': {'name': 'net-costs-isolated', 'version': '0.1.0'},
            'addon': {'title': 'NetCostsIsolated'},
            'flavors': {'camelot': {}},
            'build': {'load-order': ['src/' + name for name in sources] + ['src/Bootstrap.lua']},
            'test': {'platform': 'windows'}
        }
        (dest / 'wowlua.json').write_text(json.dumps(manifest), encoding='utf-8')
        return subprocess.run([executable, 'test', '--manifest', str(dest / 'wowlua.json')], cwd=dest).returncode


if __name__ == '__main__':
    raise SystemExit(main())
