{config, ...}: let
  inherit (config) flake;
in {
  flake.modules.nixos.o1 = {
    imports = with flake.modules.nixos; [
      k3s
      kube-cert-manager
      kube-traefik
    ];
    sops.secrets."k3s/whitelist" = {};

    services = {
      # Kube ingress owns 22
      openssh.ports = [2222];
      k3s.custom = {
        traefik = {
          defaultCert = "wildcard-groovyreserve-com";
          ports = {
            ssh.port = 22;
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
              "*.o1.groovyreserve.com"
              "*.groovyreserve.com"
            ];
          };
        };
      };
    };
  };
}
