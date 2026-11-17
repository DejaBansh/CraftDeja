# beta.25 release review — 17 November 2026

User explicitly authorized source-choice improvements, the rank-cap correction and a new GitHub/CurseForge beta upload. No main merge. Existing beta.24 file and tag remain unchanged.

Same-channel published baseline is file9656532, source a52b9cf09f047b4bdcedf596a7007cdc3ba97409, public CDN archive SHA256 F16968A9AFD2A33A50E6A6F6DEFC6F6C3B8C3158683D4DA80E5A20AC4AA26116. The downloaded public archive matches the previous official upload. Subsequent documentation-only commits add no runtime features.

Review the actual delta against that commit in src and wowlua.json, including MaterialSources, native reagent allocation checks, rank priority and the single extra reference trainer. docs/MATERIAL_SOURCES_BETA25.md distinguishes measured code behavior, user observations and unverified market/live claims. New regression suite covers23 cases; earlier fixtures explicitly represent previously accepted stock choices rather than suppressing the new user-choice tests.

Claims in the DE/EN notes cover only beta.25. No automatic protected crafting, guaranteed cheapest global route, historical own-stock price guarantee, fully verified trainer atlas or FPS claim. Raw player screenshots, logs and local reports are not committed. Full suite, release checks and source hashes must pass before approved becomes true. Native UI evidence remains source emulation; actual Forever live acceptance is open.

The release workflow must validate the exact version and channel, package all runtime/artwork/licenses, pass its own full suite and perform a single official API upload. Public description still requires the official Author Console; a successful preparation job is not a description write. File receipt and description status must be reported separately.

Final approval: reports/tests/20261117-054821-3541b2.zip passed657/0/0 in208.54s (324files), release build successful. Final matrix reports/workshop-matrix/20261117-054835:1920x1080 and3440x1440, UI65%/100%, each14/0/0; current source hashes match. Targeted23/0/0 in7.58s with emulated views;26release checks and actionlint clean. Full staged diff reviewed for scope and secrets; no raw player data or local reports committed. Compiler emitted the known lazy-root warning and four unused-local test-fixture warnings; no errors.
