# Dotfiles for Omarchy Quattro

This repository is a personal layer over Omarchy Quattro. Omarchy owns its
packaged desktop defaults. Git owns the personal overrides and development
configuration in this repository.

## Fresh installation

Clone the repository on a fresh Omarchy Quattro system:

```bash
git clone https://github.com/DanielSintimbrean/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install --dry-run
./install
```

The installer applies the complete setup. If Hyprland is running, it reloads
the configuration and reports any errors.

The scripts target a clean Omarchy Quattro installation. They do not repair or
migrate layouts created by older versions of this repository.

## Repository layout

The directory tree is the package registry. `stow-all` discovers every
top-level directory with a tracked `dot-*` entry, so adding or removing a Stow
package requires no separate list. GNU Stow's `--dotfiles` option maps names
such as `dot-config` and `dot-local` to their hidden paths under `$HOME`.

`skills/` is the canonical source for personal agent skills.
`sync-agent-skills` copies each skill into `~/.agents/skills` and
`~/.claude/skills` with rsync. Installed skills are real files and directories,
not links into this repository. Skills owned by Omarchy remain untouched
because the sync only writes names present in `skills/`.

## Sync safety

Before writing anything, `stow-all` rejects untracked files and staged changes.
This catches a new configuration file that was used locally but never added to
Git. Existing files that conflict with tracked Stow targets are moved under
`~/.local/state/dotfiles-backups/`; Stow never adopts them into the repository.

The tracked pre-push hook runs the same worktree check. It also validates the
Hyprland configuration from the exact commit being pushed, in an isolated
temporary home. A local file that is absent from the commit cannot make that
check pass accidentally.

Run the checks directly with:

```bash
./check-sync
```

## Updating

After pulling changes, run the same entrypoint:

```bash
git pull --ff-only
./install --dry-run
./install
```

To apply only repository links and skill copies:

```bash
./stow-all --dry-run
./stow-all
```

Avoid Omarchy refresh commands for Stowed files. They can write through a link
into the repository. Check `git status` after an Omarchy update that touches
personal configuration.
