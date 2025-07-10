# FRR show command
function show
    sudo vtysh -c "show $argv"
end

# CD to the FZF destination
function fcd
    set -l dir (find . -type d | fzf)
    if test -n "$dir"
        cd "$dir"
    end
end
