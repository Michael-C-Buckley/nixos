{pkgs, ...}: {
  # public key: nix-cache.groovyreserve.com:2bl9yB/F+bbd9H2zND2ZHyU21kFNErnteY47q5K6Jww=
  services.nix-serve = {
    enable = true;
    package = pkgs.nix-serve-ng;
    openFirewall = true;
    secretKeyFile = "/run/secrets/cachePrivateKey";
  };
}
