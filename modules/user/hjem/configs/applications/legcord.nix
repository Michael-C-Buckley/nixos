{
  flake.hjemConfigs.legcord = {pkgs, ...}: {
    hjem.users.michael = {
      packages = [pkgs.legcord];

      impermanence = {
        persist.directories = [".config/legcord"];
        cache.directories = [".config/legcord/cache"];
      };
    };
  };
}
