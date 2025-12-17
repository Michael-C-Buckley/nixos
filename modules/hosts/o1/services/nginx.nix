{
  flake.modules.nixos.o1 = {
    config,
    pkgs,
    ...
  }: {
    networking.firewall.allowedTCPPorts = [80 443];

    environment.systemPackages = [pkgs.nginx];

    services.nginx = {
      enable = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      virtualHosts."attic.groovyreserve.com" = {
        forceSSL = true;
        useACMEHost = "groovyreserve.com";

        locations."/" = {
          proxyPass = "http://localhost:${toString config.custom.attic.listenPort}";
        };
      };
    };
  };
}
