# Repository instructions

Personal overrides on top of Omarchy Quattro. Omarchy owns the defaults in
`/usr/share/omarchy/` and stays untouched; this repository holds only what
differs. `install` is the whole setup and reads as its own documentation.

## Adding a configuration file

`home/` is a single GNU Stow package linked into `~` with `--dotfiles`, so
`home/dot-config/foo/bar` becomes `~/.config/foo/bar`.

1. If the file already exists in `~` (Omarchy default or app-generated), move
   it into the mirrored `home/dot-...` path; otherwise create it there.
2. When it replaces a file Omarchy ships under `/usr/share/omarchy/config/`,
   add its `~` path to the `rm -rf` list in `install`.
3. Run `stow --dotfiles -t ~ home`.
4. Add any state the app writes next to the link to `.gitignore` with its full
   `home/...` path.

Done when `readlink -f ~/<path>` resolves inside this repository and
`git status` shows only the intended files.

## Adding an agent skill

Create `skills/<name>/SKILL.md`, then run the skills loop from `install`.
Stow links each skill as a directory symlink; agents fail to detect a skill
whose `SKILL.md` is itself a symlink, so remove any real directory with the
same name in the target before linking.

## Hyprland

After editing `home/dot-config/hypr/`, run `hyprctl reload && hyprctl
configerrors`. Empty output means valid. Machine-specific values live only in
`monitors.lua`, keyed by hostname and product name.

## Ghostty

`omarchy font set` runs `sed -i` on `~/.config/ghostty/config`, which turns
the link into a regular file. Restore it with `stow -R --dotfiles -t ~ home`
after checking the diff.
