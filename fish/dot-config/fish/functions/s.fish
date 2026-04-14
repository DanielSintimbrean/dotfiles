function s --description "Open the sesh project picker"
    if not type -q sesh
        echo "sesh is not installed. Install it with: yay -S sesh-bin" >&2
        return 1
    end

    if test (count $argv) -gt 0
        sesh connect "$argv[1]"
        return $status
    end

    if set -q TMUX
        tmux display-popup -E -h 90% -w 50% -d "#{pane_current_path}" -T "Sesh" "sesh picker -i"
    else
        sesh picker -i
    end
end
