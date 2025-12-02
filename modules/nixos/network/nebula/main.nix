{
  flake.modules.nixos.nebula-main = {lib, ...}: {
    services.nebula = {
      enable = true;
      # We'll start with one network and call it main for now
      networks.main = {
        # Sops-nix will deploy the files
        ca = "/run/secrets/nebula-main-ca.crt";
        cert = "/run/secrets/nebula-main-cert.crt";
        key = "/run/secrets/nebula-main-key.key";

        tun.device = "nebula-main";

        # Include IPv6 as well
        listen.host = lib.mkDefault "[::]";

        settings = {
          static_map.network = lib.mkDefault "ip4";
        };

        # Allow all traffic for now
        firewall = {
          inbound = [
            {
              host = "any";
              port = "any";
              proto = "any";
            }
          ];
          outbound = [
            {
              host = "any";
              port = "any";
              proto = "any";
            }
          ];
        };
      };
    };
  };
}
