# Development / Entwicklung

This repository contains the source project. Install the finished addon from [CurseForge](https://www.curseforge.com/wow/addons/craftdeja); GitHub's source ZIP is not an installable build.

## Recorded setup

- WoW Forever 1.60.1; game flavor `camelot`; Interface 16001.
- Windows; Git 2.56.0.windows.4; wowlua 0.13.14.
- Current recorded evidence and scope: [TEST_RESULTS.md](../TEST_RESULTS.md) and [evidence index](evidence/index.json). Do not copy changing test counts into this setup guide.
- Start each task with [CONTINUE.md](../CONTINUE.md) and the local read-only `tools/Get-ProjectContext.ps1 -AsJson`. See [context maintenance](PROJECT_CONTEXT.md) and [architecture](ARCHITECTURE.md).

## Get source and build

Install Git and [wowlua](https://github.com/DomenikIrrgang/wowlua), then use PowerShell:

```powershell
git clone https://github.com/DejaBansh/CraftDeja.git
Set-Location CraftDeja
wowlua build
```

The development addon is generated in `dist/dev/CraftDeja`. For a release build:

```powershell
wowlua build --release
```

Use the output directory reported by wowlua; keep the generated TOC and assets together. Do not use the legacy source-root `CraftDeja.toc` to install the source tree. TOCs are generated from `wowlua.json`.

The addon-list icon belongs at `addon.icon-texture` in `wowlua.json`. Putting `IconTexture` under `addon.toc-extra` raises E4002. JSON must be UTF-8 without a BOM.

## Automated tests on Windows

The project enables Blizzard UI tests. Point wowlua at your actual WoW installation root (the directory containing `_forever_`):

```powershell
$env:WOWLUA_WOW_PATH = "C:\Program Files (x86)\World of Warcraft"
.\tools\Test-CraftDeja.ps1 -Profile release -OpenReportFolder
```

Change that path if needed. The wrapper records logs, metadata and source hashes and creates a report ZIP even for failed runs. Do not bypass it with direct Windows `wowlua test` calls. Its default build profile is dev; explicitly select release for release verification. The test emulator itself has no build-profile selector. WoWLua reads the UI code from the installed client. The repository does not redistribute Blizzard's UI code or provide a WoW installation.

Representative suites:

| Suite | What its cases exercise |
|---|---|
| [AutoSkillSuite](../tests/AutoSkillSuite/) | Cost/chance decisions, switches, quantities, stock and skill limits |
| [CraftSuite](../tests/CraftSuite/) | Native crafting preparation, progress and interruption |
| [CraftPerformanceSuite](../tests/CraftPerformanceSuite/) | Deferred heavy updates and lightweight progress during crafting |
| [AHMailSuite](../tests/AHMailSuite/) | Quote, purchase confirmation, duplicates, incoming mail and collection |
| [VendorSuite](../tests/VendorSuite/) | Purchase quantities, changing offers, inventory and confirmations |
| [RodSuite](../tests/RodSuite/) | Rod prerequisites and parent-order continuity |
| [StationCTASuite](../tests/StationCTASuite/) | Specific workstation actions and fallback behaviour |

Mocked purchases do not prove a live protected action succeeds. For in-game checking use the gear menu's guided system check and include its report with a bug.

## Contributing

Read [AGENTS.md](../AGENTS.md), [PROJECT_STATE.md](../PROJECT_STATE.md), [DECISIONS.md](../DECISIONS.md) and [ROADMAP.md](../ROADMAP.md) before changing behaviour. Inspect the code rather than relying on old chat notes.

Preserve the lightweight crafting-update path, purchase confirmations, DE/EN and quantity rules. Run the relevant broad suite after behavioural changes and record version/build/date. Documentation-only changes do not require replaying all game simulations.

Keep secrets and local WoW account files out of the repository. Built files in `dist/` and local caches are ignored. Do not enable automatic CurseForge packaging from source commits without a workflow that produces the installable wowlua output.
