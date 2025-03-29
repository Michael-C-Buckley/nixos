# X570 Desktop Configuration
{inputs, ...}: {
  imports = [
    inputs.nix-secrets.nixosModules.x570
    ./hardware
    ./networking
    ./hjem.nix
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
