# Passthrough of FRR Show commands
show() {
    sudo vtysh -c "show $*"
}


# CD to where FZF finds a matching folder or filename
fcd() {
  # Find all files and directories in the home directory.
  local selected_path
  selected_path=$(find . | fzf --height 40% --reverse)

  # Proceed only if a path was selected.
  if [[ -n "$selected_path" ]]; then
    # Check if the selected path is a directory.
    if [[ -d "$selected_path" ]]; then
      cd "$selected_path"
    else
      # If it's a file, cd to its parent directory using dirname.
      cd "$(dirname "$selected_path")"
    fi
  fi
}
