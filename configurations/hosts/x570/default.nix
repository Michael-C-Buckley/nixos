{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.nix-secrets.nixosModules.x570
    inputs.nix-index-database.nixosModules.nix-index
    ./hardware
    ./networking
    ./hyprland.nix
    ./k3s.nix
  ];

  system = {
    preset = "desktop";
    stateVersion = "25.05";
    impermanence.enable = true;
    zfs.enable = true;
  };

  environment.systemPackages = with pkgs; [
    talosctl
    devenv
  ];

  programs = {
    hyprland.enable = true;
    cosmic.enable = false; # Currently bugged and won't activate
    nix-index-database.comma.enable = true;
  };

  features = {
    michael = {
      nvf.package = "default";
      extendedGraphical = true;
      vscode.enable = true;
      waybar.enable = true;
      hyprland.enable = true;
    };
    autoLogin = true;
    displayManager = "greetd";
    gaming.enable = true;
    pkgs.fonts = true;
  };

  services = {
    flatpak.enable = true;
    nix-serve.enable = true;
  };

  virtualisation = {
    docker.enable = true;
    incus.enable = true;
    libvirtd.enable = true;
    gns3.enable = true;
  };
}
