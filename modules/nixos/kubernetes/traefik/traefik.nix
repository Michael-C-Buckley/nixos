{
  # TODO: remove the hardcoded path
  flake.modules.nixos.kube-traefik = {
    services.k3s.manifests = {
      traefik.source = ./configuration.yaml;
    };
  };
}
