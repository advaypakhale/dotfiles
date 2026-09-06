# AGENTS.md

User environment for any machine, including ones not administered: no root,
one code path. `mise run bootstrap` (server) or `mise run desktop`.

- Scope test: on a machine I don't administer, is my environment broken
  without it? Yes → belongs here. Needs root → belongs in the homelab
  ansible repo, which calls this one and is never called by it.
- Prerequisites (git, curl, stow, a compiler) are the machine's job.
- Tools are pinned in `mise/.config/mise/config.toml` + `mise.lock`; nvim
  stays on nightly. Neovim's own toolchain (node, python, and a source-built
  tree-sitter CLI) is pinned in `nvim/.config/nvim/mise.toml` instead, so it
  stays off the login PATH. Claude Code installs via the native installer,
  not npm.
- All setup is mise tasks in `mise.toml`; scripts under `scripts/` are task
  bodies, never invoked directly in docs.
- Stow packages only contain files I author; mutable app state stays
  untracked.
- Load the `no-crap-docs` skill before writing docs, comments, or commits.
  Conventional Commits, no attribution footers. Subject only, unless the
  change needs a why the subject can't carry.
- Discuss first; implement only after explicit approval.
