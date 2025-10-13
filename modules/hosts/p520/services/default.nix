{inputs, ...}: {
  flake.modules.nixos.p520 = {config, ...}: {
    imports = with inputs.self.nixosModules; [
      hydra
    ];

    environment.persistence."/cache".directories = [
      "/var/cache/harmonia"
    ];

    services = {
      hydra.enable = true;
      harmonia = {
        enable = true;
        signKeyPaths = [config.sops.secrets.cachePrivateKey.path];
      };
    };
  };
}
