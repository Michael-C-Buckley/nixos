{config, ...}: {
  flake.modules.homeManager.programs = {pkgs, ...}: {
    programs = {
      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
      fish = {
        enable = true;
        package = config.flake.packages.${pkgs.stdenv.hostPlatform.system}.fish;
      };
    };
  };
}
