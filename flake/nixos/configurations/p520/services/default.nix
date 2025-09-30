{
  imports = [
    ./harmonia.nix
    ./nfs.nix
    ./ollama.nix
    ./postgres.nix
  ];

  services = {
    hydra.enable = true;
  };
}
