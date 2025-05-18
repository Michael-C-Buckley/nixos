# T14 minimal, for bootstrapping
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
    hyprland.enable = true;
  };

  environment.systemPackages = with pkgs; [
    brightnessctl
  ];

  features = {
    michael = {
      extendedGraphical = false;
      vscode.enable = false;
      waybar.enable = true;
      hyprland.enable = true;
      nvf.package = "minimal";
    };
    autoLogin = true;
    displayManager = "greetd";
    gaming.enable = false;
    pkgs.fonts = true;
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
