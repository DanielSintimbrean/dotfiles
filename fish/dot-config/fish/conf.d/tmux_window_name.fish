function update_tmux_window_name --on-event fish_prompt
    if set -q TMUX
        set -l toplevel (git rev-parse --show-toplevel 2>/dev/null)
        if test $status -eq 0
            set -l repo (basename $toplevel)
            set -l branch (git branch --show-current 2>/dev/null)
            if test -n "$branch"
                tmux rename-window " $repo ($branch)"
            else
                tmux rename-window " $repo"
            end
        else
            # Not a git repo - show shortened path
            tmux rename-window (prompt_pwd)
        end
    end
end
