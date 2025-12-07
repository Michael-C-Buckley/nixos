# First attempt at a private Forgejo runner for this project
# I am not using self-hosted runners on Github due to security concerns
{
  # TODO: containerize this runner
  flake.modules.nixos.p520 = {config, ...}: {
    services.gitea-actions-runner.instances.nixos = {
      enable = false;
      name = config.networking.hostName;
      labels = ["native:host"];
      url = "https://git.groovyreserve.com/michael/nixos.git";
      tokenFile = config.sops.secrets.forgejoRunnerToken.path;
    };
  };
}
