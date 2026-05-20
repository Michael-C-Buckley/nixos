{
  pkgs,
  lib,
  flake,
  ...
}: {
  imports = with flake.nixosModules; [
    cloud-preset
    attic
    secrets
    tailscale
  ];
  environment = {
    # This is not linking for some reason, attempting to force copy instead of link
    etc."nix/nix.conf".mode = lib.mkForce "0755";

    systemPackages = with pkgs; [
      attic-client
    ];
  };

  #  It's a 4 vCPU server, don't overload it
  nix.settings = {
    cores = 2;
    max-jobs = 2;
  };

  system = {
    stateVersion = "25.11";
  };
}
