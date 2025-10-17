# Include my Zed plus the persisted directories
{self, ...}: {
  flake.modules.nixos.zed = {pkgs, ...}: {
    environment.systemPackages = [self.packages.${pkgs.system}.zeditor];

    custom.impermanence = {
      persist.user.directories = [".config/zed"];
      cache.user.directories = [".cache/zed"];
    };
  };
}
