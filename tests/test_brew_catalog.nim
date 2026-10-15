## The Homebrew contribution catalog: its records, and the published JSON
## form `reprobuild.lib.brewRealizationOf` reads.
##
## What a consumer relies on, and so what is checked:
##
## * every contribution is pinned to the public interface fingerprint of a
##   canonical definition that exists (a stale pin fails extraction; this
##   checks the pin is the definition's CURRENT fingerprint);
## * the catalog is bridge-only: each contribution carries exactly one
##   Homebrew record and no realization Reprobuild could select;
## * the map is one-to-one in both directions: a token installs exactly one
##   canonical package, and a canonical package has exactly one token -- an
##   ambiguity would make the Nix reader refuse the name or the token;
## * the macOS application set reprobuild-packages defines as app bundles is covered,
##   each by the cask Homebrew publishes it under;
## * `provisioning-contributions.json` is a fresh rendering of `repro.nim`
##   (`just update-contribution-records` regenerates it).
##
## No mocks: the real `provisioningFor` macros register the records, the real
## interface extraction projects them, the real renderer renders them.

import std/[json, os, sequtils, strutils, tables, unittest]

import repro_interface_artifacts
import repro_interface_artifacts/contribution_records
import repro_project_dsl

import ../repro as catalog

const
  RecordsFile = "provisioning-contributions.json"
    ## The contribution records as data, for consumers that cannot run the
    ## provider: the reprobuild flake's `reprobuild.lib.brewRealizationOf`
    ## reads this file from the revision of this repository it pins.
  UpdateEnvVar = "REPRO_UPDATE_CONTRIBUTION_RECORDS"
    ## `just update-contribution-records` sets it to rewrite the file.
  Contributor = "github:metacraft-labs/reprobuild-brew-packages"

  MacosApplications = {
    "claude-desktop": "claude", "codex-desktop": "codex-app",
    "figma": "figma", "ghostty": "ghostty", "hammerspoon": "hammerspoon",
    "inkscape": "inkscape", "iterm2": "iterm2",
    "karabiner-elements": "karabiner-elements", "neovide": "neovide-app",
    "openwebstart": "openwebstart", "sqlitebrowser": "db-browser-for-sqlite",
    "tigervnc": "tigervnc", "turbovnc": "turbovnc-viewer", "utm": "utm",
    "vscode": "visual-studio-code", "windows-app": "windows-app"}
    ## The macOS application set reprobuild-packages defines with app-bundle
    ## realizations, and the Homebrew cask each is published under.

suite "Homebrew contribution catalog":
  test "every contribution is pinned to its canonical definition":
    let contributions = registeredProvisioningContributions()
    let packages = registeredPackages()
    check contributions.len == 30
    for contribution in contributions:
      checkpoint contribution.targetPackage
      check contribution.contributor == Contributor
      check not contribution.developInterface
      let targets = packages.filterIt(
        it.packageName == contribution.targetPackage)
      check targets.len == 1
      if targets.len == 1:
        check canonicalPackageInterfaceFingerprint(targets[0], packages) ==
          contribution.targetInterfaceFingerprint

  test "the catalog is bridge-only and one-to-one":
    var byToken = initTable[string, seq[string]]()
    var byPackage = initTable[string, int]()
    for contribution in registeredProvisioningContributions():
      checkpoint contribution.targetPackage
      check contribution.nixProvisioning.len == 0
      check contribution.tarballProvisioning.len == 0
      check contribution.scoopProvisioning.len == 0
      check contribution.homebrewProvisioning.len == 1
      for record in contribution.homebrewProvisioning:
        let key = record.kind & ":" & record.token
        byToken.mgetOrPut(key, @[]).add(contribution.targetPackage)
      byPackage[contribution.targetPackage] =
        byPackage.getOrDefault(contribution.targetPackage) + 1
    for token, names in byToken:
      checkpoint token & " -> " & names.join(", ")
      check names.len == 1
    for name, count in byPackage:
      checkpoint name
      check count == 1

  test "the macOS application set is covered by its casks":
    var casks = initTable[string, string]()
    for contribution in registeredProvisioningContributions():
      for record in contribution.homebrewProvisioning:
        if record.kind == "cask":
          casks[contribution.targetPackage] = record.token
    for (name, cask) in MacosApplications:
      checkpoint name
      check casks.getOrDefault(name) == cask

  test "the committed contribution records are the catalog's records":
    # The published JSON is generated from the recipe, never hand-edited: a
    # stale file would hand Nix consumers mappings this catalog no longer
    # declares. Regenerate with `just update-contribution-records`.
    let root = getCurrentDir()
    let artifact = artifactFromRegisteredDsl(root / "repro.nim")
    check artifact.projectInterface.provisioningContributions.len == 30
    let fresh = renderContributionRecords(
      artifact.projectInterface.provisioningContributions, root)
    if getEnv(UpdateEnvVar) == "1":
      writeFile(root / RecordsFile, fresh)
    check fileExists(root / RecordsFile)
    check readFile(root / RecordsFile) == fresh
    let doc = parseJson(fresh)
    check doc["format"].getStr == ContributionRecordsFormat
    check doc["contributions"].len == 30
    var tokens: seq[string] = @[]
    for c in doc["contributions"]:
      check c["location"]["file"].getStr == "repro.nim"
      for r in c["homebrewProvisioning"]:
        tokens.add(r["token"].getStr)
    check tokens.len == 30
    check "visual-studio-code" in tokens
    check "temurin@21" in tokens
    check not fresh.contains(root)
