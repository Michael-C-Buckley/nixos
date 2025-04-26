# X570 Desktop Configuration
{inputs, ...}: {
  imports = [
    inputs.nix-secrets.nixosModules.x570
    inputs.nix-index-database.nixosModules.nix-index
    ./hardware
    ./networking
    ./hjem.nix
  ];

  system.stateVersion = "24.05";

  programs = {
    hyprland.enable = true;
    cosmic.enable = false;
    nix-index-database.comma.enable = true;
  };

  features = {
    michael.nvf.package = "default";
    displayManager = "greetd";
    gaming.enable = true;
  };

  virtualisation = {
    incus.enable = true;
    libvirtd.enable = true;
    gns3.enable = true;
  };
  system.zfs.enable = true;
}
