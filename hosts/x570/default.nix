# X570 Desktop Configuration
{inputs, pkgs, ...}: {
  imports = [
    inputs.nix-secrets.nixosModules.x570
    ./hardware
    ./networking
    ./hjem.nix
  ];

  system.stateVersion = "24.05";

  # Experimental Nix Serve
  services.nix-serve = {
    enable = true;
    package = pkgs.nix-serve-ng;
    openFirewall = true;
    port = 5000;
    secretKeyFile = "/etc/nix/nix-serve/secret-key.pem";
  };

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
