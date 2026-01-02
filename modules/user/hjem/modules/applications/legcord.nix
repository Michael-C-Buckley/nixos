{
  flake.hjemModules.legcord = {pkgs, ...}: {
    packages = [pkgs.legcord];

    impermanence = {
      persist.directories = [".config/legcord"];
      cache.directories = [".config/legcord/cache"];
    };
  };
}
