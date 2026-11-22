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
  pinnedNix =
    inputs:
    let
      # Tack also exposes a __functor; only register actual flake inputs.
      flakes = lib.filterAttrs (
        _: input: builtins.isAttrs input && input._type or null == "flake"
      ) inputs;
    in
    {
      registry = lib.mapAttrs (_: input: {
        to = {
          type = "path";
          path = input.outPath;
        };
      }) flakes;
      nixPath = lib.mapAttrsToList (name: input: "${name}=${input.outPath}") flakes;
    };
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
