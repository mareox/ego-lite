# ego-lite Workstation Integration PRD

**Status:** Complete — verified mbp4x pilot; atlas remains intentionally excluded

**Owner:** MareoX

**Date:** 2026-08-04

**Execution tracker:** [`plans/ego-lite-setup-plan.md`](plans/ego-lite-setup-plan.md)

## 1. Product intent

Integrate ego-lite into MareoX's AI-agent workstation environment so Codex and
Claude can explicitly drive a local browser in isolated task Spaces without
taking over the user's normal tabs.

The first release is a guarded `mbp4x` pilot. It must preserve the Git-backed
`agent-config` source of truth, existing browser-tool routing, macOS trust
validation, and a deliberate boundary around importing Chrome logins, cookies,
extensions, and bookmarks.

This is a workstation integration, not a homelab service. It requires no LXC,
VM, DNS, Caddy, Semaphore, service-registry, or `INFRASTRUCTURE.md` entry.

## 2. Proposed release shape

| Item | Proposed value |
| --- | --- |
| Project checkout | `/Users/mareox/GIT/ego-lite` from `mareox/ego-lite` |
| Upstream | `citrolabs/ego-lite` |
| Supported pilot host | `mbp4x` — macOS 26.5.2, Apple Silicon/arm64 |
| Explicitly excluded host | `atlas` — Pop!_OS 24.04 LTS, Linux x86_64 |
| Application | `/Applications/ego lite.app` or `~/Applications/ego lite.app` |
| CLI launcher | Normally `~/.local/bin/ego-browser` |
| Canonical skill | `/Users/mareox/GIT/agent-config/skills/ego-browser/` |
| Invocation policy | Explicit `$ego-browser` during the pilot |
| Browser profile | Local macOS Application Support path; never committed or synced |
| Plan/tracker | `plans/ego-lite-setup-plan.md` in this repository |

The project checkout is the source/research and upstream-diff surface. The
reviewed skill copy in `agent-config` is the deployment source for agent homes.
The closed-source app and browser profile remain local workstation state.

## 3. Personas and responsibilities

| Persona/system | Responsibility | Boundary |
| --- | --- | --- |
| MareoX | Approves profile migration and accepts the pilot. | Chrome/session migration is never inferred from installation consent. |
| Execution agent | Verifies, installs, integrates, tests, documents, and rolls back within the approved plan. | Stops at trust, migration, unsupported-platform, or concurrent-WIP gates. |
| `agent-config` | Git source of truth for the reviewed `ego-browser` skill and provider exposure. | App-created or `npx`-created live skill copies are not authoritative. |
| ego-lite app | Provides the local Chromium-derived runtime and `ego-browser` bridge. | The downloadable app is separate from this repository's MIT-licensed helper source. |
| `mbp4x` | Runs the supported macOS application and full end-to-end pilot. | No assumption that the result transfers to Linux. |
| `atlas` | Remains excluded from live installation until the Linux eligibility gate passes. | May run source/static tests, but not claim browser-runtime validation. |

## 4. Functional requirements

| ID | Requirement | Acceptance outcome |
| --- | --- | --- |
| FR-01 | Install only on an upstream-supported operating system and architecture. | Preflight confirms `mbp4x`, Darwin, arm64 before any app mutation. |
| FR-02 | Verify the downloaded application before installation or use. | CDN metadata hash, local SHA-256, outer signature, deep strict signature verification, notarization assessment, Team ID, bundle ID, and active bridge/app versions are recorded and pass or have a vendor-verified explanation. |
| FR-03 | Preserve normal Gatekeeper behavior. | The app is installed and first-launched without stripping `com.apple.quarantine`. |
| FR-04 | Keep agent skill state Git-backed. | Live Codex/Claude skill paths resolve to the reviewed `agent-config/skills/ego-browser` source. |
| FR-05 | Avoid silently replacing established browser routing. | `$ego-browser` works explicitly; a generic browser task still uses the existing capability-selection policy. |
| FR-06 | Prove the local browser bridge, not just command discovery. | The installed build's supported version query and documented heredoc smoke succeed, followed by a real read-only Space task. |
| FR-07 | Make browser-data migration deliberate. | The execution tracker records the user-approved migration decision before onboarding crosses that gate. |
| FR-08 | Provide a recoverable uninstall path. | Exact app, launcher, skill-link, and profile paths are recorded; rollback removes only verified ego-lite targets. |
| FR-09 | Keep atlas free of nonfunctional live integration. | No ego-lite app or enabled live skill is installed on atlas while upstream remains macOS-only. |
| FR-10 | Define when atlas may be reconsidered. | Every Linux eligibility condition in section 7 is proven before an atlas rollout plan is created. |
| FR-11 | Keep the supported mbp4x app current without silently changing its agent capability. | The vendor updater is integrity- and channel-validated before it is trusted to apply updates; upstream source and `ego-browser` skill updates are detected automatically but remain review-gated. |

## 5. Non-functional requirements

### Security and privacy

- The first browser task is read-only against `https://example.com`; it performs
  no login, form submission, upload, download, or external write.
- Chrome migration is a separate approval gate because upstream says it can
  import logins, cookies, extensions, and bookmarks.
- Upstream's claim that browsing data stays local is treated as a vendor claim,
  not proof about all network behavior of the closed app binary.
- The guarded pilot does not use upstream's install script because that script
  removes quarantine and may replace an existing application.
- No browser profile, cookie store, download, screenshot, or generated browser
  artifact enters Git or Syncthing.

### Portability and configuration

- Third-party skill naming remains `ego-browser`; it is not renamed into the
  first-party `mx-` namespace.
- The reviewed skill records upstream repo, stable tag or exact commit, digest,
  import date, local policy overlays, and an update/diff procedure.
- Provider exposure must account for host support. A global allowlist entry that
  makes atlas advertise an unusable skill is not an acceptable final design.
- Existing unrelated changes in `homelab-infra` and `agent-config` are never
  staged or rewritten by this project.

### Reliability and operations

- A command path alone is insufficient; bridge and real Space behavior must be
  proven.
- The execution tracker is the single task-state artifact. Tasks move to `done`
  only after their verification evidence is recorded.
- App and skill versions are tracked independently because the app download is a
  rolling CDN object while the helper skill is versioned in GitHub releases.

### Version-update policy

The cloned repository is **not** the installed browser and `git pull` must not
be treated as an application update. It has three separate, intentional update
lanes:

| Component | Automated action | Apply policy |
| --- | --- | --- |
| ego-lite macOS app on mbp4x | First inspect and validate the vendor-managed `com.citrolabs.EgoUpdater.wake` LaunchAgent and the native `ego-browser upgrade` path. | Do not add a parallel updater or invoke an update while the bundle's trust/version state is unresolved. Automatic application is permitted only after a manual, non-interactive stable-channel update proves integrity and a post-update bridge version query. |
| `mareox/ego-lite` checkout | A scheduled fetch compares the MareoX fork to `citrolabs/ego-lite` tags/commits. | Never fast-forward, merge, or push automatically; it supplies a local, current diff for review. |
| Reviewed `ego-browser` skill in `agent-config` | The same release check flags a changed upstream skill or an app notice that requires the skill to be re-read. | Never overwrite automatically: review the diff and security-sensitive capability changes, then make an explicit, pinned `agent-config` update. |

The installed build already registers a vendor user LaunchAgent with a 3600-second
interval. It was manually invoked and forced through that existing job with zero
active Spaces; both paths completed non-interactively, exited zero, and retained
the stable `0.4.6.12` app/bridge state. No competing app scheduler was added.
The separate daily source-drift job is detection-only: it fetches the explicit
`upstream` remote, reports branch/tag/skill differences, and leaves every update
to a reviewed, pinned, mbp4x-only `agent-config` deployment. Never invoke the
quarantine-stripping upstream installer, change Chrome migration data, or run an
updater on atlas.

## 6. Storage architecture

```text
/Users/mareox/GIT/ego-lite/                 # MareoX fork checkout
├── PRD.md                                  # product requirements and scope
├── plans/ego-lite-setup-plan.md            # execution state and evidence
└── upstream source + skills/ego-browser/   # review/diff surface

/Users/mareox/GIT/agent-config/
└── skills/ego-browser/                     # reviewed deployment copy
    └── provenance + explicit-invocation policy

/Applications/ego lite.app                  # local app, not Git
~/.local/bin/ego-browser                     # app-registered launcher
~/Library/Application Support/<bundle-id>/  # local browser state, exact path discovered at install
```

The full checkout is not the live agent skill directory. `agent-config` remains
the cross-agent source of truth, while this fork remains the place to inspect
upstream changes and, if desired, maintain MareoX-specific patches.

### Observed installed state — pilot complete

On 2026-08-07, live inspection on `MBP4x.local` found the following:

- `/Applications/ego lite.app` identifies as `com.citrolabs.ego.lite`, version
  `0.4.6.12` (build `4.6.12`), and is accepted by `spctl` as a notarized
  Developer ID application from Team ID `JGQLC6YQYJ`.
- The active `ego-browser` launcher resolves through
  `~/.local/share/ego/active_version_dir` to framework version `0.4.6.12`.
  Its supported bridge query reports `currentVersion: 0.4.6.12` and
  `updateAvailable: false`.
- `ego-browser --doctor` is not a supported command on this build. The
  documented heredoc smoke does work.
- A fresh download from the official Apple-Silicon DMG endpoint on 2026-08-07
  matched the CDN-provided SHA-256
  `bc16662ba84f7ae9c23c8d51319e4913f542b2a143f75bb716669a5e75659cc0` and
  contained `0.4.5.9` (build `4.5.9`). It passed deep strict verification and
  Gatekeeper as Citro Labs Team ID `JGQLC6YQYJ`. This is a trusted recovery
  artifact for a prior trust investigation.
- On 2026-08-08, the vendor updater aligned the active framework and bridge to
  `0.4.6.12`, with `updateAvailable: false`. Diagnosis found the active
  framework passed independently and the full-bundle failure came from
  disallowed `com.apple.FinderInfo` extended attributes on retained and outer
  bundle paths. Removing only that attribute from `/Applications/ego lite.app`
  made `codesign --verify --deep --strict` and Gatekeeper assessment pass;
  application code, quarantine, provenance, profiles, skills, and updater data
  were not changed.
- MareoX confirmed normal-profile import completed on 2026-08-08. Profile
  contents, sessions, cookies, passwords, and other data were not inspected,
  copied, or recorded.
- The app-managed broad skill was replaced only at the provider-link boundary:
  `~/.claude/skills/ego-browser` and `~/.codex/skills/ego-browser` now resolve
  to the reviewed, Git-backed, explicit-only
  `/Users/mareox/GIT/agent-config/skills/ego-browser` wrapper. No unmanaged
  direct-agent duplicate controls discovery.
- A dedicated read-only Task Space opened `https://example.com`, read
  `Example Domain`, and closed with `keep: false`. A fresh Codex
  `$ego-browser` invocation repeated that proof in its own Space and also
  closed it with `keep: false`; a final listing found no remaining Spaces. A
  generic Codex browser request selected the established Chrome browser lane
  rather than `ego-browser`.
- The manual updater reported the app current, and a forced execution of the
  existing hourly vendor LaunchAgent exited zero with the same stable bridge
  version. No competing app-updater job was added.
- The checkout has a read-only `upstream` remote plus a daily
  `com.mareox.ego-lite-source-drift` job. It fetches and compares commits, tags,
  and `skills/ego-browser` without merging, rebasing, pushing, or modifying the
  deployed `agent-config` wrapper.

## 7. Atlas exclusion and future eligibility gate

### Current evidence

Live verification on 2026-08-04 showed:

- hostname: `atlas`;
- operating system: Pop!_OS 24.04 LTS;
- kernel platform: Linux;
- architecture: x86_64;
- no `ego-browser` command;
- no `~/.codex/skills/ego-browser` or `~/.claude/skills/ego-browser`.

Upstream currently states that ego-lite runs on macOS and that Windows/Linux are
roadmap items. Its install reference and installer are macOS-only. The
`ego-browser` skill also depends on the local ego-lite browser app for the
runtime/bridge; copying the skill alone to atlas would not produce working
Spaces.

Therefore atlas is intentionally excluded. This is a compatibility decision,
not an incomplete rollout.

### Eligibility conditions for a future atlas rollout

All conditions are mandatory:

1. Upstream publishes official Linux support rather than roadmap intent.
2. A Linux x86_64 artifact or supported package is available from an official
   distribution channel with integrity/provenance evidence.
3. The Linux application provides the same local `ego-browser` bridge, Space
   ownership model, and documented onboarding behavior.
4. `agent-config` has a platform-aware exposure mechanism so unsupported hosts
   do not advertise or link the skill.
5. The Linux app passes a host-appropriate package/signature verification gate.
6. On atlas, the installed build's supported bridge version query, heredoc
   smoke, and a real read-only Space task all pass.
7. Atlas-specific profile storage, update, rollback, and removal paths are
   documented and tested.

Until all seven conditions pass, atlas may run repository builds, unit tests,
and static/security review only. Those checks must never be reported as a
successful ego-lite installation.

## 8. Scope

### In scope for v1

- Clone and maintain the MareoX fork under `~/GIT/ego-lite`.
- Verify and install the Apple Silicon app on `mbp4x`.
- Integrate a reviewed, pinned, explicit-only skill through `agent-config`.
- Validate Codex and, if selected, Claude with low-risk real browser tasks.
- Record app/skill provenance, platform scope, rollback, and verification.

### Out of scope for v1

- Installing or enabling ego-lite on atlas.
- Inventing an undocumented remote bridge from atlas to mbp4x.
- Treating the open-source Node helper as a replacement for the closed app.
- Homelab DNS, proxy, service registry, monitoring, backups, or scheduling.
- Automatic Chrome-data migration without a current explicit decision.
- Beta release adoption during the initial pilot.

## 9. Delivery phases

1. **Project foundation:** create this checkout, PRD, and execution tracker.
2. **Trust preflight:** reconcile migration intent, pin the stable source, and
   verify the macOS installer.
3. **mbp4x pilot:** install, onboard, and capture exact local state paths.
4. **Managed integration:** vendor and expose the reviewed skill without
   changing global browser routing or atlas behavior.
5. **Runtime proof:** run the supported bridge query and heredoc smoke, then a
   real read-only Space task.
6. **Managed updates:** prove the native app updater while retaining its
   existing vendor LaunchAgent, and automate source/skill drift detection.
7. **Closeout:** record evidence, rollback, remaining gaps, and the continuing
   atlas exclusion.

## 10. Acceptance tests

| ID | Test | Pass criteria |
| --- | --- | --- |
| AT-01 | Project artifacts | `PRD.md` and `plans/ego-lite-setup-plan.md` exist in `/Users/mareox/GIT/ego-lite` and link to each other. |
| AT-02 | Host gate | Execution on mbp4x reports Darwin/arm64; atlas reports Linux/x86_64 and is skipped. |
| AT-03 | Installer trust | Hash, outer and deep strict signatures, notarization, Team ID, bundle ID, and active bridge/app versions all pass or have a vendor-verified explanation. |
| AT-04 | Managed skill | Live skill paths resolve to the reviewed source; no unmanaged duplicate controls invocation. |
| AT-05 | Routing | Explicit `$ego-browser` resolves; a generic browser request does not automatically switch to it during the pilot. |
| AT-06 | Bridge | The build's supported version query and hello-world heredoc exit zero. |
| AT-07 | Real browser | Example.com opens in a dedicated Space, expected content is read, and the Space closes with `keep: false`. |
| AT-08 | Atlas exclusion | Atlas has no enabled runtime integration and the tracker records why. |
| AT-09 | Rollback | Exact ego-lite targets can be removed without touching Chrome source data or unrelated agent configuration. |
| AT-10 | WIP isolation | Git diffs contain only this project's intentional paths; concurrent files remain untouched. |
| AT-11 | App update | A manual native upgrade and a forced vendor-scheduled run preserve the stable-channel policy, record a version transition or no-op, and finish with bridge-version and heredoc checks. |
| AT-12 | Source and skill drift | A scheduled fetch detects an upstream change without moving the fork branch or modifying the reviewed `agent-config` skill. |

## 11. Risks and go/no-go rules

| Risk | Go/no-go rule |
| --- | --- |
| Closed app binary cannot be trusted | No-go unless integrity, signature, notarization, identity, and version checks pass. |
| Migration intent conflicts across active plans | No-go at onboarding until MareoX's current choice is unambiguous and recorded in the tracker. |
| Global skill exposure leaks to atlas | No-go until exposure is host/platform-aware or otherwise proven absent on atlas. |
| Existing browser routing changes unexpectedly | No-go until explicit-only invocation is proven. |
| The app's outer signature passes but its deep strict signature or active version does not | No-go for import, browser tasks, skill adoption, or automatic updates until the vendor provides a verifiable recovery path and all required trust checks pass. |
| Automated update changes an unverified channel or agent capability | No-go for unattended installation until the native updater's stable behavior is proven; source and skill changes remain review-gated. |
| Static tests are mistaken for runtime proof | No-go for completion unless the real mbp4x browser Space test passes. |
| Concurrent WIP overlaps required agent-config files | Pause that path and isolate the change; never sweep or overwrite the other work. |

## 12. Decision record: why ego-lite is not on atlas

**Decision:** v1 installs and validates ego-lite on mbp4x only. Atlas remains
excluded from live installation and skill exposure.

**Drivers:** upstream platform support, dependency on a local app runtime,
honest end-to-end verification, and avoidance of unusable cross-host config.

**Rejected alternative:** copy only the `ego-browser` skill to atlas. This
provides instructions and Node helper source but no supported ego-lite browser
runtime, onboarding, or Space bridge; it would create apparent capability that
cannot pass the acceptance tests.

**Revisit trigger:** all seven Linux eligibility conditions in section 7 pass.

## 13. Sources

- Upstream macOS-only quick start and Chrome migration behavior:
  https://github.com/citrolabs/ego-lite/blob/main/README.md#quick-start
- Upstream macOS-only installer, PATH registration, and smoke test:
  https://github.com/citrolabs/ego-lite/blob/main/skills/ego-browser/references/install.md
- Upstream install script behavior:
  https://github.com/citrolabs/ego-lite/blob/main/skills/ego-browser/scripts/install.sh
- Upstream task Space and control-handoff contract:
  https://github.com/citrolabs/ego-lite/blob/main/skills/ego-browser/SKILL.md#task-spaces
- Stable releases:
  https://github.com/citrolabs/ego-lite/releases

---

**Last updated:** 2026-08-08
