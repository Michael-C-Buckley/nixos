{config, ...}: let
  inherit (config.flake.wrappers) mkNiri;
in {
  flake.modules.nixos.niri = {
    config,
    pkgs,
    ...
  }: {
    custom.noctalia.parent = "niri.service";
    programs.niri = {
      enable = true;
      package = mkNiri {
        inherit pkgs;
        inherit (config.custom.niri) extraConfig;
        spawnNoctalia = false;
      };
      useNautilus = false;
    };
  };
}
