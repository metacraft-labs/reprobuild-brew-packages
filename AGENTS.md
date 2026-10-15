# Reprobuild Brew Packages

This repository maps Homebrew cask and formula tokens to canonical package
interfaces owned by other repositories (`reprobuild-packages` and the
reprobuild standard library). Every contribution must pin the target public
interface fingerprint. Do not copy or redefine package interfaces here; add a
missing canonical definition to its owning repository first.

The records are bridge records: Nix consumers read them, Reprobuild never
installs through Homebrew. Each token maps to exactly one canonical package
and each package to exactly one token; `just test` enforces it.

## Layout

- `repro.nim` -- the catalog: one `provisioningFor` block per package.
- `provisioning-contributions.json` -- the records as data, generated from
  `repro.nim`; never edit it by hand.
- `tests/` -- the catalog's checks and the nimcache-locality check.
- `config.nims` -- finds the sibling `../reprobuild` (or `REPROBUILD_SRC`) and
  `../reprobuild-packages` (or `REPROBUILD_PACKAGES_ROOT`) checkouts.

## Commands

Run them in the reprobuild dev shell (`nix develop ../reprobuild --command
just <recipe>`), or after `. ..\reprobuild\env.ps1` on Windows.

- `just test` -- the catalog's checks.
- `just lint` -- the license check and a type check of `repro.nim`.
- `just update-contribution-records` -- regenerate
  `provisioning-contributions.json` after changing `repro.nim`; commit both.
- `prek install --install-hooks` once per clone; the hooks are in
  `.pre-commit-config.yaml` (on NixOS, put `uv` on `PATH` first).

Changes land on `agents` and reach `dev` through a promotion pull request.
Keep public commit messages user-facing.
