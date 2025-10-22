{self, ...}: {
  flake.modules.nixos.app-helium = {pkgs, ...}: {
    hjem.users.michael.packages = [self.packages.${pkgs.system}.helium];

    custom.impermanence = {
      persist.user.directories = [".config/net.imput.helium"];
      cache.user.directories = [".cache/net.imput.helium"];
    };
  };
}
