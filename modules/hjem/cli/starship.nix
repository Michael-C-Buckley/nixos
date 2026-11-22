{ configPaths, ... }:
{
  imports = [ ../runtime.nix ];

  xdg.config.files."starship.toml".source = configPaths.starship + "/default.toml";
}
