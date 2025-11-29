let
  wgSecret = name: {
    sopsFile = "/etc/secrets/wireguard/${name}.sops";
    format = "binary";
  };
in {
  flake.modules.nixos.t14 = {config, ...}: {
    sops = {
      defaultSopsFile = "/etc/secrets/t14.yaml";
      secrets = builtins.listToAttrs (map (n: {
          name = "wireguard-${n}";
          value = wgSecret n;
        })
        ["mt1" "mt1v6" "mt3" "mt4" "o1" "k1"]);
    };
    environment.etc = {
      "wireguard/k1.conf" = {
        source = config.sops.secrets."wireguard-k1".path;
      };
    };
  };
}
