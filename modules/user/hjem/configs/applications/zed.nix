# Include my Zed plus the persisted directories
{config, ...}: {
  flake.hjemConfigs.zed = {pkgs, ...}: {
    hjem.users.michael = {
      packages = [config.flake.packages.${pkgs.stdenv.hostPlatform.system}.zeditor];

      impermanence = {
        persist.directories = [
          ".config/zed"
          ".local/share/zed"
        ];
        cache.directories = [".cache/zed"];
      };
    };
  };
}
