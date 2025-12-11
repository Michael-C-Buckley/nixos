{
  flake.modules.nixos.b550 = {config, ...}: {
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
  };
}
