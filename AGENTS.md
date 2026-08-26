# Repository instructions

## Scope

README.md defines the supported system, repository layout, and user workflow.
Treat that scope as a hard boundary. Keep package and configuration inventories
out of scripts and documentation.

Omarchy owns its packaged defaults. Keep this repository limited to personal
overrides and development configuration. Never edit `/usr/share/omarchy/`.

## Layout

Preserve directory-driven Stow package discovery. GNU Stow runs with
`--dotfiles`. `startship` is the historical package name for Starship and must
keep that spelling.

Keep installed agent skills out of Stow. `sync-agent-skills` must copy only the
canonical `skills/` tree.

## Installation rules

Keep `install`, `stow-all`, and `sync-agent-skills` fail-fast. Dry runs must not
write. Stow may back up an exact conflicting target, but it must never use
`--adopt`.

Use `check-sync` for the installer and pre-push guards. It must reject untracked
files and staged changes before configuration is applied. The pre-push hook must
also validate Hyprland from the committed snapshot.

Generate Ghostty from the installed Omarchy template as a regular file so
Omarchy font commands can edit it.

## Validation

Run checks that match the changed files:

```bash
bash -n install stow-all sync-agent-skills check-sync .githooks/pre-push bin/dot-local/bin/dotfiles-configure-ghostty
fish -n fish/dot-config/fish/config.fish fish/dot-config/fish/functions/pid-port.fish
TERM=xterm-256color STARSHIP_CONFIG="$PWD/startship/dot-config/starship.toml" starship prompt >/dev/null
./check-sync
```

Validate Hyprland with an isolated home that links
`hyprland/dot-config/hypr` at `~/.config/hypr`. After changing the active
Hyprland configuration, run `hyprctl reload` and `hyprctl configerrors`.
