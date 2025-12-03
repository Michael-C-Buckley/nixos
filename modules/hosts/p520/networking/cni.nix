{config, ...}: let
  inherit (config.flake.hosts.p520) interfaces;
in {
  flake.modules.nixos.p520 = {
    environment.etc."cni/net.d/10-bridge.conflist" = {
      mode = "0644";
      text = builtins.toJSON {
        cniVersion = "1.0.0";
        name = "k3s-bridge";
        plugins = [
          {
            type = "bridge";
            bridge = "br1";
            isGateway = true;
            ipMasq = true;
            hairpinMode = true;
            ipam = {
              type = "host-local";
              ranges = [
                [
                  {
                    subnet = "192.168.56.32/27";
                    gateway = interfaces.br1.ipv4;
                  }
                ]
              ];
              routes = [
                {dst = "0.0.0.0/0";}
              ];
            };
          }
          {
            type = "portmap";
            capabilities = {
              portMappings = true;
            };
          }
          {
            type = "firewall";
          }
        ];
      };
    };
  };
}
