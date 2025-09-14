{config, ...}: {
  services.harmonia = {
    enable = true;
    signKeyPaths = [config.sops.secrets.cachePrivateKey.path];
  };
}
