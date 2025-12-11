{
  flake.modules.nixos.HOST = {config, ...}: {
    sops = {
      secrets."k3s/attic" = {};

      templates.k3s-attic-secret.content = ''
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
}
