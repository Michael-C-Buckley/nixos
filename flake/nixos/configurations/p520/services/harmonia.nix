{config, ...}: {
  environment.persistence."/cache".directories = [
    "/var/cache/harmonia"
  ];

  services.harmonia = {
    enable = true;
    signKeyPaths = [config.sops.secrets.cachePrivateKey.path];
  };
}
