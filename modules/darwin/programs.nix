{config, ...}: let
  inherit (config) flake;
in {
  flake.modules.darwin.default = {pkgs, ...}: let
    inherit (flake.package.${pkgs.stdenv.hostPlatform.system}) fish;
  in {
    programs = {
      direnv.enable = true;

      # Use my wrapped shell but also get the nix-darwin completions
      fish = {
        enable = true;
        package = fish;
      };
    };
  };
}
