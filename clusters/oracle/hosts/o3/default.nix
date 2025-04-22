{...}: {
  imports = [
    ./networking
    ./hardware.nix
  ];

  system.stateVersion = "24.11";
}
