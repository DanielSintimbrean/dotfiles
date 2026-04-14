# CLAUDE.md

## Overview

Personal dotfiles managed with GNU Stow on Arch Linux + Hyprland. Each top-level directory is a **stow package** whose internal layout mirrors `$HOME` (using `--dotfiles`, so `dot-config/foo` becomes `~/.config/foo`).

## Stow layout

- Packages are the top-level dirs: `apps`, `bin`, `btop`, `editor`, `fish`, `git`, `hyprland`, `startship`, `system`, `terminal`, `tmux`, `walker`, `better-bird`.
- The `--dotfiles` flag rewrites `dot-*` prefixes to `.*` on stow. So when adding/editing config:
  - Files under `<pkg>/dot-config/<app>/` → symlinked to `~/.config/<app>/`
  - Files under `<pkg>/dot-local/...` → symlinked to `~/.local/...`
  - Single files like `git/dot-gitconfig`, `git/dot-czrc` → `~/.gitconfig`, `~/.czrc`
- `.stow-local-ignore` excludes `README.*`, `betterbird/.*`, `fish_variables`, `tmux/plugins`, `.git*`, emacs backups, etc. — keep this in mind when adding files that stow should skip.

## Commands

Re-stow everything after adding/changing files:

```bash
./stow-all          # iterates every top-level dir, runs `stow <pkg> --dotfiles --adopt`
```

Stow a single package:

```bash
stow <pkg> --dotfiles --adopt    # --adopt pulls existing files in $HOME into the repo
git restore .                    # revert if --adopt overwrote repo contents with worse $HOME versions
```

Unstow: `stow -D <pkg> --dotfiles`.

## Notes

- `--adopt` is used intentionally (see README install flow): it moves existing real files in `$HOME` into the package dir, replacing them with symlinks. After adopting, run `git restore .` to keep the committed versions and discard the adopted ones.
- `better-bird/` is ignored by stow (see `.stow-local-ignore`) — it's tracked in git but not symlinked.
- `startship` (sic) is the Starship prompt package; don't "fix" the spelling — the dir name is just the stow package name, not user-facing.
- README.md contains the bootstrap recipe (pacman/yay packages, tmux TPM, docker group, caps2esc via interception-tools). Treat it as the source of truth for machine setup steps.
