{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  nix = {
    package = pkgs.nixVersions.latest;
    channel.enable = false;

    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "@wheel"
        "root"
      ];
      allowed-users = [
        "@wheel"
        "root"
      ];

      nix-path = lib.mapAttrsToList (n: _: "${n}=flake:${n}") inputs;

      substituters = [ ];
      trusted-public-keys = [
        "michaelcbuckley-1:2VHxWbpLOjEM6dX76AYFA4252KnzkdffWNouPBZm+SM=" # Generic personal key I sign with
      ];
    };
  };
}
