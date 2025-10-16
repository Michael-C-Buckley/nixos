# Single point of contact for mixing in secrets
{
  flake.modules.nixos.secrets = {config, ...}: {
    nix.settings.secret-key-files = [config.sops.secrets.builderKey.path];
  };
}
