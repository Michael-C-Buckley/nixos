{config, ...}: {
  services.harmonia = {
    enable = true;
    signKeyPaths = [config.sops.secrets."cache-private".path];
  };
}
