set -g fish_greeting
set -gx VIRTUAL_ENV_DISABLE_PROMPT 1
set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
set -gx MANROFFOPT -c

if test -d "$HOME/.local/bin"
  fish_add_path --global --prepend "$HOME/.local/bin"
end

# Basic command aliases.
alias ls 'eza -al --color=always --group-directories-first --icons=always'
alias lsz 'eza -al --color=always --total-size --group-directories-first --icons=always'
alias la 'eza -a --color=always --group-directories-first --icons=always'
alias ll 'eza -l --color=always --group-directories-first --icons=always'
alias lt 'eza -aT --color=always --group-directories-first --icons=always --git-ignore'
alias lt2 'eza --level 2 -aT --color=always --group-directories-first --icons=always --git-ignore'
alias lt3 'eza --level 4 -aT --color=always --group-directories-first --icons=always'
alias l. 'eza -ald --color=always --group-directories-first --icons=always .*'
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
