# T14 Laptop Configuration
{
  inputs,
  pkgs,
  ...
}: {
  system.stateVersion = "24.11";

  imports = [
    inputs.nix-secrets.nixosModules.t14
    ./hardware
    ./networking
    ./systemd
    ./hjem.nix
  ];

  environment.systemPackages = [pkgs.brightnessctl];

  programs.hyprland.enable = true;

  features = {
    cosmic = true;
    gaming = false;
  };

  custom = {
    virtualisation = {
      gns3.enable = true;
      libvirt.users = ["michael" "root"];
    };
    zfs.encryption = true;
  };
}
