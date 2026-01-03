{
  flake.hjemConfigs.qutebrowser = {
    config,
    pkgs,
    lib,
    ...
  }: {
    hjem.users.michael = {
      packages = [pkgs.qutebrowser];

      impermanence = {
        persist.directories = lib.optionals config.custom.impermanence.home.enable [
          ".config/qutebrowser"
          ".local/share/qutebrowser"
        ];
        cache.directories = [".cache/qutebrowser"];
      };
    };
  };
}
