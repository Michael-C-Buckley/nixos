{
  flake.modules.nixos.x570 = let
    wgSecret = name: {
      sopsFile = "/etc/secrets/hosts/x570/wireguard/${name}.sops";
      format = "binary";
    };
  in {
    sops = {
      defaultSopsFile = "/etc/secrets/hosts/x570/x570.yaml";
      # Wireguards - stored as separate binary files for convenience
      secrets = builtins.listToAttrs (map (n: {
        name = "wireguard-${n}";
        value = wgSecret n;
      }) ["mt1" "mt4"]);
    };
  };
}
