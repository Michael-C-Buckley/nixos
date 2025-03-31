# X570 Desktop Configuration
{inputs, ...}: {
  imports = [
    inputs.nix-secrets.nixosModules.x570
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
  };

  features = {
    autoLogin = true; # Only if not on Ly
    displayManager = "ly";
    gaming.enable = true;
  };

  virtualisation = {
    libvirtd.enable = true;
    gns3.enable = true;
  };
  system.zfs.enable = true;
}
