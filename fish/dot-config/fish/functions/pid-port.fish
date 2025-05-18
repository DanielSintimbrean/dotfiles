function pid-port
    if test (count $argv) -ne 1
        echo "Usage: pid-port <port>"
        return 1
    end
    sudo ss -lptn "sport = :$argv[1]"
end
