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

  # Experimental Nix Serve
  services.nix-serve.enable = true;

  programs = {
    hyprland.enable = true;
    cosmic.enable = true;
    nix-index-database.comma.enable = true;
  };

  features = {
    displayManager = "greetd";
    gaming.enable = true;
  };

  virtualisation = {
    libvirtd.enable = true;
    gns3.enable = true;
  };
  system.zfs.enable = true;
}
