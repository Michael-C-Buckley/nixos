{
  flake.hjemConfigs.element = {
    config,
    pkgs,
    lib,
    ...
  }: {
    hjem.users.michael = {
      packages = [pkgs.element-desktop];

      impermanence = {
        persist.directories = lib.optionals config.custom.impermanence.home.enable [
          ".config/Element"
          ".local/share/Element"
        ];
      };
    };
  };
}
