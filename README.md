# reprobuild-brew-packages

Homebrew provisioning contributions for canonical Reprobuild package
interfaces: which Homebrew cask (or formula) installs each package.

The catalog uses `provisioningFor` with `brewCask "<token>"` /
`brewFormula "<token>"` records and pins every contribution to the public
interface fingerprint published by its owner. Standard tool interfaces come
from reprobuild; the application interfaces come from `reprobuild-packages`.
A stale catalog therefore fails explicitly when an interface changes instead
of mapping a token to an incompatible package.

These are bridge records. While a host still installs applications through
Homebrew, the reprobuild flake's Nix helper library reads them:
`reprobuild.lib.brewRealizationOf` turns a canonical package into the token
to install (the Home Manager intent module's default `homebrew.realizationOf`
hook), and `reprobuild.lib.lookupBrewToken` turns a Brewfile token back into
its canonical package. An unknown token maps to nothing and is reported.
Reprobuild itself never realizes a Homebrew record.

`provisioning-contributions.json` publishes the records as data. It is
generated from `repro.nim`: run `just update-contribution-records` after
changing a contribution; `just test` fails while the committed file is stale.

Licensed under the [Apache License 2.0](LICENSE). Contributors and coding
agents: see [AGENTS.md](AGENTS.md).
