# Include my Zed plus the persisted directories
{self, ...}: {
  flake.modules.nixos.app-zed = {pkgs, ...}: {
    hjem.users.michael.packages = [self.packages.${pkgs.system}.zeditor];

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
