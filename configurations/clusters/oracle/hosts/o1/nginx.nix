{config, ...}: let
  nixServe = config.services.nix-serve;
in {
  # Test deployment
  services.nginx = {
    enable = true;

    virtualHosts."nix-cache.groovyreserve.com" = {
      locations."/" = {
        proxyPass = "http://${nixServe.bindAddress}:${builtins.toString nixServe.port}";
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

      sslTrustedCertificate = "/etc/certs/michael.crt.pem";

      extraConfig = ''
        ssl_client_certificate  /etc/certs/michael.crt.pem;
        ssl_verify_client       optional;
        ssl_verify_depth        2;
      '';

      root = "/var/www/home";
      locations."/" = {
        index = "index.html";
      };
      locations."/vaultwarden" = {
        index = "vaultwarden.html";
        extraConfig = ''
          if ($ssl_client_verify != SUCCESS) { return 403; }
        '';
      };
    };
  };

  networking.firewall.allowedTCPPorts = [80 443];

  systemd.tmpfiles.rules = [
    "d /var/www/home 0755 root root"
    "f /var/www/home/index.html 0644 root root - <html><body><h1>Welcome to groovyreserve.com.  This is only a test.</h1></body></html>"
    "f /var/www/home/vaultwarden.html 0644 root root - <html><body><h1>Welcome to groovyreserve.com/vaultwarden.  This is only a test.</h1></body></html>"
  ];
}
