# beta.23 publication review — 16 November 2026

## What is verified

- Source starting point: 962a28bea44397d0356d785d5ba5563116255be7, beta.23.
- Public project 1796977 is CraftDeja, WoW Forever, supported game 1.60.1.
- Public Forever file listing uses gameVersionTypeId=88568. This is a **type**, not the individual version ID. The uploader must resolve exactly one `1.60.1` entry of type 88568 via the authenticated official versions API. No token-free ID lookup succeeded (HTTP 401); no invented numeric version ID is stored.
- Public file 9642059: CraftDeja-3.9.0-beta.18-release.zip, uploaded 16 November 2026, **Release** channel despite its beta filename. Local package history maps beta.18 to source 9a65820eee5db5cf0ee2e89ba5eea60ee7474c39. This mapping is a local provenance record, not a downloaded-file checksum proof.
- `git diff 9a65820eee5db5cf0ee2e89ba5eea60ee7474c39..962a28bea44397d0356d785d5ba5563116255be7 -- src wowlua.json` reviewed against RouteModel/Planner/Costs/Runtime, RouteSupply/Guild/Trainer/Bank, BankTransfer, MerchantVisibility, LocationRouting/TrainerNavigation, Launcher and WorkshopSkin/Dashboard. beta.19–23 notes and regression suites corroborate the supplied feature claims.
- The proposed notes cover the actually implemented changes since that latest visible Release file, not only the beta.23 UI patch. Existing older stability improvements are not advertised as newly introduced again.
- User reports beta.23 works very well in the portion tested. This is not blanket live acceptance of all professions, scaling, alts, guilds or bank/AH combinations.

## Blocking the first real upload

The public listing's latest visible **Beta-channel** entry is named `CraftDeja_3.8.0_Beta1_DE_EN.zip` (12 November). Its precise file ID and corresponding Git source are not established. Direct fresh listing requests encountered Cloudflare; indexed public results are evidence of visible files, not a guarantee that no newer/manual upload exists. The repository begins at beta.9; the beta.18 Release cannot silently replace the requested same-channel baseline.

Before approving the first tag, check the Author Console's current Beta files and map the actual latest published Beta package to source (or import its verified source snapshot as a baseline commit). Download/check that package and review the complete diff to this version. Revise patchnotes.md to cover that complete delta. Enter the actual baseline file ID and full Git commit in release.json; only then set historyReviewComplete and approved to true. Never populate these with synthetic test IDs. If beta.23 has already been manually published, prepare a new version rather than upload it twice.

For subsequent releases: select the latest **actually published same-channel file**, not merely the latest tag or successful build. Use the successful upload receipt/file page and moderation status, update baseline and texts before pushing a new tag. Retain a reviewed source mapping; GitHub artifact retention alone is not a permanent history ledger.

## Description limitation

Official Upload API documents file upload, file metadata/changelog updates and localization. It does not document main-description editing. The Studios API has GET description but no description-write operation. Therefore description publication is a separate **manual Author Console task**, reported as `manual_author_console_required`. No guessed/private endpoint or session-cookie automation. `description-only` regenerates the exact committed text without uploading another file; no token needed.

## Primary sources checked

- https://support.curseforge.com/support/solutions/articles/9000197321-curseforge-upload-api
- https://docs.curseforge.com/rest-api/
- https://blog.curseforge.com/monthly-console-notes-october-2026/ (official Description editor)
- https://www.curseforge.com/wow/addons/craftdeja/files/9642059
- https://www.curseforge.com/wow/addons/craftdeja/files/all?gameVersionTypeId=88568&page=1&pageSize=20&showAlphaFiles=hide
- https://wowlua.dev/docs/guide/publishing (tag version semantics / release profile)

## Permissions

CF_API_TOKEN is an author Upload API token, sent only as X-Api-Token to wow.curseforge.com. Its owner must have file-upload permission for existing project 1796977; actual authorization is checked by the service. No permission or secret is created here. It is not a Studios x-api-key and does not grant a nonexistent description-write endpoint. The dry run has no token and no upload code path. Main and game installation are unaffected.
