# FRR show command
function show
    sudo vtysh -c "show (string join ' ' $argv)"
end
