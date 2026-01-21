# Helix does not support language in the default config, so I've chosen to not
# wrap the config and instead use smfh, of which keep mutable with initial state
{config, ...}: let
  inherit (config.flake) wrappers packages;
in {
  flake.hjemConfigs.helix = {pkgs, ...}: {
    hjem.users.michael = {
      packages = [packages.${pkgs.stdenv.hostPlatform.system}.helix];

      files = {
        ".config/helix/languages.toml" = {
          type = "copy";
          permissions = "0644";
          source = pkgs.writers.writeTOML "helix-languages" (wrappers.mkHelixLanguages {inherit pkgs;});
        };

        ".config/helix/config.toml" = {
          type = "copy";
          permissions = "0644";
          source = wrappers.mkHelixConfig {inherit pkgs;};
        };
      };
    };
  };
}
