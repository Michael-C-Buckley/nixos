# Geometry project lives in this directory as it does not function properly in the nix-store
GEOMETRY_DIR="$HOME/.config/resources/geometry"

# Get Geometry if needed
if [ ! -d "$GEOMETRY_DIR" ]; then
  git clone https://github.com/geometry-zsh/geometry.git "$GEOMETRY_DIR" || {
    echo "Failed to clone geometry-zsh. Falling back to default shell settings."
    return
  }
fi

# Apply it
if [ -f "$GEOMETRY_DIR/geometry.zsh" ]; then
  source "$GEOMETRY_DIR/geometry.zsh"
else
  echo "geometry.zsh not found in $GEOMETRY_DIR. Check the installation."
  return
fi

# -----------------------------
# Geometry Zsh Prompt
# -----------------------------

# WIP
