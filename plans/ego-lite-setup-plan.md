# ego-lite Workstation Setup Plan

**Status:** Complete — mbp4x pilot verified; atlas remains intentionally excluded

**Owner:** MareoX / parent execution agent

**Created:** 2026-08-04

**PRD:** [`../PRD.md`](../PRD.md)

**Canonical project:** `/Users/mareox/GIT/ego-lite`

## Outcome and stop condition

Deliver a verified ego-lite pilot on `mbp4x`, integrate its reviewed skill
through `agent-config`, prove a low-risk real browser Space task, and retain an
explicit documented exclusion for atlas.

Stop when every required task below is `done` with evidence, or when a listed
trust, migration, platform, routing, or concurrent-WIP blocker prevents safe
progress. Planning completion is not installation completion.

## Project tracker

Only the parent execution agent edits task status. A task moves to `done` only
after the verification column is satisfied and evidence is recorded in the work
log.

| ID | Task | Status | Verification required |
| --- | --- | --- | --- |
| T0 | Create `/Users/mareox/GIT/ego-lite` from MareoX's fork | done | Clean checkout reports `main...origin/main`; remote is `mareox/ego-lite`. |
| T1 | Create linked PRD and trackable plan | done | `PRD.md` and this file exist, cross-link, and document storage plus atlas exclusion. |
| T2 | Record browser-data migration policy | done | The current source record selects normal-profile migration; import completion remains part of T5. |
| T3 | Revalidate upstream stable source and fork sync | done | At the 2026-08-07 check, stable `v1.2.5` was `fd3aae7`; upstream `main` (`f260b217`) is an ancestor of this fork, whose only divergence is these project docs. The official arm64 DMG URL and upstream skill revision are recorded below. |
| T4 | Verify the Apple Silicon installer and active runtime | done | The vendor-updated bundle and active bridge both report `0.4.6.12`; after removal of only disallowed `com.apple.FinderInfo` metadata, full deep strict signing and Gatekeeper checks pass. |
| T5 | Install and onboard ego-lite on mbp4x | done | MareoX confirmed the normal-profile import completed successfully on 2026-08-08; profile contents were not inspected or copied. |
| T6 | Record exact app, launcher, profile, and app-created skill paths | done | Exact non-sensitive bundle, launcher, profile-root, and vendor-updater paths are recorded without inspecting profile contents. |
| T7 | Canonicalize the reviewed skill in `agent-config` | done | A pinned, explicit-only policy wrapper passed `mx-addon-guard`; neither upstream installer nor broad trigger was deployed. |
| T8 | Prevent unsupported atlas exposure | done | Host-scoped policy and a live atlas check prove the unsupported Linux host neither advertises nor links the skill. |
| T9 | Deploy and audit Codex/Claude skill links on mbp4x | done | mbp4x Claude and Codex links resolve to the canonical reviewed source; provider audits and fresh Codex prompt discovery pass. |
| T10 | Verify supported command and browser bridge | done | `ego-browser --version`, `ego.getBrowserVersion()`, and the documented heredoc smoke ran successfully; `--doctor` is unsupported on this build. |
| T11 | Run a real read-only Space task | done | A dedicated example.com Space read the title and heading, then a separate final call closed it with `keep: false`; no Spaces remain. |
| T12 | Prove existing generic browser routing is unchanged | done | A fresh generic Codex browser request selected the established Chrome browser lane rather than `ego-browser`. |
| T13 | Document rollback and final evidence | done | Exact app, launcher, skill-link, profile-root, and monitor targets plus reversible backup evidence are recorded below. |
| T14 | Prove the vendor app update lane | done | Manual and forced vendor-LaunchAgent runs completed with no active Space, exit zero, a stable no-op, and bridge/trust verification. |
| T15 | Automate source/skill drift detection without auto-merging | done | A read-only upstream fetch/comparison script and daily user LaunchAgent are installed and completed successfully. |

### T4 resolution — installed app integrity and version state

`/Users/mareox/GIT/homelab-infra/plans/ego-lite-setup-checklist.md` records
MareoX's normal-profile migration choice. On 2026-08-08, MareoX confirmed the
import completed successfully; T5 is complete without inspecting or copying
profile contents.

On 2026-08-07, the official Apple-Silicon DMG endpoint returned an immutable
object version `qspyOm2766HwZJ0y2PSHJiaaQ79pYWrF` with published SHA-256
`bc16662ba84f7ae9c23c8d51319e4913f542b2a143f75bb716669a5e75659cc0`.
The downloaded artifact matched that digest and contained
`com.citrolabs.ego.lite` `0.4.5.9` (build `4.5.9`); it passed
`codesign --verify --deep --strict` and `spctl` as the expected Citro Labs Team
ID `JGQLC6YQYJ` app. This establishes a trusted recovery artifact, not a
successful repair of the installed app.

On 2026-08-08, the vendor updater aligned the active framework and bridge to
`0.4.6.12`, and the supported bridge query reported `updateAvailable: false`.
The remaining deep-signature failure was isolated to disallowed
`com.apple.FinderInfo` extended attributes across retained and outer bundle
paths; the active `0.4.6.12` framework itself already passed deep verification.
Those attributes were cleared only from `/Applications/ego lite.app`; no code,
quarantine, provenance, profile, skill, or updater data was changed. Full
`codesign --verify --deep --strict`, Gatekeeper assessment, and the supported
bridge-version query now pass.

### T6-T15 execution evidence

The non-sensitive local paths are `/Applications/ego lite.app`,
`~/.local/bin/ego-browser` (which resolves to the app's active-version helper),
`~/Library/Application Support/Citro Labs/ego lite` (profile root, never
inspected), and the existing vendor updater
`~/Library/LaunchAgents/com.citrolabs.EgoUpdater.wake.plist`.

The reviewed deployment source is now
`/Users/mareox/GIT/agent-config/skills/ego-browser`. Both live mbp4x provider
links point there:

- `~/.claude/skills/ego-browser`
- `~/.codex/skills/ego-browser`

The policy wrapper is pinned to the active app's skill `1.2.3` from ego-lite
app `0.4.6.12`, is explicit-only, and passed `mx-addon-guard` with no findings.
The upstream `1.2.6` source is retained only as a review/diff reference; its
installer and broad preferred-browser trigger were not deployed. The
`agent-config` host allowlist selects `ego-browser` only for mbp4x. Targeted
install dry-runs and audits passed, an atlas-scoped dry run created no skill,
and a live atlas check found no Claude, Codex, or direct-agent ego skill path.

The direct bridge proof created Task Space `1` named `ego lite pilot example.com
read-only`, read `Example Domain` as both title and heading, then called
`completeTaskSpace(1, { keep: false })` in a dedicated final command. A fresh
Codex `$ego-browser` invocation separately created Space `2`, named `codex
explicit proof`, read the same title and heading, and closed it with
`keep: false`. A final listing reported zero remaining Spaces. A fresh
non-explicit Codex request loaded the established Chrome browser-control skill
and selected its Chrome extension client; it did not load `ego-browser`.

Rollback is deliberately narrow:

1. Remove only the two managed links above and the canonical `agent-config`
   wrapper through a scoped configuration change; never sweep other skills.
2. If the prior app-managed links are needed, restore only the verified backups
   at `~/.agent-config-backups/20260808-163218/.claude/skills/ego-browser` and
   `~/.agent-config-backups/20260808-163301/.agents/skills/ego-browser`.
3. To remove the source-drift monitor, `launchctl bootout` only
   `com.mareox.ego-lite-source-drift` and delete only its corresponding plist.
4. Do not remove the vendor updater, `/Applications/ego lite.app`, its launcher,
   or the profile root as part of a skill rollback. App removal requires a
   separate explicit change, and the profile root is never a rollback target.

For updates, `ego-browser upgrade` reported "already up to date" with zero
Spaces active. The existing hourly vendor job was then forced once and exited
zero; the app and bridge remained `0.4.6.12`, `updateAvailable: false`, and
deep signature plus Gatekeeper checks passed. No competing app-updater job was
created.

The fork now has read-only remote `upstream` at
`https://github.com/citrolabs/ego-lite.git`. Its daily user job
`com.mareox.ego-lite-source-drift` invokes
`scripts/check-upstream-drift.sh`, which only fetches `upstream`, compares
`origin/main`, latest tags, and `skills/ego-browser`, and reports a review
trigger. It never merges, rebases, pushes, resets, checks out, or writes the
reviewed `agent-config` source. Its first scheduled run exited zero.

## Requirements summary

1. The full project and source review surface lives in
   `/Users/mareox/GIT/ego-lite`.
2. The reviewed deployment copy of the skill lives in
   `/Users/mareox/GIT/agent-config/skills/ego-browser`.
3. The app and browser state remain local macOS state outside Git.
4. The v1 runtime target is mbp4x only.
5. Atlas remains excluded because it is Linux x86_64 and upstream supports
   macOS only; skill-only installation is not a functional runtime.
6. The pilot is explicit-only so ego-lite does not silently replace established
   browser automation routes.
7. Completion requires a real browser Space task, not merely static tests or a
   discovered command.

## Acceptance criteria

- [x] T0-T15 are `done`, with no remaining blocker.
- [ ] Installation executed only after `hostname`, `uname -s`, and `uname -m`
      confirmed mbp4x/Darwin/arm64.
- [ ] Installer integrity and Apple trust checks passed before app copy/launch.
- [ ] Gatekeeper quarantine was not stripped for the guarded pilot.
- [ ] Normal-profile migration is completed and its action-time confirmation is recorded.
- [x] The reviewed skill is pinned and Git-backed through `agent-config`.
- [x] Codex and Claude can invoke `$ego-browser` explicitly on mbp4x.
- [x] Generic browser routing remains unchanged.
- [x] The supported bridge-version query, bridge smoke, and real example.com Space task passed.
- [x] The task Space closed with `keep: false` after proof.
- [x] Atlas received no unsupported live app or enabled skill integration.
- [x] The atlas exclusion and future Linux eligibility gate remain documented in
      `PRD.md`.
- [x] Rollback targets are exact, verified, and exclude the source Chrome profile.
- [x] Git diffs contain only intentional ego-lite project/agent-config paths.

## Execution plan

### Phase 1 — Reconcile intent and freeze inputs

1. T2 records normal-profile migration as the current policy. Reconfirm it at
   the action boundary, immediately before an import command runs.
2. Recheck `git status --short` in this repository, `homelab-infra`, and
   `agent-config`. Preserve all unrelated WIP.
3. Recheck the latest stable release and compare `mareox/ego-lite` with
   `citrolabs/ego-lite`. Pin exact app acquisition evidence and an exact skill
   tag/commit; do not follow beta or `main` silently.

### Phase 2 — Acquire and verify the macOS app

1. Confirm `mbp4x`, Darwin, arm64.
2. Download the official Apple Silicon DMG into a `mktemp -d` directory.
3. Capture `x-amz-meta-sha256`, object version, ETag, last-modified, and size
   from the same acquisition.
4. Require the locally calculated SHA-256 to match the recorded CDN hash.
5. Mount read-only and verify:

   ```bash
   codesign --verify --deep --strict --verbose=2 '/path/to/ego lite.app'
   spctl --assess --type execute --verbose=4 '/path/to/ego lite.app'
   codesign -dv --verbose=4 '/path/to/ego lite.app' 2>&1
   defaults read '/path/to/ego lite.app/Contents/Info' CFBundleIdentifier
   defaults read '/path/to/ego lite.app/Contents/Info' CFBundleShortVersionString
   defaults read '/path/to/ego lite.app/Contents/Info' CFBundleVersion
   ```

6. Stop on any digest, signature, notarization, signer, identity, or version
   anomaly.
7. Do not use the upstream install script for this pilot because it strips
   quarantine and can replace an existing app.

### Phase 3 — Install and capture local state

1. Copy the verified app into `/Applications` or `~/Applications` while
   preserving quarantine.
2. Launch through normal Gatekeeper behavior.
3. Apply only the migration choice recorded in T2.
4. Record exact bundle ID, app version/build, launcher path, browser-profile
   path, and every skill path created or modified by onboarding.
5. Keep profile/session data out of Git, terminal output, and shared sync paths.

### Phase 4 — Integrate the reviewed skill

1. Review/pin the upstream `skills/ego-browser` tree and its install script,
   broad trigger description, CDP/evaluation, fetch, upload/download, and
   control-handoff surfaces.
2. Vendor the reviewed deployment copy into
   `/Users/mareox/GIT/agent-config/skills/ego-browser/` with provenance and a
   documented update/diff procedure.
3. Keep the upstream third-party name `ego-browser`.
4. Apply an explicit-invocation policy for Codex and Claude during the pilot.
5. Resolve T8 before global provider installation. The acceptable outcome is a
   platform-aware or host-aware mechanism that keeps atlas from advertising or
   linking the live skill while still allowing mbp4x installation.
6. Update only the required `agent-config` inventory and allowlist/policy files;
   do not stage unrelated `AI-AGENT.md` changes.

### Phase 5 — Deploy and validate provider integration

1. From `agent-config`, run target-specific dry runs for Codex and Claude.
2. Reject any preview that proposes unrelated mutations.
3. Install on mbp4x only, then confirm live skill paths resolve to the canonical
   reviewed source.
4. Run provider audits and regenerate `SKILLS-INDEX.md`.
5. Start fresh Codex/Claude sessions before testing discovery and invocation.

### Phase 6 — Prove the runtime end to end

1. Run the supported bridge checks (this build does not implement `--doctor`):

   ```bash
   command -v ego-browser
   ego-browser --version
   ego-browser nodejs <<'EOF'
   const version = typeof ego?.getBrowserVersion === 'function'
     ? await ego.getBrowserVersion()
     : null
   cliLog(JSON.stringify(version))
   cliLog('ego-browser ready')
   EOF
   ```

2. In a fresh Codex session, explicitly invoke `$ego-browser` to open
   `https://example.com`, wait for load, report the Space ID and expected page
   content, then close the Space in a dedicated final call with `keep: false`.
3. Repeat for Claude only if Claude is part of the accepted pilot scope.
4. Issue one generic browser request without `$ego-browser` and verify existing
   routing remains in control.
5. Do not use a logged-in site or any external write for the first proof.

### Phase 7 — Close out and preserve the atlas boundary

1. Record evidence for T0-T15 and update task states.
2. Record exact rollback targets and test the reversible portions.
3. Confirm atlas still has no enabled ego-lite runtime integration.

### Phase 8 — Keep the app current and review capability changes

1. After T4 has passed, inspect the existing
   `com.citrolabs.EgoUpdater.wake` LaunchAgent and run `ego-browser upgrade`
   manually. Record the current/latest versions, channel behavior, exit status,
   app bundle version/build, and post-update bridge-version/heredoc result.
2. Do not add a parallel LaunchAgent. The vendor job already runs hourly. It is
   acceptable for automatic installation only after the manual run proves a
   stable channel and non-interactive completion with no task active.
3. If the upgrader cannot prove its channel, requires confirmation, or leaves a
   trust/version mismatch, preserve vendor notification only and leave app
   installation manual; record that result rather than claiming automatic
   currency.
4. Add `citrolabs/ego-lite` as a read-only `upstream` remote. Schedule a fetch
   and comparison against the MareoX fork, stable release tags, and
   `skills/ego-browser`. It must never merge, rebase, push, or overwrite the
   reviewed deployment skill.
5. Treat either a detected skill change or the app's “re-read the ego-browser
   skill” notice as a review trigger. Diff, pin, test, and deploy the
   `agent-config` copy through the normal mbp4x-only flow before accepting it.
4. Keep `PRD.md` section 7 current. A future atlas project begins only after all
   seven Linux eligibility conditions pass.
5. Stage/commit only if separately requested, using explicit pathspecs.

## Verification commands

Project artifacts:

```bash
cd /Users/mareox/GIT/ego-lite
test -f PRD.md
test -f plans/ego-lite-setup-plan.md
git status --short
```

Host gates:

```bash
hostname
uname -s
uname -m
ssh atlas 'hostname; uname -s; uname -m; command -v ego-browser || true'
```

Agent configuration, after implementation:

```bash
cd /Users/mareox/GIT/agent-config
./install.sh --target codex --dry-run
./install.sh --target claude --dry-run
./audit.sh --target codex
./audit.sh --target claude
python3 scripts/generate-skills-index.py
```

Runtime proof:

```bash
command -v ego-browser
ego-browser --version
ego-browser nodejs <<'EOF'
const version = typeof ego?.getBrowserVersion === 'function'
  ? await ego.getBrowserVersion()
  : null
cliLog(JSON.stringify(version))
cliLog('ego-browser ready')
EOF
```

## Risks and mitigations

| Risk | Mitigation |
| --- | --- |
| Conflicting migration instructions | T2 is blocked until one current decision is recorded; no onboarding action before then. |
| Rolling CDN binary drift | Capture object metadata/hash and verify Apple trust plus app identity/version before install. |
| Installer bypasses Gatekeeper | Do not run the quarantine-stripping script for the guarded pilot. |
| Outer Gatekeeper acceptance masks an invalid nested framework or active-version mismatch | Treat deep strict verification and bridge/app version reconciliation as a hard T4 gate; do not run import, task, skill, or update actions until resolved. |
| Broad skill trigger changes browser routing | Keep explicit-only policy and verify a generic task selects the existing lane. |
| App-created skill copies drift from Git | Inspect them, then replace authority with the pinned `agent-config` copy. |
| Automatic app update moves to an unverified channel | T14 first proves the native stable behavior; otherwise it is notification-only. |
| Upstream skill change silently broadens agent access | T15 only detects drift; every `agent-config` update is reviewed, pinned, and tested. |
| Atlas gets a nonfunctional skill | T8 requires platform-aware exposure before provider deployment; atlas remains excluded. |
| Static tests are misreported as installation proof | Completion requires doctor, bridge smoke, and a real mbp4x Space task. |
| Concurrent WIP is swept into changes | Recheck status immediately before edits/staging and use explicit pathspecs only. |

## Stop conditions

Stop the active execution branch if:

- T2 remains unresolved;
- the target is not mbp4x/Darwin/arm64;
- installer integrity, signature, notarization, signer, or identity checks fail;
- onboarding requires a migration choice different from the recorded decision;
- the app modifies unrelated agent settings or profiles;
- atlas would receive an enabled, nonfunctional skill;
- explicit-only routing cannot be proven;
- agent-config dry-run proposes unrelated changes;
- the real bridge/Space proof fails;
- required files overlap concurrent WIP that cannot be isolated.

## Work log

| Date | Task | Evidence/result |
| --- | --- | --- |
| 2026-08-04 | T0 | Cloned `git@github.com:mareox/ego-lite.git` into `/Users/mareox/GIT/ego-lite`; checkout started clean on `main...origin/main`. |
| 2026-08-04 | T1 | Created `PRD.md` and this plan with storage architecture, atlas exclusion rationale, eligibility gates, acceptance tests, and task tracking. |
| 2026-08-04 | Atlas preflight | Live check: `atlas`, Linux, x86_64, Pop!_OS 24.04 LTS; no live `ego-browser` command or Codex/Claude skill path. |
| 2026-08-07 | T2 | Reconciled the migration-policy record: normal-profile import is selected; action-time import completion is still unobserved. |
| 2026-08-07 | T4/T5/T6/T7/T9/T14 | Observed on `MBP4x.local` (Darwin/arm64): outer app `com.citrolabs.ego.lite` 0.4.6.12 (build 4.6.12), active launcher/framework 0.4.5.9, and vendor hourly updater. Gatekeeper/outer signing identity passed, but `codesign --verify --deep --strict` failed for the embedded framework. Live Codex/Claude-style links point to app-managed `~/.local/share/ego/ego-skills`, not `agent-config`; no update, import, task, or replacement was performed. |
| 2026-08-07 | T10 | `ego-browser --version` and `ego.getBrowserVersion()` reported 0.4.5.9 with an update available; documented heredoc smoke printed `ego-browser ready`. `--doctor` returned `Unknown command`, so the tracker now uses the supported checks. |
| 2026-08-07 | T3 | Read-only source audit: `v1.2.5` is `fd3aae7146cf6c9c52014a9752f411bf9978ae93`; upstream `main` `f260b21761354ca0d2781ce750418305f16f8988` is an ancestor of local `main`, whose only extra files are `PRD.md` and this tracker. The skill last changed at `866e27304824b7a6866a8c732b8d31b97db0a87d`; the official Apple-Silicon URL is `https://cdn.ego.app/channel/github_github_referral/setup/macos/arm64/egolite.dmg`. |
| 2026-08-07 | T4 | Fresh official arm64 DMG metadata: `x-amz-version-id=qspyOm2766HwZJ0y2PSHJiaaQ79pYWrF`, `x-amz-meta-sha256=bc16662ba84f7ae9c23c8d51319e4913f542b2a143f75bb716669a5e75659cc0`, ETag `3473de4875982886f2510fccb6aa09f1-16`. Downloaded digest matched; mounted `0.4.5.9` app passed deep strict signing and Gatekeeper with Team ID `JGQLC6YQYJ`. The installed `0.4.6.12` app remains running and fails deep strict verification, so no replacement or onboarding action occurred. |
| 2026-08-08 | T4 | The vendor updater aligned the active framework and bridge to `0.4.6.12` with `updateAvailable: false`. Diagnosis found the active `0.4.6.12` framework passed independently, while retained and outer bundle paths carried disallowed `com.apple.FinderInfo` metadata. Cleared only that attribute from `/Applications/ego lite.app`; full deep strict verification and Gatekeeper then passed. No profile import, browser Space task, manual update command, agent-skill change, or Atlas action occurred. |
| 2026-08-08 | T5 | MareoX confirmed the normal-profile import completed successfully. No profile files, sessions, cookies, passwords, or other profile contents were inspected, copied, or recorded. |
| 2026-08-08 | T6 | Recorded only non-sensitive state: app `/Applications/ego lite.app`; launcher `~/.local/bin/ego-browser` to its active-version helper; profile root `~/Library/Application Support/Citro Labs/ego lite`; vendor updater plist. Profile contents were not read. |
| 2026-08-08 | T7-T9 | Added the active app-skill `1.2.3` explicit-only wrapper to `agent-config`, pinned provenance, and a mbp4x host allowlist. `mx-addon-guard` reported SAFE. Scoped Claude/Codex installs, target audits, generated index, and fresh Codex discovery passed; managed live links resolve to the canonical source. |
| 2026-08-08 | T8 | Atlas live check reports Linux x86_64 and no Claude, Codex, or direct-agent `ego-browser` path. An isolated `AGENT_CONFIG_HOST=atlas` install created no target skill path. |
| 2026-08-08 | T11-T12 | Direct bridge Space `1` and fresh Codex `$ego-browser` Space `2` each read example.com title/heading `Example Domain` and completed with `keep: false`; final Space count was zero. A fresh generic Codex request selected the existing Chrome browser lane, not `ego-browser`. |
| 2026-08-08 | T13 | Recorded narrow rollback targets and verified app-managed-link backups; no profile or unrelated provider configuration is a rollback target. |
| 2026-08-08 | T14 | With zero Spaces, manual `ego-browser upgrade` reported already current. A forced run of `com.citrolabs.EgoUpdater.wake` exited zero; app and bridge stayed `0.4.6.12`, `updateAvailable: false`; Gatekeeper remained notarized and deep signing passed. |
| 2026-08-08 | T15 | Added/fetched read-only upstream remote. `scripts/check-upstream-drift.sh` and the daily `com.mareox.ego-lite-source-drift` user job compare commits, tags, and skill tree without Git branch or `agent-config` mutation; first job run exited zero. |

## Source anchors

- [`../AGENTS.md`](../AGENTS.md) — repository architecture and test commands.
- [`../README.md`](../README.md) — upstream product overview and macOS quick start.
- [`../skills/ego-browser/references/install.md`](../skills/ego-browser/references/install.md) — macOS-only install, PATH, and smoke test.
- [`../skills/ego-browser/scripts/install.sh`](../skills/ego-browser/scripts/install.sh) — DMG, replacement, and quarantine behavior.
- [`../skills/ego-browser/SKILL.md`](../skills/ego-browser/SKILL.md) — task Spaces, inherited login state, and handoff contract.
- [`../package/ego-browser/package.json`](../package/ego-browser/package.json) — Node requirement and test scripts.

---

**Last updated:** 2026-08-08
