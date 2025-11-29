{
  flake.modules.nixos.x570 = {config, ...}: let
    wgSecret = name: {
      sopsFile = "/etc/secrets/wireguard/${name}.sops";
      format = "binary";
    };
  in {
    sops.secrets =
      {
        cachePrivateKey.sopsFile = "/etc/secrets/x570.yaml";
        pam_u2f_auth.sopsFile = "/etc/secrets/x570.yaml";
      }
      # Wireguards - stored as separate binary files for convenience
      // builtins.listToAttrs (map (n: {
        name = "wireguard-${n}";
        value = wgSecret n;
      }) ["k1" "mt1" "mt4"]);

    environment.etc = {
      "wireguard/k1.conf".source = config.sops.secrets.wireguard-k1.path;
    };
  };
}
