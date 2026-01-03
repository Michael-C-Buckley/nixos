{
  flake.hjemConfigs.bitwarden = {
    config,
    pkgs,
    lib,
    ...
  }: {
    hjem.users.michael = {
      packages = with pkgs; [
        bitwarden-desktop
        bitwarden-cli
      ];

      impermanence = {
        persist.directories = lib.optionals config.custom.impermanence.home.enable [".config/bitwarden"];
        cache.directories = [".cache/com.bitwarden.desktop"];
      };
    };
  };
}
