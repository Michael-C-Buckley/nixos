{
  flake.hjemConfigs.novelwriter = {
    config,
    pkgs,
    lib,
    ...
  }: {
    hjem.users.michael = {
      packages = [pkgs.novelwriter];

      impermanence = {
        persist.directories = lib.optionals config.custom.impermanence.home.enable [
          ".config/novelwriter"
          ".local/share/novelwriter"
        ];
        cache.directories = [".cache/novelwriter"];
      };
    };
  };
}
