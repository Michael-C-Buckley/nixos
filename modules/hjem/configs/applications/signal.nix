{
  flake.hjemConfigs.signal = {
    config,
    pkgs,
    lib,
    ...
  }: {
    hjem.users.michael = {
      packages = [pkgs.signal-desktop];

      impermanence = {
        persist.directories = lib.optionals config.custom.impermanence.home.enable [".config/Signal"];
      };
    };
  };
}
