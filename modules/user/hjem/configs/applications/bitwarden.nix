{
  flake.hjemConfigs.bitwarden = {pkgs, ...}: {
    hjem.users.michael = {
      packages = with pkgs; [
        bitwarden-desktop
        bitwarden-cli
      ];

      impermanence = {
        persist.directories = [".config/bitwarden"];
        cache.directories = [".cache/com.bitwarden.desktop"];
      };
    };
  };
}
