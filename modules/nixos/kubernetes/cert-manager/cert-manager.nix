{
  flake.modules.nixos.kube-cert-manager = {config, ...}: {
    sops = {
      secrets = {
        "k3s/cloudflare" = {};
      };

      templates = {
        k3s-cloudflare-secret.content = ''
          apiVersion: v1
          kind: Secret
          metadata:
            name: cloudflare-api-token-secret
            namespace: cert-manager
          type: Opaque
          stringData:
            api-token: ${config.sops.placeholder."k3s/cloudflare"}
        '';
      };
    };

    services.k3s.manifests = {
      cert-manager.source = ./cert-manager.yaml;
      cloudflare.source = config.sops.templates.k3s-cloudflare-secret.path;
      lets-encrypt.source = ./lets-encrypt.yaml;
    };
  };
}
