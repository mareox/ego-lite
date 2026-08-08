# ego-lite Workstation Setup Plan

**Status:** Active — installed state observed; execution blocked on trust/version reconciliation

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
| T3 | Revalidate upstream stable source and fork sync | todo | Stable tag/commit, fork divergence, app URL, and skill version are freshly recorded. |
| T4 | Verify the Apple Silicon installer and active runtime | blocked | Existing bundle's deep strict signature and active bridge version must reconcile with a trusted official artifact before use. |
| T5 | Install and onboard ego-lite on mbp4x | blocked | The app is present, but T4 blocks profile import and first live browser use; migration completion remains unobserved. |
| T6 | Record exact app, launcher, profile, and app-created skill paths | in_progress | App, launcher, active framework, vendor updater, and app-managed skill links are recorded; do not inspect or copy profile data. |
| T7 | Canonicalize the reviewed skill in `agent-config` | blocked | Do not vendor the current app-managed skill until T4 passes and its broad trigger is reviewed/pinned. |
| T8 | Prevent unsupported atlas exposure | todo | Platform-aware/exclusion design proves atlas will not advertise or link an unusable live skill. |
| T9 | Deploy and audit Codex/Claude skill links on mbp4x | blocked | Existing agent skill links resolve to app-managed paths, not the required canonical reviewed source. |
| T10 | Verify supported command and browser bridge | done | `ego-browser --version`, `ego.getBrowserVersion()`, and the documented heredoc smoke ran successfully; `--doctor` is unsupported on this build. |
| T11 | Run a real read-only Space task | todo | Example.com expected content is read in a named Space and the Space closes with `keep: false`. |
| T12 | Prove existing generic browser routing is unchanged | todo | A non-explicit browser request still selects the established browser lane. |
| T13 | Document rollback and final evidence | todo | App/skill/profile rollback targets and results are recorded; no unrelated files changed. |
| T14 | Prove the vendor app update lane | blocked | Existing vendor LaunchAgent and manual `ego-browser upgrade` must prove stable, non-interactive behavior after T4; post-update bridge/version checks pass. |
| T15 | Automate source/skill drift detection without auto-merging | todo | The checkout has an `upstream` remote, scheduled fetch detects tags/commits and skill diffs, and neither the fork branch nor `agent-config` changes without review. |

### Current blocker — installed app integrity and version state

`/Users/mareox/GIT/homelab-infra/plans/ego-lite-setup-checklist.md` records
MareoX's normal-profile migration choice; T2 therefore records the policy as
decided, while T5 still requires proof that import actually completed.

On 2026-08-07 the installed bundle identified as `0.4.6.12`, while its active
launcher and bridge used `0.4.5.9` and reported an update available. Gatekeeper
accepted the outer app and its signing identity, but `codesign --verify --deep
--strict` rejected the embedded framework as modified or invalid. The app also
installed broad, non-Git-backed skill links in `~/.agents/skills` and
`~/.claude/skills`. Do not run `upgrade`, import Chrome data, perform a browser
Space task, or adopt/replace those skills until T4 has a verifiable resolution.

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

- [ ] T0-T15 are `done`, with no remaining blocker.
- [ ] Installation executed only after `hostname`, `uname -s`, and `uname -m`
      confirmed mbp4x/Darwin/arm64.
- [ ] Installer integrity and Apple trust checks passed before app copy/launch.
- [ ] Gatekeeper quarantine was not stripped for the guarded pilot.
- [ ] Normal-profile migration is completed and its action-time confirmation is recorded.
- [ ] The reviewed skill is pinned and Git-backed through `agent-config`.
- [ ] Codex and Claude can invoke `$ego-browser` explicitly on mbp4x.
- [ ] Generic browser routing remains unchanged.
- [ ] The supported bridge-version query, bridge smoke, and real example.com Space task passed.
- [ ] The task Space closed with `keep: false` after proof.
- [ ] Atlas received no unsupported live app or enabled skill integration.
- [ ] The atlas exclusion and future Linux eligibility gate remain documented in
      `PRD.md`.
- [ ] Rollback targets are exact, verified, and exclude the source Chrome profile.
- [ ] Git diffs contain only intentional ego-lite project/agent-config paths.

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

## Source anchors

- [`../AGENTS.md`](../AGENTS.md) — repository architecture and test commands.
- [`../README.md`](../README.md) — upstream product overview and macOS quick start.
- [`../skills/ego-browser/references/install.md`](../skills/ego-browser/references/install.md) — macOS-only install, PATH, and smoke test.
- [`../skills/ego-browser/scripts/install.sh`](../skills/ego-browser/scripts/install.sh) — DMG, replacement, and quarantine behavior.
- [`../skills/ego-browser/SKILL.md`](../skills/ego-browser/SKILL.md) — task Spaces, inherited login state, and handoff contract.
- [`../package/ego-browser/package.json`](../package/ego-browser/package.json) — Node requirement and test scripts.

---

**Last updated:** 2026-08-07
