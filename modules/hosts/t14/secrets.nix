let
  wgSecret = name: {
    sopsFile = "/etc/secrets/hosts/t14/wireguard/${name}.sops";
    format = "binary";
  };
in {
  flake.modules.nixos.t14 = {
    sops = {
      defaultSopsFile = "/etc/secrets/hosts/t14/t14.yaml";
      secrets = builtins.listToAttrs (map (n: {
          name = "wireguard-${n}";
          value = wgSecret n;
        })
        ["mt1" "mt3" "mt4" "o1"]);
    };
  };
}
