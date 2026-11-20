# CraftDeja — versioned CurseForge releases

## Current scope and honest limits

The workflow `.github/workflows/curseforge-release.yml` handles tags, manual dispatch and the single dedicated test branch `codex/curseforge-dry-run`. No previous local or remote GitHub workflow existed; normal branch pushes remain unchanged. All tags reach strict validation: only `vX.Y.Z` (release) and `vX.Y.Z-beta.N` (beta, N > 0) are accepted. Package manifest, runtime release string and built TOC must match exactly. Alpha, unknown, dirty and mismatched packages cannot publish.

## Current release: beta.26, 20 November 2026

Tag `v3.9.0-beta.26` resolves to `e6cb2909067f41ebc2e3e9def59e3c0274c58606`.
[Actions run 44815834310](https://github.com/DejaBansh/CraftDeja/actions/runs/44815834310)
passed 675 tests and uploaded [CurseForge file 9722537](https://www.curseforge.com/wow/addons/craftdeja/files/9722537)
as Beta for Forever 1.60.1 (version 17053, type 88568). The public CDN ZIP matches
the upload receipt. See TEST_RESULTS.md and releases/published-history.json.

The description job prepared releases/3.9.0-beta.26/description.md for the official
Author Console. Its status is `manual_author_console_required`.
## Previous published file and setup test (history)

The user has already published beta.23 as file **9654021**, changed its type to **Beta**, and supplied an **Approved** Author Console screenshot. The user also reports completing the description edit and adding CF_API_TOKEN. These observations are recorded in `releases/published-history.json`; token permissions remain unverified. The public CDN ZIP has now been downloaded and is byte-identical to the local verified beta.23 release (SHA256 F0633ABFBB186A479ECC85FB33FFE0FE1E194B4C4D6B645B07B0D250052A3A31), establishing source e4b8bdcb69dccd71a05b854d446ee7c8b0cf9d9d as the next Beta baseline. The legacy published TOC still contains 3.9.0-beta.23-alpha+e4b8bdc; future workflow packages require exact tag versions. Do not push a beta.23 release tag or upload it again. The next actual release needs a new version, genuine changes and its own reviewed texts.

To exercise Actions without merging main, push the reviewed workflow commit to the **dedicated** `codex/curseforge-dry-run` branch. That branch runs only package/tests with `-DryRun`; the candidate version comes from wowlua.json. The real upload job requires both a push event and `refs/tags/`, so it cannot receive CF_API_TOKEN on this branch. The description job is skipped too. No release tag is created in the real repository. The private build clone may tag itself for exact package-version validation.

The official Upload API can publish the installable file and its Markdown patch notes. It has **no documented main-description update operation**. The Studios API provides GET description, not a write operation. Therefore the third requested automatic operation cannot honestly be implemented with CF_API_TOKEN. The official supported completion is Author Console → project 1796977 → Description → Edit → Markdown. This workflow exposes `manual_author_console_required`, never a fabricated success.

The `description-only` manual mode checks out the original release tag and produces the exact versioned description plus instructions. It never builds/uploads another addon and needs no token. Repeat it if the human description step was missed. File ID/upload status and description status are separate in the receipt and job summary.

## Per-release editorial approval

1. Inspect the actual published files in the Author Console for the intended channel. A filename containing beta is not proof of Beta-channel publication. Wait for approval/publication; an API-accepted file is not yet a published baseline.
2. Record its file ID, channel, full corresponding source commit and evidence in `releases/<version>/release.json` and `REVIEW.md`. Review the Git diff and actual implemented behavior. If a manually built old file has no source mapping, establish/import a verified baseline first; do not invent a mapping.
3. Write `description.md` and `patchnotes.md`, both DE/EN. Each version gets its own full copies, not a moving root file. Mention only included features; distinguish beta features, estimates and verified behavior. Review missing prices, search limits and source coverage against code.
4. Update `package.version` and `app.release` together. Set `historyReviewComplete` and `approved` to true only after resolving every review blocker. Commit texts and source **before tagging**.
5. Run the full dry run on that source. Review ZIP, TOC, exact texts and metadata. Beta.23 is currently deliberately **not approved** because the latest published same-channel Beta source is not verified. Read its REVIEW.md. A local comparison to beta.18 Release is available but does not replace the Beta baseline.

## Secret and permissions

Repository: https://github.com/DejaBansh/CraftDeja/settings/secrets/actions

Settings → Secrets and variables → Actions → **New repository secret** → name **CF_API_TOKEN**.

Use an official author Upload API token from the account with file-upload permission on project **1796977**. This is not a Studios `x-api-key`. The workflow sends it only in `X-Api-Token` to `https://wow.curseforge.com`; it is scoped to the upload step, never a URL, CLI parameter or artifact. Secret creation and actual token permissions were not performed/verified in this task.

No secret is needed for the package/dry-run job. No auth/cookies or private web endpoints are used for description editing.

## Game mapping and package validation

Forever uses interface **16001**, currently game version **1.60.1**. The public Forever file-list filter is **gameVersionTypeId=88568**, not a version ID. Before uploading, the token-authenticated official `/api/game/versions` response must contain exactly one matching name/type with a positive ID. Only that ID goes into upload `gameVersions`. Missing/ambiguous mappings fail closed. Token-free lookup returned 401 locally; the exact numeric version ID is therefore deliberately unresolved in dry-run metadata.

Windows runner, official WoWLua **0.13.14**, download SHA256 pinned. A private local clone builds the exact source commit. In dry runs only, an isolated local tag enables the same exact tagged version without creating/pushing a real repository tag. Full tests run through `tools/Test-CraftDeja.ps1 -Profile release -Evidence`, now with `--locked` build/test commands. No filters/skips/failures allowed; captured input hashes must still match at packaging.

The package contains only `CraftDeja/` at root, TOC/interface/release marker and all TOC runtime entries, all source Art assets with matching hashes, dependency LICENSES.txt, project LICENSE, imported-data Licenses files and DATA_SOURCES.md. WoWLua's generated component-license list alone does not cover imported data. New packaging adds these explicit provenance files. No development runtime/instrumentation, tests, reports, source paths, `.git` or secrets. ZIP entry bytes are individually hashed after creation.

## Dry run

GitHub → Actions → **CurseForge release** → Run workflow → choose the feature branch containing this workflow → mode `dry-run`, tag `v3.9.0-beta.23`. The input is validated as the candidate version, not pushed.

The workflow must be present on the default branch before GitHub exposes `workflow_dispatch` in the normal Actions UI. This task does not merge main. Until then use the local equivalent:

```powershell
pwsh -NoProfile -File tools/Test-ReleasePipeline.ps1
pwsh -NoProfile -File tools/New-CurseForgeRelease.ps1 -Tag v3.9.0-beta.23 -DryRun -OutputPath reports/my-release-dry-run
```

Run from a clean committed worktree. Artifacts live in `<OutputPath>/artifacts/`: installable ZIP, description.md, patchnotes.md, release.json, REVIEW.md, upload-metadata.preview.json, release-evidence.json and TEST-REPORT.zip. The contained source clone/tag stays local and does not affect real refs. Failed tests retain automatic ZIP reports under `<OutputPath>/source/reports/tests/`.

## Publishing a new approved beta

Prepare the new version fields, release directory, verified baseline and dry run first.
Push the reviewed feature branch. Once the selected commit contains both approved texts and
has passed the dry run, create and push its new tag. Substitute the actual approved version
and commit in this PowerShell example.

```powershell
$tag = 'vX.Y.Z-beta.N'
$reviewedCommit = 'REVIEWED_COMMIT_SHA'
git tag -a $tag $reviewedCommit -m "CraftDeja $tag"
git push origin "refs/tags/$tag"
```

The tag push makes the tagged workflow available even before any separate main merge; do not force or move an existing tag. If this version was already manually uploaded, use the next version with newly reviewed texts instead. A stable release uses `v3.9.0` only after changing both actual version fields, creating that version's approved release directory and testing it; this is not a way to relabel the current beta as stable.

## Partial success and duplicate prevention

Uploads run serially per project, never cancel an in-progress upload. No automatic POST retry. File ID is saved as soon as the API returns it; receipt artifact runs even on failure. `accepted_moderation_pending` is not public approval. A lost response retains `attempt_started_result_uncertain`; inspect Author Console before any new upload. GitHub re-run attempts and receipts with a prior ID/uncertain state cannot upload again. Do not solve a description problem by deleting/re-pushing the tag or re-running the upload.

After successful file upload: copy the tagged description via the Author Console and verify the public page. If necessary, run `description-only` with the same tag. This mode generates no file POST. Record completion and the actual published file/source mapping for the next release.

## Official references

- [CurseForge Upload API](https://support.curseforge.com/support/solutions/articles/9000197321-curseforge-upload-api)
- [CurseForge Studios API](https://docs.curseforge.com/rest-api/)
- [Official Description editor](https://blog.curseforge.com/monthly-console-notes-october-2026/)
- [WoWLua build/tag semantics](https://wowlua.dev/docs/guide/publishing)
