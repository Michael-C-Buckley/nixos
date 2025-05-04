{
  # Test deployment
  services.nginx = {
    enable = true;

    virtualHosts."nix-cache.groovyreserve.com" = {
      enableACME = true;
      forceSSL = true;

      root = "/var/www/nix-cache-web";
      locations."/" = {
        index = "index.html";
      };

      locations."~ ^/(nix-cache|nix|store|nar|.narinfo|log|cache)/" = {
        proxyPass = "http://127.0.0.1:5000";
        proxyWebsockets = true;
      };
    };

    virtualHosts."groovyreserve.com" = {
      enableACME = true;
      forceSSL = true;

      root = "/var/www/splash";
      locations."/" = {
        index = "index.html";
      };
    };
  };

  networking.firewall.allowedTCPPorts = [80 443];

  systemd.tmpfiles.rules = [
    "d /var/www/splash 0755 root root"
    "f /var/www/splash/index.html 0644 root root - <html><body><h1>Welcome to groovyreserve.com.  This is only a test.</h1></body></html>"
    "d /var/www/nix-cache-web 0755 root root"
    "f /var/www/nix-cache-web/index.html 0644 root root - <html><body><h1>Nix Cache coming soon.</h1></body></html>"
  ];
}
