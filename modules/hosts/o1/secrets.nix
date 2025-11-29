let
  wgSecret = name: {
    sopsFile = "/etc/secrets/wireguard/${name}.sops";
    format = "binary";
  };
in {
  flake.modules.nixos.o1 = {
    sops = {
      defaultSopsFile = "/etc/secrets/o1.yaml";
      secrets =
        {
          cachePrivateKey = {};
          groovyreserveToken = {};
        }
        // builtins.listToAttrs (map (n: {
            name = "wireguard-${n}";
            value = wgSecret n;
          })
          ["mt1" "clients"]);
    };
  };
}
