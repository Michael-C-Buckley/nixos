# Use FZF to navigate to a folder matching folders or filenames
function fcd
    set -l selected_path (find . | fzf --height 40% --reverse)

    if test -n "$selected_path"
        if test -d "$selected_path"
            cd "$selected_path"
        else
            cd (dirname "$selected_path")
        end
    end
end
