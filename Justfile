# The standard recipes (metacraft-dev-guidelines repo-requirements.md §3).
# Every recipe runs in an environment that provides nim, just and prek: the
# reprobuild dev shell (`nix develop ../reprobuild`) on Linux and macOS, or
# reprobuild's `env.ps1` on Windows.

alias t := test
alias fmt := format

# The catalog has no artifact of its own to compile: building it is
# type-checking `repro.nim` against the canonical interfaces it imports (imported
# only to register them, hence no UnusedImport warnings).
build:
  nim check --hints:off --warning:UnusedImport:off repro.nim

test:
  nim c -r --hints:off --warnings:off --out:build/test-nimcache-locality tests/test_nimcache_is_worktree_local.nim
  nim c -r --hints:off --warnings:off --nimcache:build/nimcache-brew-catalog --out:build/test-brew-catalog tests/test_brew_catalog.nim

# The license check (repo-requirements.md §10) and the build. The formatting
# and committed-binary checks are the pre-commit hooks (`prek run --all-files`),
# which run this recipe as their `lint` hook.
lint: check-license build

check-license:
  #!/usr/bin/env bash
  set -euo pipefail
  if [ ! -f LICENSE ] && [ ! -f LICENSE-APACHE ] && [ ! -f LICENSE-MIT ]; then
    echo "Error: no license file (LICENSE, LICENSE-APACHE, LICENSE-MIT) in the repository root" >&2
    exit 1
  fi

# Apply the hooks that rewrite files (end-of-file-fixer, prettier --write).
# prek exits non-zero when it changed something; run it again to confirm a
# clean pass.
format:
  prek run --all-files

# Regenerate provisioning-contributions.json, the contribution records as data
# for consumers that cannot run the provider (the reprobuild flake's
# `reprobuild.lib.brewRealizationOf`). `just test` fails while it is stale.
update-contribution-records:
  REPRO_UPDATE_CONTRIBUTION_RECORDS=1 nim c -r --hints:off --warnings:off --nimcache:build/nimcache-brew-catalog --out:build/test-brew-catalog tests/test_brew_catalog.nim
