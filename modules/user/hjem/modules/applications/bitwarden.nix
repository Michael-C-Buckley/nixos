{
  flake.hjemModules.bitwarden = {pkgs, ...}: {
    packages = with pkgs; [
      bitwarden-desktop
      bitwarden-cli
    ];

    impermanence = {
      persist.directories = [".config/bitwarden"];
      cache.directories = [".cache/com.bitwarden.desktop"];
    };
  };
}
