{
  flake.hjemConfigs.obsidian = {
    config,
    pkgs,
    lib,
    ...
  }: {
    hjem.users.michael = {
      packages = [pkgs.obsidian];

      impermanence = {
        persist.directories = lib.optionals config.custom.impermanence.home.enable [".config/obsidian"];
        cache.directories = [".config/obsidian/Cache"];
      };
    };
  };
}
