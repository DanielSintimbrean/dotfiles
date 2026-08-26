# Dotfiles for Omarchy Quattro

This repository is a personal layer over Omarchy Quattro. Omarchy owns the desktop defaults, shell, launcher, notifications, themes, lock screen, idle behavior, and application templates. The repository keeps the settings that should survive a fresh installation.

## Fresh installation

Clone the repository on a fresh Omarchy Quattro system:

```bash
git clone https://github.com/DanielSintimbrean/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

Inspect the work before changing the machine:

```bash
./install --dry-run
```

Install the configuration:

```bash
./install
```

- `--dry-run` prints package, backup, Stow, Ghostty, mise installation, and reload actions without applying them.

The real install may prompt for account or sudo authentication. Log out and back in if it changes the login shell to Fish.

The installer:

- installs GNU Stow, Fish, and diff-so-fancy with `omarchy pkg add`;
- changes the login shell to Fish when needed;
- installs and enables the caps2esc udevmon mapping;
- installs and selects Ghostty with `omarchy install terminal ghostty`;
- backs up exact conflicting files under `~/.local/state/dotfiles-backups/`;
- Stows an explicit package allowlist without `--adopt`;
- generates Ghostty from the installed Quattro template, changing only font size and cursor shape;
- installs the development CLI tools declared in the tracked mise configuration;
- reloads Hyprland and reports configuration errors when a session is running.

## Configuration boundary

The managed Stow packages are:

```text
apps bin editor fish git hyprland startship system terminal tmux
```

`startship` is the historical package name for `~/.config/starship.toml`. The spelling is intentional.

The repository does not track the old Waybar-era desktop stack or copies of Quattro's current shell configuration. Btop, Foot, Alacritty, Waybar, Mako, Walker, Wofi, Wlogout, Fuzzel, lock, idle, browser flags, and font defaults remain owned by Omarchy.

The tracked `mimeapps.list` keeps Zen as the browser and Proton Mail handler, along with the T3 Code and Codex URL handlers across installations.

Ghostty is generated as a normal file rather than a Stow symlink. This lets Omarchy's font and migration commands edit it. Re-run the installer or `dotfiles-configure-ghostty` after a Quattro update if the packaged Ghostty template changes.

## Hyprland

[`hyprland.lua`](hyprland/dot-config/hypr/hyprland.lua) loads Quattro from `/usr/share/omarchy` first. The files beside it add only personal input, binding, workspace, monitor, and night-light behavior.

Personal behavior includes:

- Vim focus on `SUPER+H/J/K/L`;
- current-monitor workspace selection on `SUPER+1..9`;
- silent moves on `SUPER+SHIFT+1..9`;
- Quattro's normal workspace 10 and `SUPER+TAB` behavior;
- app placement across workspaces 1 through 9;
- clipboard manager on `SUPER+V` and universal paste on `SUPER+ALT+V`;
- monitor focus and workspace swaps on comma and period;
- night light at 2000K from 19:00 until 07:00.

Displaced Quattro actions are kept on alternate bindings where useful. Run this after installation to see the effective map:

```bash
omarchy menu keybindings --print
```

### Machine-specific monitors

[`monitors.lua`](hyprland/dot-config/hypr/monitors.lua) reads `/etc/hostname` in Lua. The `omarchy` hostname gets the saved three-display layout only when the hardware model also matches the current ASUS VivoBook. Every other machine uses Quattro's automatic preferred-mode configuration.

Add another entry to `monitor_profiles` for a new hostname and hardware model. This keeps one synced configuration safe across machines.

## Fish and mise

Fish contains aliases, abbreviations, paths, vi mode, Starship, native fzf initialization, and zoxide. Generated plugin code, legacy runtime managers, unsafe package aliases, and missing paths were removed.

Quattro activates mise for Fish and graphical sessions. The tracked [`config.toml`](system/dot-config/mise/config.toml) declares these global tools, and the installer runs `mise install`:

```text
bun claude codex copilot gemini gh ghui node@26 pi playwright pnpm ni grok npm-check-updates commitizen cz-git opencode
```

The mise configuration is Stowed at `~/.config/mise/config.toml`. Downloaded installations under `~/.local/share/mise` are machine state and are not tracked.

## Updating

After pulling repository changes:

```bash
./install --dry-run
./install
```

To relink only the managed packages:

```bash
./stow-all --dry-run
./stow-all
```

Avoid `omarchy refresh hyprland` and other refresh commands for Stowed files. A refresh can write through a symlink into the repository. Check `git status` after any Omarchy migration that touches managed configuration.

## Validation

Useful checks after changing configuration:

```bash
fish -n fish/dot-config/fish/config.fish
TERM=xterm-256color STARSHIP_CONFIG="$PWD/startship/dot-config/starship.toml" starship prompt >/dev/null
hyprctl reload
hyprctl configerrors
```

The installer runs the live Hyprland checks after Stowing. Before installation, use `Hyprland --verify-config` with a temporary HOME that exposes this repository as `~/.config/hypr`.
