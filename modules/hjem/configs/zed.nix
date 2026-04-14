# Zed really does need a writable config
# Also, MacOS has trouble with GUI wrappers so just put the deps into the user path
{
  config,
  lib,
  ...
}: let
  inherit (config.flake.custom) wrappers;
  flakePackages = config.flake.packages;
in {
  flake.custom.hjemConfigs.zed = {
    pkgs,
    config,
    ...
  }: let
    inherit (pkgs.stdenv.hostPlatform) system;
  in {
    hjem.users.${config.custom.hjem.username} = {
      packages = lib.optionals (lib.hasSuffix "darwin" system) [flakePackages.${system}.zedPkgs];
      xdg.config.files."zed/settings.json" = {
        source = wrappers.mkZedConfig {inherit pkgs;};
        type = "copy";
        permissions = "0644";
      };
    };
  };
}
