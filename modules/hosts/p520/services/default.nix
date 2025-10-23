{config, ...}: let
  inherit (config.flake.modules.nixos) hydra;
in {
  flake.modules.nixos.p520 = {config, ...}: {
    imports = [
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
