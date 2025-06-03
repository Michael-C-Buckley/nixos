{...}: {
  imports = [
    ./networking
    ./hardware.nix
  ];

  system.stateVersion = "23.11";
}
