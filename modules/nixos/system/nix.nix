{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  experimental-features = [
    "nix-command"
    "flakes"
    "pipe-operators"
  ];
  # TODO: clean up paths
  pinnedNix = import ../../../lib/pinned-nix.nix { inherit lib; };
in
{
  nix = pinnedNix inputs // {
    package = pkgs.nixVersions.latest;
    channel.enable = false;

    settings = {
      inherit experimental-features;
      trusted-users = [
        "@wheel"
        "root"
      ];
      allowed-users = [
        "@wheel"
        "root"
      ];

      nix-path = config.nix.nixPath;

      substituters = [ ];
    };
  };
}
