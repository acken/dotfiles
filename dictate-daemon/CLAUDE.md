# PeerColab — assistant rules for dictate-daemon

## Mode
Assistant-rules + domain layer. **No codegen** in this repo: no generated
PathItems, no `@peercolab/engine`. The daemon is a single-process Python
script with a FIFO command surface — codegen earns its keep above that
size. If that calculus changes (e.g. extracting a real service), revisit
this decision rather than accreting wrappers.

## System / library
- System: `Workstation` (`b1e3fde8-c533-4753-8cac-b0378a1a86df`)
- Library: `Dictate_Deamon` (`c46f18db-3079-4114-b8fd-330e7b690ff5`)
- Local mapped path: `/home/ack/src/dotfiles/dictate-daemon`
- Export location: `/home/ack/src/dotfiles/dictate-daemon/peercolab`,
  language `Python`. **This is required even in assistant-rules mode** —
  the CLI gates operation discovery (`peercolab cli --system <id>`) on
  cwd overlapping a library's mapped path. Setting the path is inert
  local config; the destructive action is `RunPathItemsPrint`, which is
  what actually triggers the "delete `<path>/<SystemName>/` and rewrite"
  flow. Do **not** run `RunPathItemsPrint` here unless mode is escalated
  to contracts/full.

## Discovery before edits
Before non-trivial edits, run:
- `peercolab cli --system b1e3fde8-c533-4753-8cac-b0378a1a86df`
- `peercolab cli run CLI.Systems.GetLibraryOverview --system <id> --input '{"libraryId":"c46f18db-3079-4114-b8fd-330e7b690ff5"}'`
- `DescribeDomainLayer` on the layer covering the area you're touching.

If the system is not visible to the CLI, ask the user to open Workstation
in PeerColab Builder and enable CLI access, then rerun. Do not guess.

## Planning location
Feature specs and TODOs live in PeerColab `Features & TODOs` under the
`Dictate_Deamon` library. Local files (`initial-development.log`) are
historical notes only — do not add new TODOs there. If write access to
Workstation is missing, capture the intended TODO in the chat and flag
it as a follow-up; do not silently fall back to local files.

## Domain-level specifications
The mental model lives in domain layers on `Dictate_Deamon`. The tree
runs **product framing → install/use → architecture** (PM and end user
enter at the top; AI maintainer drills to the bottom):

- `Whisper dictation` (`1ed367b4-e284-49b6-abf4-fbea2779294e`) — root.
  What it is, why it exists, two modes at a glance.
  - `Install` (`1c3d3b7c-fee6-47ac-9d44-f78da6327cfa`) — prerequisites
    (NVIDIA + CUDA, X11), what `./setup` does, hotkey binding, lifecycle.
  - `Use` (`3eb8a4af-d6f5-45ba-8e9b-b46fdbfa813f`) — modes table, batch /
    stream workflow, debugging commands, tuning.
  - `Dictation flow` (`5389529c-f06b-45b0-9091-880db5c38756`) — daemon
    architecture: hotkey → FIFO shim → dispatch → mode handlers.
    - `Audio pipeline` (`41710153-f84a-4c41-b303-05c7c16e3c11`) — `arecord`
      capture, S16LE 16 kHz mono, buffer windowing, 30 s force-reset.
    - `Stream commit` (`7f6cf2a1-a78b-414c-ac67-8db96965d44b`) —
      LocalAgreement-2, committed-prefix accounting, final flush on stop.
    - `Typing surface` (`6b827075-36e5-44c7-9b96-d5a9c508c114`) —
      `xdotool type --clearmodifiers`, Meta+L lock-screen invariant, X11-only.

**Read** with `GetDocumentationContext` before editing the matching
code. **Drill** with `DescribeDomainLayer`. If layer text and code
diverge, surface the divergence in the same edit — usually the code is
grouped differently from the mental model.

**Style.** Layer descriptions use markdown structure (headers, lists,
tables) — not paragraph prose. They serve a PM/end-user audience at the
top and an AI-maintainer audience at the leaves; both navigate by
scanning, so structure matters.

**Contract rule.** Descriptions are part of the contract, not
decoration. When the contract meaning, shape, behaviour, or intended
usage shifts, update the layer description in the same edit. Run
`GetMutationDocContext` before/after operation/event-bundle mutations
(it doesn't currently resolve `entityType=DomainLayer`, so for
layer-only edits this step is moot until the resolver covers them).

## Mutations and doc review
If the mode is ever escalated and a mutation is performed, run
`CLI.Systems.GetMutationDocContext` before AND after the mutation, and
update any usage-package / domain-layer descriptions whose meaning shifts
in the same edit.

## Tests
Pragmatic. Write tests where they pay off:
- LocalAgreement-2 prefix logic (`common_word_prefix`, `_commit`).
- Buffer-window force-commit and committed-prefix accounting.
Skip tests for thin wiring (FIFO read loop, systemd unit, CLI shims).

## Generated PathItems rule (carry-forward)
Generated PathItems are **never hand-edited**, even if codegen is not
currently active here. If mode is escalated and a `peercolab/` folder
appears, treat it as machine-owned: change the model in the Builder and
re-run `RunPathItemsPrint`.

## What to do when blocked
- System not visible / read-only scope: stop, ask the user to open or
  promote the Workstation scope in Builder, then rerun.
- Write access missing for a mutation: do not invent a workaround;
  surface the blocker.
- Working dir off the mapped path: pass `--working-dir
  /home/ack/src/dotfiles/dictate-daemon` to the CLI.
