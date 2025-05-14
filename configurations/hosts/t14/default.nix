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
    cosmic.enable = false;
    hyprland.enable = true;
    nix-index-database.comma.enable = true;
  };

  environment.systemPackages = with pkgs; [
    brightnessctl
    talosctl
  ];

  features = {
    michael = {
      extendedGraphical = true;
      vscode.enable = true;
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
    libvirtd.enable = true;
    gns3.enable = true;
  };

  services.flatpak.enable = true;

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
