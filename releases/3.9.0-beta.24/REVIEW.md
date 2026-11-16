# beta.24 publication review — 16 November 2026

The user authorized fixing the reported guide bugs and publishing the next beta directly. No main merge is authorized. The existing beta.23 tag and published file must remain unchanged.

Same-channel baseline: CurseForge Beta file 9654021, source e4b8bdcb69dccd71a05b854d446ee7c8b0cf9d9d, official CDN SHA256 F0633ABFBB186A479ECC85FB33FFE0FE1E194B4C4D6B645B07B0D250052A3A31. Downloaded archive matches the recorded original package. See releases/published-history.json. The legacy beta.23 TOC has an alpha suffix; beta.24 must use the exact approved tag version.

Runtime delta since that source is the guide/quantity/price/station/graphics/unlock patch described in docs/UNDERCITY_GUIDE_BETA24.md. The intervening commits add release automation and provenance, not previously absent player features. Compare `git diff e4b8bdcb69dccd71a05b854d446ee7c8b0cf9d9d -- src wowlua.json` and the release packaging scripts. Patch notes advertise only this delta, in German and English.

The supplied beta.23 game log corroborates five-craft versus ten-craft quantities, lost live price context and the mixed-vendor poison prompt. Controlled WoWLua native-API fixtures reproduce these paths. Native station observation and dimensions/UV geometry are tested, but this is not live acceptance of beta.24. No verified worldwide station atlas, automatic weekly vendor-recipe sync, pathfinding or FPS claim.

The description keeps the existing true feature overview and adds the limited station and safer-shopping behavior. Raw player logs, screenshots and local test ZIPs are not committed or included in player payloads. Existing licenses and artwork remain in the release.

Approval completed: 634/0/0 in 209.27s (reports/tests/20261116-231943-98a8e1.zip), 26/0 pipeline checks, actionlint clean, four screen/scale cases each 14/0/0, source/input hashes verified and complete diff reviewed. TEST_RESULTS.md and CONTINUE.md record those results. A clean tagged build must pass the release pipeline before its single CurseForge POST. File ID and moderation status are separate from the project-description status. Description still requires the official Author Console; no unsupported write API is used.
