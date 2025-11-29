let
  wgSecret = name: {
    sopsFile = "/etc/secrets/wireguard/${name}.sops";
    format = "binary";
  };
in {
  flake.modules.nixos.t14 = {
    sops.secrets = builtins.listToAttrs (map (n: {
        name = "wireguard-${n}";
        value = wgSecret n;
      })
      ["mt1" "mt1v6" "mt3" "mt4" "o1" "k1"]);
  };
}
