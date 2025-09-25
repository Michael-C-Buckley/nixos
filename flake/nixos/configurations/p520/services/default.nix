{
  imports = [
    ./harmonia.nix
    ./nfs.nix
    ./postgres.nix
  ];

  services = {
    hydra.enable = true;
  };
}
