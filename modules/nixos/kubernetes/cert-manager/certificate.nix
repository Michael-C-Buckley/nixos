{lib, ...}: {
  flake.modules.nixos.kube-cert-manager = {config, ...}: {
    # Custom namespace for my own options
    options.services.k3s.custom.certificate = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = {};
      description = "Attributes to be converted to yaml for the certificate.";
    };

    config = {
      warnings = lib.mkIf (config.services.k3s.custom.certificate == {}) [
        "services.k3s.custom.certificate.attrs is empty. The certificate manifest may be incomplete."
      ];

      services.k3s.manifests.certificate.content = [
        (lib.recursiveUpdate {
            # Base config I reuse
            apiVersion = "cert-manager.io/v1";
            kind = "Certificate";
            metadata = {
              namespace = "kube-system";
            };
            spec = {
              issuerRef = {
                name = "letsencrypt-prod";
                kind = "ClusterIssuer";
              };
            };
          }
          config.services.k3s.custom.certificate)
      ];
    };
  };
}
