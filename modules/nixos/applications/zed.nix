# Include my Zed plus the persisted directories
{config, ...}: {
  flake.modules.nixos.app-zed = {pkgs, ...}: {
    hjem.users.michael.packages = [config.flake.packages.${pkgs.stdenv.hostPlatform.system}.zeditor];

    custom.impermanence = {
      persist.user.directories = [
        ".config/zed"
        ".local/share/zed"
      ];
      cache.user.directories = [
        ".cache/zed"
      ];
    };
  };
}
