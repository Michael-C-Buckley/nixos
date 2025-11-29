{
  flake.modules.nixos.uff = {
    sops = {
      defaultSopsFile = "/etc/secrets/uff.yaml";
      secrets = {
        k3s_token = {};
        cachePrivateKey = {};
      };
    };
  };
}
