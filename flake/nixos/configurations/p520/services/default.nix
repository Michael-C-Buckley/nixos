{
  imports = [
    ./harmonia.nix
    ./nfs.nix
    ./ollama.nix
    ./open-webui.nix
    ./postgres.nix
  ];

  services = {
    hydra.enable = true;
  };
}
