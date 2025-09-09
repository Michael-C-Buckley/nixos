# This host is a remote builder
{
  # It's a 4 vCPU server, don't overload it
  nix.settings = {
    cores = 2;
    max-jobs = 2;
  };

  users.users.hydra.enable = true;
}
