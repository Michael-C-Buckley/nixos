{
  flake.modules.nixos.o1 = {
    services.k3s.manifests = {
      vaultwarden.source = ./vaultwarden.yaml;
    };
  };
}
