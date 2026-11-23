## The Homebrew contribution catalog: which Homebrew cask or formula installs
## each canonical Reprobuild package.
##
## These are BRIDGE records (reprobuild-pm spec Provisioning-Contributions.md,
## "Homebrew bridge records"). While a host still installs macOS applications
## through Homebrew, a Nix consumer needs the token that installs a canonical
## package, and an equivalence report needs the canonical package a Brewfile
## token installs. The reprobuild flake's `reprobuild.lib.brewRealizationOf`
## reads them from `provisioning-contributions.json`, which is generated from
## this file (`just update-contribution-records`; `just test` fails while it is
## stale). Reprobuild itself never realizes a Homebrew record: it is carried in
## the interface artifact's `provisioningContributions` and never becomes a
## realization candidate.
##
## Each record maps one token to exactly one canonical package, pinned to that
## package's public interface fingerprint, so a renamed or reshaped definition
## fails here instead of being mapped by guess. Every token was checked to
## exist with Homebrew's API (`https://formulae.brew.sh/api/cask/<token>.json`,
## HTTP 200) on 2026-10-14, and again on 2026-10-15.

import repro_project_dsl
# The owning interfaces, imported so interface extraction sees the definitions
# the contributions are pinned to (the same arrangement as
# reprobuild-nix-packages).
import repro_dsl_stdlib/packages/jdk
import "../reprobuild-packages/packages/interfaces/claude-desktop/repro" as claudeDesktopInterface
import "../reprobuild-packages/packages/interfaces/codex-desktop/repro" as codexDesktopInterface
import "../reprobuild-packages/packages/interfaces/figma/repro" as figmaInterface
import "../reprobuild-packages/packages/interfaces/ghostty/repro" as ghosttyInterface
import "../reprobuild-packages/packages/interfaces/hammerspoon/repro" as hammerspoonInterface
import "../reprobuild-packages/packages/interfaces/inkscape/repro" as inkscapeInterface
import "../reprobuild-packages/packages/interfaces/iterm2/repro" as iterm2Interface
import "../reprobuild-packages/packages/interfaces/karabiner-elements/repro" as karabinerElementsInterface
import "../reprobuild-packages/packages/interfaces/neovide/repro" as neovideInterface
import "../reprobuild-packages/packages/interfaces/openwebstart/repro" as openwebstartInterface
import "../reprobuild-packages/packages/interfaces/sqlitebrowser/repro" as sqlitebrowserInterface
import "../reprobuild-packages/packages/interfaces/tigervnc/repro" as tigervncInterface
import "../reprobuild-packages/packages/interfaces/turbovnc/repro" as turbovncInterface
import "../reprobuild-packages/packages/interfaces/utm/repro" as utmInterface
import "../reprobuild-packages/packages/interfaces/vscode/repro" as vscodeInterface
import "../reprobuild-packages/packages/interfaces/clion/repro" as clionInterface
import "../reprobuild-packages/packages/interfaces/gimp/repro" as gimpInterface
import "../reprobuild-packages/packages/interfaces/libreoffice/repro" as libreofficeInterface
import "../reprobuild-packages/packages/interfaces/rustrover/repro" as rustroverInterface
import "../reprobuild-packages/packages/interfaces/spotify/repro" as spotifyInterface
import "../reprobuild-packages/packages/interfaces/steam/repro" as steamInterface
import "../reprobuild-packages/packages/interfaces/thunderbird/repro" as thunderbirdInterface
import "../reprobuild-packages/packages/interfaces/vlc/repro" as vlcInterface
import "../reprobuild-packages/packages/interfaces/wireshark/repro" as wiresharkInterface
import "../reprobuild-packages/packages/interfaces/zoom/repro" as zoomInterface
import "../reprobuild-packages/packages/interfaces/windows-app/repro" as windowsAppInterface
import "../reprobuild-llm-agent-packages/packages/interfaces/codex/repro" as codexInterface
import "../reprobuild-packages/packages/interfaces/cursor/repro" as cursorInterface
import "../reprobuild-packages/packages/interfaces/discord/repro" as discordInterface
import "../reprobuild-packages/packages/interfaces/google-antigravity/repro" as googleAntigravityInterface
import "../reprobuild-packages/packages/interfaces/google-antigravity-cli/repro" as googleAntigravityCliInterface
import "../reprobuild-packages/packages/interfaces/google-antigravity-ide/repro" as googleAntigravityIdeInterface
import "../reprobuild-packages/packages/interfaces/ledger-wallet/repro" as ledgerWalletInterface
import "../reprobuild-packages/packages/interfaces/maccy/repro" as maccyInterface
import "../reprobuild-packages/packages/interfaces/signal/repro" as signalInterface
import "../reprobuild-packages/packages/interfaces/slack/repro" as slackInterface
import "../reprobuild-packages/packages/interfaces/telegram/repro" as telegramInterface
import "../reprobuild-packages/packages/interfaces/viber/repro" as viberInterface
import "../reprobuild-packages/packages/interfaces/virtualbuddy/repro" as virtualbuddyInterface
import "../reprobuild-packages/packages/interfaces/zerotier-one/repro" as zerotierOneInterface

# --- The macOS applications reprobuild-packages defines from vendor artifacts
# (app-bundle definitions; karabiner-elements and openwebstart are declared but
# refused until a realizer for their installers exists). The cask stays the
# bridge for hosts that have not moved them off Homebrew.

# Anthropic's Claude desktop application.
provisioningFor "claude-desktop":
  interfaceFingerprint "6711c016e90ede46db0b3269a5bd335ac12da2cedd7ca5d80194fdd05a959eb3"
  contributor "github:metacraft-labs/reprobuild-brew-packages"
  brewCask "claude"

# The desktop application's cask is `codex-app`; Homebrew's `codex` cask is
# the CLI (`codex` below).
provisioningFor "codex-desktop":
  interfaceFingerprint "b08c13c8611c6f533c323b11d5295275c613bf077b12f32855adf9266760267d"
  contributor "github:metacraft-labs/reprobuild-brew-packages"
  brewCask "codex-app"

provisioningFor "figma":
  interfaceFingerprint "0a6c9ce906f240dbd956edec0fe1f65f667c64190ff838d2ab78cf1a12ef68de"
  contributor "github:metacraft-labs/reprobuild-brew-packages"
  brewCask "figma"

provisioningFor "ghostty":
  interfaceFingerprint "d44788aef18ea078e8b4fcd5f110cb5810a5a87d82c2d547b970abf4dfa197dc"
  contributor "github:metacraft-labs/reprobuild-brew-packages"
  brewCask "ghostty"

provisioningFor "hammerspoon":
  interfaceFingerprint "71f3eb8a2fe3b9b36a89d9c64e622377bfe3de5083ef849da7d4f1c1da5f4c78"
  contributor "github:metacraft-labs/reprobuild-brew-packages"
  brewCask "hammerspoon"

provisioningFor "inkscape":
  interfaceFingerprint "de81490859b583facf96516035bb798f2685b5e49271dc217f7b2ea007684d45"
  contributor "github:metacraft-labs/reprobuild-brew-packages"
  brewCask "inkscape"

provisioningFor "iterm2":
  interfaceFingerprint "f77eaca1ec7dbe356ea48518b57c9bbc5d1504ec9684f6461614b5a625edb59a"
  contributor "github:metacraft-labs/reprobuild-brew-packages"
  brewCask "iterm2"

provisioningFor "karabiner-elements":
  interfaceFingerprint "0ed4e7e6f260bdec1729a51c105311e8a0b29d108aca55a54df53613bd348141"
  contributor "github:metacraft-labs/reprobuild-brew-packages"
  brewCask "karabiner-elements"

# The cask is `neovide-app`; Homebrew's `neovide` is a formula.
provisioningFor "neovide":
  interfaceFingerprint "cc91498fe96c18067fdcf3729aa5e3a12ca09218c39ef20e8b4685cab9693ef5"
  contributor "github:metacraft-labs/reprobuild-brew-packages"
  brewCask "neovide-app"

provisioningFor "openwebstart":
  interfaceFingerprint "115a8de3056c85495daed52f3196a57cddac4efdc66a978917015a64d6c152df"
  contributor "github:metacraft-labs/reprobuild-brew-packages"
  brewCask "openwebstart"

# DB Browser for SQLite.
provisioningFor "sqlitebrowser":
  interfaceFingerprint "86c9f9c4142dc958a3b6a7399f21f344e21bff13f9bf7ff91b83191804278f09"
  contributor "github:metacraft-labs/reprobuild-brew-packages"
  brewCask "db-browser-for-sqlite"

provisioningFor "tigervnc":
  interfaceFingerprint "80bd1626dbd9019436b4bdecb43fcf078d4120afa30c754bdb6e24a3c366f2b9"
  contributor "github:metacraft-labs/reprobuild-brew-packages"
  brewCask "tigervnc"

provisioningFor "turbovnc":
  interfaceFingerprint "11cf5be46c3bdef604d570a00447e34e14d2266e48f35e14a826e747dc8fa611"
  contributor "github:metacraft-labs/reprobuild-brew-packages"
  brewCask "turbovnc-viewer"

provisioningFor "utm":
  interfaceFingerprint "b5d653d9205cfd41e28a2c9bed0f1e4d1e3f664bf67ba46b179cd808ece9afec"
  contributor "github:metacraft-labs/reprobuild-brew-packages"
  brewCask "utm"

provisioningFor "vscode":
  interfaceFingerprint "8f2b44e1313bf75e9e61a1ab61988aaf83f800d4b8f01abf79b8286c87468faa"
  contributor "github:metacraft-labs/reprobuild-brew-packages"
  brewCask "visual-studio-code"

provisioningFor "windows-app":
  interfaceFingerprint "bbc861c64a64555ac9963619a58042513e591295a6b5caec3eb49a2796fc6a5e"
  contributor "github:metacraft-labs/reprobuild-brew-packages"
  brewCask "windows-app"

# --- Applications only Homebrew installs today ------------------------------
# (interface-only definitions in reprobuild-packages, or the stdlib's `jdk`).

# The `codex` cask is OpenAI's terminal coding agent (the CLI), not the
# desktop application, whose cask is `codex-app` (codex-desktop above).
provisioningFor "codex":
  interfaceFingerprint "fa936c46615d714d4efdaec268a339ef49b5051208a9d6bb9b656247db2615c8"
  contributor "github:metacraft-labs/reprobuild-brew-packages"
  brewCask "codex"

provisioningFor "cursor":
  interfaceFingerprint "8dd554281084bff16420c3d253d7414115f41fc6ca153d6b7c4bcbb655114069"
  contributor "github:metacraft-labs/reprobuild-brew-packages"
  brewCask "cursor"

provisioningFor "discord":
  interfaceFingerprint "65422a2af33f641bae22967bde3a3ac28828b40fc77abf13d8a144e3b4f21deb"
  contributor "github:metacraft-labs/reprobuild-brew-packages"
  brewCask "discord"

# Google Antigravity's base application.
provisioningFor "google-antigravity":
  interfaceFingerprint "14401f7b04e34f7d8a4a2aa16e362b5a5b0e243adb6b22f42702b288d712a4fa"
  contributor "github:metacraft-labs/reprobuild-brew-packages"
  brewCask "antigravity"

provisioningFor "google-antigravity-cli":
  interfaceFingerprint "2aa80add15052138b871ed86909deb08d9f92ff39c77a1717e49e4e22dc426f6"
  contributor "github:metacraft-labs/reprobuild-brew-packages"
  brewCask "antigravity-cli"

provisioningFor "google-antigravity-ide":
  interfaceFingerprint "edf7f8b82b4aeb14992a33dc1ad708fa88aba66a30272602bd9d02900f3dfd82"
  contributor "github:metacraft-labs/reprobuild-brew-packages"
  brewCask "antigravity-ide"

# `temurin@21`: Eclipse Temurin 21, the JDK 21 LTS line. The cask token
# carries the major version; the canonical package is `jdk`.
provisioningFor "jdk":
  interfaceFingerprint "afc0a39a7be6a642e5a99b2a65ae0650f53c4ccc6a4b0b3a9fd94b1a77547078"
  contributor "github:metacraft-labs/reprobuild-brew-packages"
  brewCask "temurin@21"

provisioningFor "ledger-wallet":
  interfaceFingerprint "487ce7e97ba72bef67ad9bb74fed74b750769d05725382cc6f949b1c7661df40"
  contributor "github:metacraft-labs/reprobuild-brew-packages"
  brewCask "ledger-wallet"

provisioningFor "signal":
  interfaceFingerprint "fadf54bca39b6882281466d3bd6a18ed11c51370821860aa07096a21d507ce69"
  contributor "github:metacraft-labs/reprobuild-brew-packages"
  brewCask "signal"

provisioningFor "maccy":
  interfaceFingerprint "ee52cd529b03482b076f62cef18c5e9de44ab5a0ce9974bce609ed8a9df6e11c"
  contributor "github:metacraft-labs/reprobuild-brew-packages"
  brewCask "maccy"

provisioningFor "slack":
  interfaceFingerprint "f3d91e94ebc062a136f339820d2371abf8b321601f7aa79b747148a42e08bdf3"
  contributor "github:metacraft-labs/reprobuild-brew-packages"
  brewCask "slack"

provisioningFor "telegram":
  interfaceFingerprint "f6a46eda0a193ca94573c51a8d8c7007ac4c2254cea8fa73b0291c8ba69385d6"
  contributor "github:metacraft-labs/reprobuild-brew-packages"
  brewCask "telegram"

provisioningFor "viber":
  interfaceFingerprint "b0b894c110dd97e74be2fe0455c523a0c7151308dc53ac9cee507332d6e7af7c"
  contributor "github:metacraft-labs/reprobuild-brew-packages"
  brewCask "viber"

provisioningFor "virtualbuddy":
  interfaceFingerprint "a93f0305d37a74c9f8a1118e50d4f74730982a25a700277712fffc69ffb7c813"
  contributor "github:metacraft-labs/reprobuild-brew-packages"
  brewCask "virtualbuddy"

provisioningFor "zerotier-one":
  interfaceFingerprint "9e0b34face21cbbfc994c805ceaa0c48efffd04abb267d82d9c4247c884f592c"
  contributor "github:metacraft-labs/reprobuild-brew-packages"
  brewCask "zerotier-one"

package reprobuildBrewPackages:
  devEnv:
    task "test",
      command = "nim c -r --nimcache:build/nimcache-brew-catalog tests/test_brew_catalog.nim",
      description = "Validate the Homebrew contribution catalog"

provisioningFor "thunderbird":
  interfaceFingerprint "a1f2866c113545a59e655f8ea13d4a07167fe1bcfa4bea4bad9cd41b8603ddc8"
  contributor "github:metacraft-labs/reprobuild-brew-packages"
  brewCask "thunderbird"

provisioningFor "vlc":
  interfaceFingerprint "1b4114ca2be7fbfc49ccb469b75d38a96b4cf661652e0ff79857ba93726d9f8b"
  contributor "github:metacraft-labs/reprobuild-brew-packages"
  brewCask "vlc"

provisioningFor "zoom":
  interfaceFingerprint "e51b411eaec1ff27ed0f6954a95fbb2b26c1fb39c05ca733738df20269cbdc2f"
  contributor "github:metacraft-labs/reprobuild-brew-packages"
  brewCask "zoom"

provisioningFor "wireshark":
  interfaceFingerprint "ec45a6aaa94e644aeef43ba7ed5ce54060bf5f3e51826812682e77d8b228e090"
  contributor "github:metacraft-labs/reprobuild-brew-packages"
  brewCask "wireshark-app"

provisioningFor "libreoffice":
  interfaceFingerprint "f8bf7664e3636c6c308262aa9384bfb90d1d098f2279876470c66fae90f29925"
  contributor "github:metacraft-labs/reprobuild-brew-packages"
  brewCask "libreoffice"

provisioningFor "rustrover":
  interfaceFingerprint "b8255c7c88d214ada7b28a3b196e353288b6315f023d64c8eee567da71c23877"
  contributor "github:metacraft-labs/reprobuild-brew-packages"
  brewCask "rustrover"

provisioningFor "spotify":
  interfaceFingerprint "4092e02c0eef9ff3e2d506a17a48124a2f41c7fba1b02f47283fc086099c40ca"
  contributor "github:metacraft-labs/reprobuild-brew-packages"
  brewCask "spotify"

provisioningFor "clion":
  interfaceFingerprint "2fb5f0c752de048397b2164ad7f7b659557e347a316c8224c6b671e7ad8a1b53"
  contributor "github:metacraft-labs/reprobuild-brew-packages"
  brewCask "clion"

provisioningFor "gimp":
  interfaceFingerprint "18eb65e4b4ef4b21de550120e1f220291a77974fdeec0a980392683c6be2fe7f"
  contributor "github:metacraft-labs/reprobuild-brew-packages"
  brewCask "gimp"

provisioningFor "steam":
  interfaceFingerprint "141ad236a649ce9f1806d3b1d608826d3a97210f3719042233d77e33dde5cfbf"
  contributor "github:metacraft-labs/reprobuild-brew-packages"
  brewCask "steam"
