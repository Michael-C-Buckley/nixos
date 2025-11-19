# First attempt at a private Forgejo runner for this project
# I am not using self-hosted runners on Github due to security concerns
{
  # TODO: containerize this runner
  flake.modules.nixos.p520 = {config, ...}: {
    services.gitea-actions-runner.instances.nixos = {
      enable = true;
      name = config.networking.hostName;
      labels = ["native:host"];
      url = "http://192.168.48.5:30300/michael/nixos.git";
      tokenFile = config.sops.secrets.forgejoRunnerToken.path;
    };
  };
}
