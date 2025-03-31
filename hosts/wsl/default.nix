{inputs, ...}: {
  imports = [
    inputs.nixos-wsl.nixosModules.default
    ./wsl.nix
  ];

  custom = {
    zfs.enable = false;
    virtualisation.libvirt.enable = false;
  };

  # Trying out Zed via WSLg
  features.michael.packages.zed.include = true;

  networking = {
    hostName = "wsl";
    nameservers = ["1.1.1.1" "8.8.8.8" "9.9.9.9"];
  };

  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "24.11";
}
