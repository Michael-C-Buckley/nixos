# T14 Laptop Configuration
{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.nix-secrets.nixosModules.t14
    inputs.nix-index-database.nixosModules.nix-index
    ./hardware
    ./networking
    ./systemd
    ./hyprland.nix
  ];

  programs = {
    cosmic.enable = true;
    hyprland.enable = true;
    nix-index-database.comma.enable = true;
  };

  environment.systemPackages = with pkgs; [
    brightnessctl
    talosctl
    devenv
  ];

  features = {
    michael = {
      extendedGraphical = true;
      waybar.enable = true;
      hyprland.enable = true;
      nvf.package = "default";
    };
    autoLogin = true;
    displayManager = "greetd";
    gaming.enable = false;
    pkgs.fonts = true;
  };

  virtualisation = {
    docker.enable = true;
    incus.enable = true;
  };

  # hjem.users.michael = {
  #   apps.vscode.enable = true;
  # };

  system = {
    preset = "laptop";
    stateVersion = "24.11";
    impermanence.enable = true;
    zfs = {
      enable = true;
      encryption = true;
    };
  };
}
