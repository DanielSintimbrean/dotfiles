# Repository instructions

## Purpose

These dotfiles are a personal overlay for Omarchy Quattro on Arch Linux. Omarchy owns its packaged desktop defaults. Keep this repository limited to deliberate personal overrides and development configuration.

Never edit `/usr/share/omarchy/`. Read it to compare current defaults before changing user configuration.

## Stow layout

The managed top-level Stow packages are `apps`, `bin`, `editor`, `fish`, `git`, `hyprland`, `startship`, `system`, `terminal`, and `tmux`.

GNU Stow runs with `--dotfiles`, so:

- `<package>/dot-config/<app>/` maps to `~/.config/<app>/`.
- `<package>/dot-local/` maps to `~/.local/`.
- `git/dot-gitconfig` maps to `~/.gitconfig`.

`startship` is the historical package name for Starship. Keep that spelling.

`setup/` contains installer assets and is not a Stow package. `better-bird/` is tracked reference data and is not Stowed.

## Install and relink

Use the repository scripts from any working directory:

```bash
./install --dry-run
./install
./stow-all --dry-run
./stow-all
```

Both scripts are fail-fast. `stow-all` uses an explicit allowlist, backs up exact conflicts under `~/.local/state/dotfiles-backups/`, uses `--no-folding`, and never uses `--adopt`.

The installer always configures Fish as the login shell and installs the privileged caps2esc udevmon mapping. Keep `--dry-run` free of writes.

README.md is the source of truth for the fresh-machine workflow.

## Omarchy ownership

Hyprland user files load Quattro defaults from `/usr/share/omarchy` before personal modules. Keep bindings, workspaces, input, monitor profiles, and night light as small overrides. Leave appearance, shell, launcher, notifications, lock, idle, and stock application rules to Omarchy.

Do not restore copied Waybar, Mako, Walker, Wofi, Wlogout, Fuzzel, Foot, Alacritty, btop, browser flag, fontconfig, hypridle, or hyprlock configurations.

Ghostty is generated from the installed Quattro template by `bin/dot-local/bin/dotfiles-configure-ghostty`. Keep it as a normal user file so Omarchy migrations and font commands can edit it.

Avoid `omarchy refresh` for Stowed files. It may write through symlinks and dirty the repository.

## Validation

Run checks that match the changed domain:

```bash
bash -n install stow-all bin/dot-local/bin/dotfiles-configure-ghostty
fish -n fish/dot-config/fish/config.fish fish/dot-config/fish/functions/pid-port.fish
TERM=xterm-256color STARSHIP_CONFIG="$PWD/startship/dot-config/starship.toml" starship prompt >/dev/null
```

Validate repository Hyprland files with an isolated HOME so Lua imports resolve to this checkout:

```bash
validation_home=$(mktemp -d)
mkdir -p "$validation_home/.config" "$validation_home/.local/state"
ln -s "$PWD/hyprland/dot-config/hypr" "$validation_home/.config/hypr"
HOME="$validation_home" XDG_CONFIG_HOME="$validation_home/.config" XDG_STATE_HOME="$validation_home/.local/state" \
  Hyprland --verify-config --config "$PWD/hyprland/dot-config/hypr/hyprland.lua"
rm -r "$validation_home"
```

After changing an active Stowed Hyprland config, finish with:

```bash
hyprctl reload
hyprctl configerrors
```
