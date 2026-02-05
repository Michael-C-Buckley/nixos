# Nix-related elements for K3s
{config, ...}: let
  inherit (config) flake;
in {
  flake.modules.nixos.b550 = {flakeLib, ...}: let
    inherit (flakeLib.functions-kube) buildManifest;
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

    networking.firewall.allowedTCPPorts = [
      30222 # Forgejo SSH
      80
      443
    ];

    services.k3s = {
      custom = {
        traefik.defaultCert = "wildcard-groovyreserve-com";
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
