{
  flake.modules.nixos.nebula-main = {
    config,
    lib,
    ...
  }: {
    sops.secrets = {
      "nebula/main/main-ca" = {
        sopsFile = "/etc/secrets/common/common.yaml";
        owner = "nebula-main";
        group = "nebula-main";
        mode = "0640";
      };
      # These two are taken care of by the end-host
      "nebula/main/key" = {
        owner = "nebula-main";
        group = "nebula-main";
        mode = "0640";
      };
      "nebula/main/crt" = {
        owner = "nebula-main";
        group = "nebula-main";
        mode = "0640";
      };
    };

    services.nebula = let
      inherit (config.services.nebula.networks) main;
    in {
      # We'll start with one network and call it main for now
      networks.main = {
        enable = true;
        ca = config.sops.secrets."nebula/main/main-ca".path;
        cert = config.sops.secrets."nebula/main/crt".path;
        key = config.sops.secrets."nebula/main/key".path;

        tun.device = "nebula-main";

        # Include IPv6 as well
        listen.host = lib.mkDefault "[::]";

        settings = {
          static_map.network = lib.mkDefault "ip4";
        };

        staticHostMap = lib.mkIf (!main.isLighthouse) {
          "100.127.0.1" = ["o1.groovyreserve.com:4242"];
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
