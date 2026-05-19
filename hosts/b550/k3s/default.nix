# Nix-related elements for K3s
{flake, ...}: let
  inherit (flake.functions.kube) buildManifest;
in {
  imports = with flake.nixosModules; [
    k3s
    kube-cert-manager
    kube-certificate
    kube-traefik
  ];

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
}
