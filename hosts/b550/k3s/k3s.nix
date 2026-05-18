# Nix-related elements for K3s
{config, ...}: let
  inherit (config) flake;
in {
  flake.modules.nixos.b550 = {functions, ...}: let
    inherit (functions.kube) buildManifest;
  in {
    imports = with flake.modules.nixos; [
      k3s
      kube-cert-manager
      kube-traefik
    ];

    custom.impermanence = {
      persist.directories = [
        "/var/lib/forgejo"
        "/var/lib/openwebui"
      ];
    };

    services.k3s = {
      custom = {
        traefik = {
          defaultCert = "wildcard-groovyreserve-com";
          ports = {
            web.port = 80;
            websecure.port = 443;
          };
        };
        certificate = let
          name = "wildcard-groovyreserve-com";
        in {
          metadata = {inherit name;};
          spec = {
            secretName = name;
            commonName = "*.groovyreserve.com";
            dnsNames = [
              "*.cs.groovyreserve.com"
              "*.groovyreserve.com"
            ];
          };
        };
      };
      manifests = {
        open-webui.source = buildManifest ./open-webui;
        forgejo.source = buildManifest ./forgejo;
      };
    };
  };
}
