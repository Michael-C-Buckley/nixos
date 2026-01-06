{
  # TODO: remove the hardcoded path
  flake.modules.nixos.kube-traefik = {
    services.k3s.manifests = {
      # Use a name other than traefik, as that default name is used by the system
      traefik-base.source = ./configuration.yaml;
    };
  };
}
