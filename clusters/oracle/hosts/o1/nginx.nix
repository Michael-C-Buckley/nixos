{
  # Test deployment
  services.nginx = {
    enable = true;

    virtualHosts."dns.groovyreserve.com" = {
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
    "f /var/www/splash/index.html 0644 root root - <html><body><h1>Welcome to dns.groovyreserve.com</h1></body></html>"
  ];
}
