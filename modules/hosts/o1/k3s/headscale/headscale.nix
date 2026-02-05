{
  flake.modules.nixos.o1 = {config, ...}: {
    sops = {
      secrets = {
        "headscale/derp_key" = {};
        "headscale/noise_key" = {};
        "headscale/acl" = {};
      };

      templates.headscale-secrets.content =
        # yaml
        ''
          ---
          apiVersion: v1
          kind: Secret
          metadata:
            name: headscale-secrets
            namespace: headscale
          type: Opaque
          stringData:
            noise_key: "${config.sops.placeholder."headscale/noise_key"}"
            derp_key: "${config.sops.placeholder."headscale/derp_key"}"
            acl.hujson: "${config.sops.placeholder."headscale/acl"}"
        '';
    };

    services.k3s.manifests = {
      headscale-secrets.source = config.sops.templates.headscale-secrets.path;
    };
  };
}
