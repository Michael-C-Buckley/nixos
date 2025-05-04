{config, ...}: let 
  nixServe = config.services.nix-serve;
in {
  # Test deployment
  services.nginx = {
    enable = true;

    virtualHosts."nix-cache.groovyreserve.com" = {
      locations."/" = {
        proxyPass = "http://${nixServe.bindAddress}:${nixServe.port}";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
        '';
      };
    };

    virtualHosts."groovyreserve.com" = {
      enableACME = true;
      forceSSL = true;

      root = "/var/www/home";
      locations."/" = {
        index = "index.html";
      };
    };
  };

  networking.firewall.allowedTCPPorts = [80 443];

  systemd.tmpfiles.rules = [
    "d /var/www/home 0755 root root"
    "f /var/www/home/index.html 0644 root root - <html><body><h1>Welcome to groovyreserve.com.  This is only a test.</h1></body></html>"
  ];
}
