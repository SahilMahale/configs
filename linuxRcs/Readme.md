# Linux RC Files: Purpose, Content, and Dependencies

This document explains the intent and internals of shell-related files under `linuxRcs/`, with special focus on startup flow, what each block does, and which external tools each file depends on.

## Files Covered

- `linuxRcs/zshrc`
- `linuxRcs/zshrc_mac`
- `linuxRcs/bashrc`
- `linuxRcs/profile`
- `linuxRcs/environment`

## Startup Order and Scope

### Zsh

- Interactive Zsh reads `~/.zshrc`.
- In this repo, `zshrc` (Linux-flavored) and `zshrc_mac` (macOS-flavored) are templates/variants for that role.

### Bash

- Login Bash shell runs `~/.profile`.
- `profile` explicitly sources `~/.bashrc` when Bash is active, so interactive settings are reused.
- Non-login interactive Bash runs `~/.bashrc` directly.

### Session-wide environment

- `environment` is a shell-agnostic variable file (typically read by login/session manager).
- It should contain key/value env assignments only.

## Deep Explanation by File

### `linuxRcs/zshrc` (Linux Zsh)

Purpose: main interactive Linux Zsh configuration using Oh My Zsh plus personal aliases/functions.

Content breakdown:

1. **Oh My Zsh bootstrap**
  - Sets `ZSH="$HOME/.oh-my-zsh"`, theme `wedisagree`, and plugins `(git pnpm-shell-completion)`.
  - `source $ZSH/oh-my-zsh.sh` initializes completion, plugin hooks, and prompt.

2. **Alias layer**
  - Editor/navigation shortcuts: `zrcM`, `zrcR`, `ohmyzsh`, `nv`, `nvc`.
  - Utility shortcuts: `ff`, `lz`, `stDk`.

3. **Tool-specific env setup**
  - `EDITOR=nvim`, `KITTY_CONFIG` path.
  - `PNPM_HOME` with guarded PATH insertion.
  - Multiple PATH appends for local bin, Go toolchains, and user Go bin.
  - `HYPRSHOT_DIR`, `KUBECONFIG` exports.

4. **Custom functions**
  - `nvd()`: cd into target and open `nvim .` if directory change succeeds.
  - `yt_mpv()` / `twc_mpv()`: launch stream/video in background via `nohup`.

5. **Perl local::lib exports**
  - Adds local Perl bin/lib and install flags (`PERL5LIB`, `PERL_MB_OPT`, `PERL_MM_OPT`).

6. **Startup side effects**
  - Loads Angular CLI completion at shell start: `source <(ng completion script)`.
  - Prints greeting on each shell start: `fortune | cowsay`.

Operational implications:

- Startup cost rises because Angular completion and greeting run every shell launch.
- Missing `ng`, `fortune`, or `cowsay` can produce startup errors/noise if not installed.

### `linuxRcs/zshrc_mac` (macOS Zsh)

Purpose: macOS-oriented interactive Zsh config with lazy-loading for heavy runtimes and modern shell UX tools.

Content breakdown:

1. **Oh My Zsh baseline**
  - Theme disabled (`ZSH_THEME=""`), plugin list minimal `(git)`.
  - `source $ZSH/oh-my-zsh.sh` provides framework features.

2. **Aliases and workflow helpers**
  - Adds aliases for editor, navigation, rendering (`lolcat`), and replacements (`cat='bat'`, `ls='eza --icons=auto'`).

3. **PATH consolidation**
  - Single export includes `bob` Neovim, Go bin, local bin, Homebrew PostgreSQL, Docker app CLI.
  - Cleaner than repeated PATH appends and easier to audit.

4. **Lazy-load patterns**
  - `ng()` function initializes Angular completion only on first `ng` use.
  - `nvm()` loads Node version manager scripts only on demand.
  - `sdk()` loads SDKMAN only on demand.
  - This improves shell startup time while preserving functionality.

5. **Prompt and shell UX integrations**
  - Initializes `starship`, `zoxide`, and `fzf` shell bindings.
  - Sets `FZF_*` options for preview behavior and layout.
  - Sources iTerm2 shell integration if present at given path.

6. **Git + fzf functions**
  - `gcof`, `gcorf`, `gll`, `gaaf` provide interactive branch checkout/log/add flows.
  - Depend on `git`, `fzf` (and `fzf-tmux` for one helper), plus core UNIX tools.

Operational implications:

- Startup should feel faster than Linux `zshrc` due to lazy-loading of heavy managers.
- Integrations (`starship`, `zoxide`, `fzf`) are startup-critical in this file and must exist.

### `linuxRcs/bashrc` (Interactive Bash)

Purpose: standard interactive Bash behavior customization.

Content breakdown:

1. **Interactive shell guard**
  - `case $- in *i*) ;; *) return;; esac` ensures file exits early for non-interactive shells.

2. **History behavior**
  - `HISTCONTROL=ignoreboth`, `histappend`, history sizes configured.

3. **Prompt behavior**
  - Detects terminal color capability and sets colored or plain `PS1`.
  - Adds xterm title escape sequence when terminal matches xterm/rxvt.

4. **Color and completion setup**
  - Uses `dircolors` and sets colored `ls`/`grep` aliases.
  - Loads Bash completion if available from common system paths.

5. **User extensions**
  - Sources `~/.bash_aliases` when present.
  - Adds Go to `PATH`, runs `eval "$(dircolors ~/dircolors)"`, sources Cargo env.

Operational implications:

- Strongly conventional and portable for Debian/Ubuntu-like systems.
- Assumes tools/files like `dircolors`, `~/.cargo/env`, and optional completion files may exist.

### `linuxRcs/profile` (Login shell profile)

Purpose: baseline login-session setup and cross-shell exports.

Content breakdown:

1. **Bash handoff**
  - If running Bash and `~/.bashrc` exists, sources it.

2. **Login PATH setup**
  - Prepends `$HOME/bin` and `$HOME/.local/bin` when those directories exist.
  - Appends Go binary paths including `$(go env GOPATH)/bin`.

3. **Session exports and aliases**
  - Exports `QT_STYLE_OVERRIDE=kvantum`, `KUBECONFIG=/etc/rancher/k3s/k3s.yaml`.
  - Defines aliases (`nv`, `nvc`, `ffc`, `cl`).
  - Sources Cargo env.

4. **Potential issue to fix**
  - Current line `export $TERM='wezterm'` is invalid shell syntax.
  - Intended form is likely `export TERM='wezterm'`.

Operational implications:

- Because this is a login file, aliases here are not guaranteed in all non-login shell contexts unless the shell reads profile.

### `linuxRcs/environment` (Session environment file)

Purpose: define GPU rendering behavior variables for NVIDIA PRIME/Optimus setups.

Content breakdown:

- `__NV_PRIME_RENDER_OFFLOAD=1`: enables PRIME render offload behavior.
- `__GLX_VENDOR_LIBRARY_NAME=nvidia`: selects NVIDIA GLX vendor implementation.
- `__VK_LAYER_NV_optimus=NVIDIA_only`: favors NVIDIA for Vulkan layer selection.

Operational implications:

- Useful for hybrid graphics laptops/desktops where iGPU+dGPU routing is needed.
- Best kept free of shell syntax (functions, aliases, command substitution).

## Dependency Summary

### Core shell/framework

- `zsh`, `bash`
- `oh-my-zsh`
- Oh My Zsh plugins/themes used: `git`, `pnpm-shell-completion`, `wedisagree`

### Editors and shell UX

- `nvim`, `starship`, `zoxide`, `fzf`, `fzf-tmux`, iTerm2 shell integration script

### Language/tool managers

- `pnpm`, Angular CLI (`ng`), `nvm`, `sdkman`, Go, Rust/Cargo, local Perl (`local::lib`)

### Utilities used by aliases/functions

- `git`, `fastfetch`, `lazygit`, `mpv`, `streamlink`, `fortune`, `cowsay`, `lolcat`, `bat`, `eza`, `anigreeter`, `systemctl`
- Standard UNIX helpers: `awk`, `sed`, `grep`, `wc`, `xargs`, `less`, `sh`, `dircolors`

## Practical Notes

- Missing startup-critical tools can break/noise shell initialization.
- Linux `zshrc` is more eager at startup; macOS `zshrc_mac` is more lazy-loaded.
- Keep OS-specific paths and commands isolated to their respective files.
