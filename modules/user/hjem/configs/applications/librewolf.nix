{
  flake.hjemConfigs.librewolf = {
    config,
    pkgs,
    lib,
    ...
  }: {
    hjem.users.michael = {
      packages = [pkgs.librewolf];

      impermanence = {
        persist.directories = lib.optionals config.custom.impermanence.home.enable [".librewolf"];
        cache.directories = [".cache/librewolf"];
      };
    };
  };
}
