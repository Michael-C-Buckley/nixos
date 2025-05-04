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
    # This service is causing 25.05 to fail because it can't find group 30000 for whatever reason
    logrotate.enable = false;
  };
}
