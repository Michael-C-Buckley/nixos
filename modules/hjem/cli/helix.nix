# Helix does not do as well with wrapping because you can only
# pass a config wrapping and not other files
# Manipulating XDG in the wrapper works but has negeative side-effects
# since it affects all downstream things like LSPs
{ configPaths, pkgs, ... }: {
  # Instead, put the items on my user's path
  packages = with pkgs; [
    localHelix
    # Integration Tooling
    lazygit
    scooter
    yazi
    # Language Tooling
    zuban
    ruff
    nil
    nixfmt
  ];

  # Link the files "traditionally"
  xdg.config.files = {
    "helix/config.toml".source = configPaths.helix + "/config.toml";
    "helix/languages.toml".source = configPaths.helix + "/languages.toml";
  };
}
