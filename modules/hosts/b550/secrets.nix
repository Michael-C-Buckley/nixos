{
  flake.modules.nixos.b550 = {
    sops = {
      defaultSopsFile = "/etc/secrets/hosts/b550/b550.yaml";
      secrets = {
        cachePrivateKey = {};
      };
    };
  };
}
