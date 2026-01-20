{config, ...}: let
  inherit (config.flake) wrappers packages;
in {
  flake.modules.homeManager.helix = {pkgs, ...}: {
    home = {
      packages = [packages.${pkgs.stdenv.hostPlatform.system}.helix];

      file = {
        ".config/helix/languages.toml" = {
          source = pkgs.writers.writeTOML "helix-languages" (wrappers.mkHelixLanguages {inherit pkgs;});
        };

        ".config/helix/config.toml" = {
          source = wrappers.mkHelixConfig {inherit pkgs;};
        };
      };
    };
  };
}
