let
  dnsDir = "/var/lib/dnscrypt-proxy";
in {
  flake.modules.nixos.dnscrypt-proxy = {
    config,
    lib,
    ...
  }: {
    custom.impermanence.persist.directories = [dnsDir];
    # Move the address as networkd uncontrollably launches resolved
    networking.nameservers = ["127.0.0.153"];

    # Remove for impermanence due to incompatible hard-linking requirements
    systemd.services.dnscrypt-proxy.serviceConfig = lib.mkIf config.custom.impermanence.var.enable {
      DynamicUser = lib.mkForce false;
    };

    services.dnscrypt-proxy = {
      enable = true;
      settings = {
        # Move the default to prevent collisions
        listen_addresses = ["127.0.0.153:53"];

        # Use servers that support DNSCrypt, DOH, and Anonymized DNS
        server_names = [
          "cloudflare"
          "quad9-dnscrypt-ip4-filter-pri"
        ];

        # Enable DNS-over-HTTPS
        doh_servers = true;

        # Require DNSSEC validation
        require_dnssec = true;
        require_nolog = true;
        require_nofilter = false; # Allow filtering servers

        # Caching
        cache = true;
        cache_size = 4096;
        cache_min_ttl = 2400;
        cache_max_ttl = 86400;

        # Public blocklists
        sources.public-resolvers = {
          urls = [
            "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
            "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
          ];
          cache_file = "${dnsDir}/public-resolvers.md";
          minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3"; # typos:ignore-line
          refresh_delay = 72;
        };
      };
    };
  };
}
