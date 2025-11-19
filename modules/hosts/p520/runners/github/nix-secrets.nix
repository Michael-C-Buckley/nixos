# Private runner for my private repo, why waste minutes of CI when a safe, self-hosted
# runner can do it
{
  # TODO: containterize this runner
  flake.modules.nixos.p520 = {config, ...}: {
    services.github-runners.nix-secrets = {
      enable = true;
      url = "https://github.com/Michael-C-Buckley/nix-secrets.git";
      tokenFile = config.sops.secrets.nixSecretsToken.path;
    };
  };
}
