{
  flake.hjemConfigs.legcord = {
    config,
    pkgs,
    lib,
    ...
  }: {
    hjem.users.michael = {
      packages = [pkgs.legcord];

      impermanence = {
        persist.directories = lib.optionals config.custom.impermanence.home.enable [".config/legcord"];
        cache.directories = [".config/legcord/cache"];
      };
    };
  };
}
