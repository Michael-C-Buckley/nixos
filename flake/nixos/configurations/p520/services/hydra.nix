{
  services = {
    hydra.enable = true;
    nix-serve = {
      enable = false;
      secretKeyFile = "/run/secrets/cache-private";
    };
  };
}
