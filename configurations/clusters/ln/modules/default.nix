{...}: {
  imports = [
    ./filesystems.nix
    ./kubernetes
    ./hardware.nix
  ];

  system = {
    stateVersion = "25.11";
    impermanence.enable = true;
  };


  virtualisation = {
    incus.enable = true;
  };
}
