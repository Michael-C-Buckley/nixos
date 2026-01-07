{config, ...}: let
  inherit (config) flake;
in {
  flake.modules.nixos.o1 = {
    imports = with flake.modules.nixos; [
      k3s
      kube-cert-manager
      kube-traefik
    ];

    services.k3s.custom.certificate = let
      name = "wildcard-groovyreserve-com";
    in {
      metadata = {inherit name;};
      spec = {
        secretName = name;
        commonName = "*.groovyreserve.com";
        dnsNames = [
          "*.cs.groovyreserve.com"
          "*.o1.groovyreserve.com"
          "*.groovyreserve.com"
        ];
      };
    };
  };
}
