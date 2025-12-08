{
  flake.modules.nixos.b550 = {config, ...}: {
    sops = {
      secrets = {
        "k3s/cloudflare" = {};
        atticEnv = {
          sopsFile = "/etc/secrets/hosts/p520/attic.sops";
          format = "binary";
        };
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

        k3s-attic-secret.content = ''
          apiVersion: v1
          kind: Secret
          metadata:
            name: attic-secrets
            namespace: attic
          type: Opaque
          stringData:
            atticEnv: ${config.sops.placeholder.atticEnv}
        '';
      };
    };
  };
}
