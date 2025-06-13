# T14 Laptop Configuration
{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.nix-secrets.nixosModules.t14
    ./hardware
    ./networking
    ./systemd
    ./hyprland.nix
  ];

  programs = {
    cosmic.enable = true;
    hyprland.enable = true;
  };

  environment.systemPackages = with pkgs; [
    brightnessctl
  ];

  features = {
    michael = {
      extendedGraphical = true;
      hyprland.enable = true;
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
