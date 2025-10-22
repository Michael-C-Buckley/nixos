{
  flake.modules.nixos.app-legcord = {pkgs, ...}: {
    environment.systemPackages = [pkgs.legcord];

    custom.impermanence = {
      persist.user.directories = [".config/legcord"];
      cache.user.directories = [".config/legcord/cache"];
    };
  };
}
