{
  flake.modules.nixos.uff1 = {
    services.k3s = {
      # UFF1 will spawn a cluster if it doesn't exist
      clusterInit = true;
    };
  };
}
