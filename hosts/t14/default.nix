# T14 Laptop Configuration
{
  inputs,
  pkgs,
  ...
}: {
  system.stateVersion = "24.11";

  imports = [
    inputs.nix-secrets.nixosModules.t14
    inputs.nix-index-database.nixosModules.nix-index
    ./hardware
    ./networking
    ./systemd
    ./hjem.nix
  ];

  environment.systemPackages = [pkgs.brightnessctl];

  programs = {
    cosmic.enable = true;
    hyprland.enable = true;
    nix-index-database.comma.enable = true;
  };

  features = {
    displayManager = "ly";
    gaming.enable = false;
  };

  virtualisation = {
    libvirtd.enable = true;
    gns3.enable = true;
  };
  
  system.zfs = {
    enable = true;
    encryption = true;
  };
}
