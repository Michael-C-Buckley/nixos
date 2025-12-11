{
  flake.modules.nixos.b550 = {config, ...}: {
    sops = {
      secrets = {
        "k3s/cloudflare" = {};
        "k3s/attic" = {};
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
            ATTIC_SERVER_TOKEN_RS256_SECRET_BASE64: ${config.sops.placeholder."k3s/attic"}
        '';
      };
    };
  };
}
