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
- enables the tracked pre-push safety hook for this repository;
- backs up exact conflicting files under `~/.local/state/dotfiles-backups/`;
- Stows an explicit package allowlist with safe directory folding and without `--adopt`;
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

Personal agent skills live under `~/.agents/skills`. The matching entries under `~/.claude/skills` are tracked as symlinks so Claude uses the same source files. Omarchy owns its `omarchy` and `diagnose-crash` skill links because GNU Stow does not install absolute source links.

Ghostty is generated as a normal file rather than a Stow symlink. This lets Omarchy's font and migration commands edit it. Regeneration backs up a changed file and migrates a legacy symlink once. Re-run the installer or `dotfiles-configure-ghostty` after a Quattro update if the packaged Ghostty template changes.

## Hyprland

[`hyprland.lua`](hyprland/dot-config/hypr/hyprland.lua) loads Quattro from `/usr/share/omarchy` first. The files beside it add only personal input, binding, workspace, monitor, and night-light behavior.

The whole `~/.config/hypr` directory is folded to the repository. Its tracked
`.luarc.json` configures Lua language-server support for Hyprland and Omarchy's
`hl` and `o` globals; the actual Quattro defaults remain under
`/usr/share/omarchy` and are only imported by `hyprland.lua`.

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

The relink command prefers directory symlinks such as
`~/.config/fish -> ~/dotfiles/fish/dot-config/fish`. Before Stowing, it removes
only empty directories that would prevent safe folding. A configuration folder
is folded when it contains only content managed by its package; folders that
also contain local or Omarchy-owned files remain real directories with links at
the deepest safe level. Omarchy-owned application directories are explicitly
excluded from Stow. Conflicts are backed up, never adopted.

There is no need to remove all links first or maintain a separate repair script.
The command also verifies that every tracked target resolves to its repository
source, whether it is linked directly or through a folded directory.

Before changing links, `stow-all` refuses to continue when a managed package
contains an untracked file. This prevents a new live configuration file from
working through a folded directory without being included in Git and therefore
missing on another machine.

The installer configures Git to use the tracked `.githooks/pre-push` hook. Before
a push, it rejects untracked repository files and staged-but-uncommitted changes,
then extracts each ref tip being pushed into a temporary directory and validates
Hyprland from that committed snapshot. This catches imports that work locally
only because an uncommitted file exists. Run the same checks manually with:

```bash
./check-sync
```

Avoid `omarchy refresh hyprland` and other refresh commands for Stowed files. A refresh can write through a symlink into the repository. Check `git status` after any Omarchy migration that touches managed configuration.

## Validation

Useful checks after changing configuration:

```bash
bash -n install stow-all check-sync .githooks/pre-push
fish -n fish/dot-config/fish/config.fish
TERM=xterm-256color STARSHIP_CONFIG="$PWD/startship/dot-config/starship.toml" starship prompt >/dev/null
./check-sync
hyprctl reload
hyprctl configerrors
```

The installer runs the live Hyprland checks after Stowing. Before installation, use `Hyprland --verify-config` with a temporary HOME that exposes this repository as `~/.config/hypr`.
