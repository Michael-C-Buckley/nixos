{
  imports = [
    ./hardware.nix
    ./filesystems.nix
    ./network.nix
  ];
  system.stateVersion = "26.11";
}
