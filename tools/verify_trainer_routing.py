#!/usr/bin/env python3
"""Reproduce 42 focused routing cases in a minimal wowlua project (no Blizzard UI).

Uses the repository's PowerShell test reporter, so every invocation creates a ZIP.
Dependencies: Python stdlib, wowlua on PATH, and PowerShell (pwsh or powershell.exe).
The output directory is retained under reports/routing-focused for inspection.
This does not replace the complete addon/Blizzard-UI regression run.
"""
import argparse
from datetime import datetime
import json
import os
from pathlib import Path
import shutil
import subprocess
from uuid import uuid4


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--powershell', default='pwsh')
    args = parser.parse_args()
    shell = shutil.which(args.powershell)
    if not shell:
        parser.error('PowerShell not found; specify --powershell powershell.exe on Windows')
    root = Path(__file__).resolve().parents[1]
    dest = root / 'reports/routing-focused' / (datetime.now().strftime('%Y%m%d-%H%M%S') + '-' + uuid4().hex[:6])
    (dest / 'src/Data').mkdir(parents=True)
    (dest / 'tests/MapSuite').mkdir(parents=True)
    sources = ['Start.lua', 'Words.lua', 'Data/FactionAccess.lua',
               'Data/TrainerLocations.lua', 'Data/RecipeSourceCorrections.lua',
               'Access.lua', 'Trainers.lua', 'MapPins.lua']
    for name in sources:
        shutil.copyfile(root / 'src' / name, dest / 'src' / name)
    (dest / 'src/Bootstrap.lua').write_text(
        'local _,a=...\na.initialize()\na.showCentralGuide=function()end\n', encoding='utf-8')
    shutil.copytree(root / 'tests/TrainerRoutingSuite', dest / 'tests/TrainerRoutingSuite')
    chosen = {1, 2, 3, 10, 11, 12, 13, 14, 15, 16, 17, 18}
    for path in (root / 'tests/MapSuite').glob('*.test.wowlua'):
        if int(path.name[:2]) in chosen:
            shutil.copyfile(path, dest / 'tests/MapSuite' / path.name)
    manifest = {'package': {'name': 'routing-isolated', 'version': '0.1.0'},
                'addon': {'title': 'RoutingIsolated'}, 'flavors': {'camelot': {}},
                'build': {'load-order': ['src/' + name for name in sources] + ['src/Bootstrap.lua']},
                'test': {'platform': 'windows'}}
    (dest / 'wowlua.json').write_text(json.dumps(manifest), encoding='utf-8')
    print('Focused routing module project without Blizzard UI: ' + str(dest), flush=True)
    result = subprocess.run([shell, '-NoProfile', '-ExecutionPolicy', 'Bypass', '-File',
                             str(root / 'tools/Test-CraftDeja.ps1'), '-ProjectPath', str(dest)])
    print('Reports retained under ' + str(dest / 'reports/tests'), flush=True)
    return result.returncode


if __name__ == '__main__':
    raise SystemExit(main())
