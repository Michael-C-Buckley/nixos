{
  flake.modules.nixos.x570 = {config, ...}: let
    wgSecret = name: {
      sopsFile = "/etc/secrets/hosts/x570/wireguard/${name}.sops";
      format = "binary";
    };
  in {
    sops = {
      defaultSopsFile = "/etc/secrets/hosts/x570/x570.yaml";
      secrets =
        {
          cachePrivateKey = {};
        }
        # Wireguards - stored as separate binary files for convenience
        // builtins.listToAttrs (map (n: {
          name = "wireguard-${n}";
          value = wgSecret n;
        }) ["k1" "mt1" "mt4"]);
    };

    environment.etc = {
      "wireguard/k1.conf".source = config.sops.secrets.wireguard-k1.path;
    };
  };
}
