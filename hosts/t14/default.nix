# T14 Laptop Configuration

{inputs, ...}: let 
  inherit (inputs.nixos-modules.nixosModules) libvirt gns3;
  inherit (inputs.nix-secrets.nixosModules) t14;
in {
  system.stateVersion = "24.11";

  imports = [
    gns3
    libvirt
    t14
    ./hardware
    ./networking
    ./systemd
  ];

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
