{config, ...}: {
  flake.modules.nixos.michael = {pkgs, ...}: let
    inherit (pkgs.stdenv.hostPlatform) system;
    inherit (config.flake.packages.${system}) fish starship;
  in {
    users.users.michael = {
      shell = fish;
      packages = [
        # TODO: workaround since NixOS modifies the wrapped fish and moves the starship path
        # Re-adding my wrapper explicitly, fixes it
        starship
      ];
    };
  };
}
