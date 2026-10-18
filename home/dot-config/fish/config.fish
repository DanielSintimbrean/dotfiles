set -g fish_greeting
set -gx VIRTUAL_ENV_DISABLE_PROMPT 1
set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
set -gx MANROFFOPT -c

if test -d "$HOME/.local/bin"
  fish_add_path --global --prepend "$HOME/.local/bin"
end

# Listing aliases share ls's headers, colors, icons, and directory ordering.
alias ls 'eza -lh --group-directories-first --icons=auto'
alias ll ls
alias la 'ls -a'
alias lsa 'ls -a'
alias lsz 'ls -a --total-size'
alias lt 'ls --tree --level=2 --git'
alias lta 'lt -a'
alias ls2 'ls -aT --level=2 --git-ignore'
alias ls3 'ls -aT --level=3 --git-ignore'
alias ls4 'ls -aT --level=4 --git-ignore'
alias ls-full 'ls -aT --git-ignore'
alias l. 'ls -ad .*'

# Basic command aliases.
alias cat 'bat --style=header,snip,changes'

if not type -q yay; and type -q paru
  alias yay paru
end

alias .. 'cd ..'
alias ... 'cd ../..'
alias .... 'cd ../../..'
alias ..... 'cd ../../../..'
alias ...... 'cd ../../../../..'

alias nv nvim
alias lg lazygit
alias tmux-dev 'tmux -u new -A -s dev'
alias td 'tmux -u new -A -s dev'
alias clera clear
alias claer clear
alias ze 'zeditor .'
alias clipboard wl-copy

function pls
    if test -z "$argv"
        eval command sudo $history[1]
    else
        command sudo $argv
    end
end

function history
  builtin history --show-time='%F %T '
end

function backup --argument filename
  cp "$filename" "$filename.bak"
end

function last_history_item
  echo $history[1]
end

function last_history_token
  echo $history[1] | read -t -a tokens
  echo $tokens[-1]
end

abbr --add !! --position anywhere --function last_history_item
abbr --add '!$' --position anywhere --function last_history_token

if status is-interactive
  fish_vi_key_bindings
  set -gx FZF_DEFAULT_OPTS '--cycle --layout=reverse --border --height=90% --preview-window=wrap --marker="*"'

  if type -q starship
    starship init fish | source
  end

  if type -q fzf
    fzf --fish | source
  end

  if type -q zoxide
    zoxide init fish | source
  end
end

# Load per-project environment variables.
if type -q direnv
  direnv hook fish | source
end
