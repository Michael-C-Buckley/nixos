# T14 Laptop Configuration
{inputs, ...}: {
  system.stateVersion = "24.11";

  imports = [
    inputs.nix-secrets.nixosModules.t14
    ./hardware
    ./networking
    ./systemd
    ./hjem.nix
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
