{
  config,
  lib,
  pkgs,
  ...
}:
let
  format = pkgs.formats.toml { };
in
{
  options.custom.umbriel.settings = lib.mkOption {
    inherit (format) type;
    default = { };
    description = "Umbriel settings merged with the shared base TOML.";
  };
  config = {
    custom.umbriel.settings = lib.mapAttrsRecursive (_: lib.mkDefault) (
      builtins.fromTOML (builtins.readFile ../../../configs/umbriel/config.toml)
    );
    xdg.config.files."umbriel/config.toml".source =
      format.generate "umbriel.toml" config.custom.umbriel.settings;
  };
}
