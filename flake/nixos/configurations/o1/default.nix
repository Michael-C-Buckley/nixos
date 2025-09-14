{
  config,
  lib,
  ...
}: {
  imports = [
    ./hardware
    ./networking
  ];

  environment = {
    # This is not linking for some reason, attempting to force copy instead of link
    etc."nix/nix.conf".mode = lib.mkForce "0755";
  };

  services.harmonia = {
    enable = true;
    signKeyPaths = [config.sops.secrets.cachePrivateKey.path];
  };

  # For remote building
  #  It's a 4 vCPU server, don't overload it
  nix.settings = {
    cores = 2;
    max-jobs = 2;
  };

  system = {
    boot.uuid = "12CE-A600";
    stateVersion = "25.11";
    preset = "cloud";
    zfs.enable = true;
    impermanence.enable = true;
  };
}
