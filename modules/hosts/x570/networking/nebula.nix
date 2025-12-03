{config, ...}: let
  inherit (config) flake;
in {
  flake.modules.nixos.x570 = {
    imports = [
      flake.modules.nixos.nebula-main
    ];
    # No additional settings needed for now
  };
}
