{
  flake.modules.nixos.uff = {
    sops = {
      defaultSopsFile = "/etc/secrets/clusters/uff/uff.yaml";
      secrets = {
        k3s_token = {};
        cachePrivateKey = {};
      };
    };
  };
}
