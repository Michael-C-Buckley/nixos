{
  services = {
    hydra.enable = true;
    nix-serve = {
      enable = true;
      secretKeyFile = "/run/secrets/cache-private";
    };
  };
}
