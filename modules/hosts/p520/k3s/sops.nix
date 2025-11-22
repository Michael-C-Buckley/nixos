{
  flake.modules.nixos.p520 = {config, ...}: {
    sops.templates.k3s-cloudflare-secret.content = ''
      apiVersion: v1
      kind: Secret
      metadata:
        name: cloudflare-api-token-secret
        namespace: cert-manager
      type: Opaque
      stringData:
        api-token: ${config.sops.placeholder.k3s-cloudflare-secret}
    '';
  };
}
