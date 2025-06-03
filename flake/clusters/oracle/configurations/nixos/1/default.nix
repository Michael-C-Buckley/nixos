{inputs, ...}: {
  imports = [
    inputs.nix-secrets.nixosModules.oracleAcme
    ./hardware.nix
    ./networking
    ./nginx.nix
  ];

  system = {
    stateVersion = "24.11";
    zfs.enable = true;
  };

  services = {
    nix-serve.enable = true; # public key: nix-cache.groovyreserve.com:2bl9yB/F+bbd9H2zND2ZHyU21kFNErnteY47q5K6Jww=
  };
}
