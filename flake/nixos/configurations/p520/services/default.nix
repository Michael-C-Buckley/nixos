{
  imports = [
    ./harmonia.nix
    ./postgres.nix
  ];

  services = {
    hydra.enable = true;
  };
}
