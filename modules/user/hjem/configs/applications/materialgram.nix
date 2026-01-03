{
  flake.hjemConfigs.materialgram = {
    config,
    pkgs,
    lib,
    ...
  }: {
    hjem.users.michael = {
      packages = [pkgs.materialgram];

      impermanence = {
        persist.directories = lib.optionals config.custom.impermanence.home.enable [".local/share/materialgram"];
        # cache.directories = [];
      };
    };
  };
}
