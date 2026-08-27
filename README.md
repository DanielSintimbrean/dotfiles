# dotfiles

My Linux configuration, written as a thin layer on top of [Omarchy Quattro](https://omarchy.org).

Omarchy already ships good defaults for Hyprland, the terminal, themes and most of the desktop. Rather than fork all of that, this repo only holds the parts where I disagree with the defaults or need something Omarchy doesn't cover. Everything else stays as Omarchy installs it, so its updates keep working.

## What's in here

```
home/     one GNU Stow package, mirrors ~ (dot-config -> .config, dot-local -> .local, ...)
skills/   skills for Claude Code and Codex, linked into each agent's skills directory
etc/      the caps2esc job for interception-tools (goes to /etc)
extras/   Thunderbird filter rules
install   the whole setup, 30 lines
```

The interesting bits inside `home/`:

- `hypr/`. Hyprland in Lua, loaded after Omarchy's own config. Vim-style focus on `SUPER + hjkl`, workspaces 1-9 pinned to the current monitor, monitor focus that drags the pointer along, and a monitor profile that only applies on my laptop (it checks hostname and DMI product name, so it won't misconfigure your screens if you copy it).
- `fish/`. Vi keybindings, `eza` and `bat` in place of `ls` and `cat`, starship, fzf, zoxide. No plugin manager.
- `nvim/`. Started from kickstart.nvim and moved to the built-in `vim.pack`. One file per plugin under `lua/plugins/`.
- `tmux/`, `starship.toml`, `zed/`, `Cursor/`, `lazygit/`, `mise/`. Small personal tweaks.
- `dot-local/bin/`. Scripts I reach for daily: `killport`, `checkport`, `randpass`, `ai-commit`, `backup-home`.

## How it's wired

Stow links `home/` into `~` with `--dotfiles`, so `home/dot-config/hypr` becomes `~/.config/hypr`. Editing a file in `~/.config` edits the repo, and `git status` shows what changed. That's the whole sync story.

Agent skills get the same treatment, one `stow` call per agent directory. Each skill ends up as a directory symlink, which matters because at least one agent stops detecting a skill when `SKILL.md` itself is a symlink.

`install` does, in order: install `stow` and `fish`, install Ghostty through Omarchy, delete the five Omarchy defaults this repo replaces, stow, link skills, `mise install`, switch the login shell to fish, set up caps2esc, reload Hyprland. There is no dry-run flag. The script is short enough that reading it is the dry run.

## Using it yourself

Honest answer: don't run `install` as-is. It changes your login shell, installs a udev job that remaps Caps Lock, and deletes Omarchy's Hyprland config from `~/.config`. It's meant for a fresh Omarchy machine that I own.

What does transfer well is the approach. If you're on Omarchy and tired of losing changes on updates, clone this, delete everything in `home/` you don't want, and keep the two ideas that carry the weight: one Stow package for all of `~`, and a Hyprland `hyprland.lua` that requires Omarchy's defaults first and your overrides after. Cherry-pick the Hyprland bindings or the fish aliases if that's all you came for.

On my own machines the flow is:

```bash
git clone https://github.com/DanielSintimbrean/dotfiles.git ~/dotfiles
cd ~/dotfiles
cat install    # read it
./install
```

## Notes

- `omarchy font set` runs `sed -i` on the Ghostty config, which turns the Stow link back into a plain file. `stow -R --dotfiles -t ~ home` fixes it. I decided to live with that rather than add a generator script.
- `AGENTS.md` has the procedural rules for coding agents working in this repo. It's not written for people; this file is.
- Earlier versions of this repo had about 600 lines of bash around Stow: conflict backups, a pre-push hook that validated Hyprland in an isolated home, an rsync step for skills. It all worked and none of it was worth maintaining. The history is there if you want it.
