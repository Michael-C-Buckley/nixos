{
  flake.modules.nixos.app-bitwarden = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      bitwarden
      bitwarden-cli
    ];

    custom.impermanence = {
      persist.user.directories = [".config/bitwarden"];
      cache.user.directories = [".cache/com.bitwarden.desktop"];
    };
  };
}
