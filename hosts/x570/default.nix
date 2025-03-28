# X570 Desktop Configuration

{inputs, ...}: let
  inherit (inputs.nixos-modules.nixosModules) gns3 libvirt;
in {
  imports = [
    inputs.nix-secrets.nixosModules.x570
    gns3
    libvirt
    ./hardware
    ./networking
  ];

  system.stateVersion = "24.05";

  features = {
    autoLogin = true; # Only if not on Ly
    displayManager = "ly";
    cosmic = true;
    gaming = true;
  };

  custom.virtualisation = {
    gns3.enable = true;
    libvirt.users = ["michael" "root"];
  };
}
