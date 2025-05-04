{pkgs, ...}: {
  services.nix-serve = {
    package = pkgs.nix-serve-ng;
    openFirewall = true;
    secretKeyFile = "/run/secrets/cachePrivateKey";
  };
}
