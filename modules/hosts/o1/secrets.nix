let
  wgSecret = name: {
    sopsFile = "/etc/secrets/hosts/o1/wireguard/${name}.sops";
    format = "binary";
  };
in {
  flake.modules.nixos.o1 = {
    sops = {
      defaultSopsFile = "/etc/secrets/hosts/o1/o1.yaml";
      secrets =
        {
          attic = {
            sopsFile = "/etc/secrets/hosts/o1/attic.sops";
            format = "binary";
          };
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
