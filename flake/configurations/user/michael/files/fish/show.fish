# Passthrough of FRR show command
function show
    sudo vtysh -c "show $argv"
end
