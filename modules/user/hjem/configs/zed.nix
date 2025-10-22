# Include my Zed plus the persisted directories
{self, ...}: {
  flake.modules.nixos.hjem-zed = {pkgs, ...}: {
    environment.systemPackages = [self.packages.${pkgs.system}.zeditor];

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
