{
  pkgs,
  lib,
  inputs,
  ...
}: let
  inherit (lib) mapAttrs mapAttrsToList;
in {
  nix = {
    package = pkgs.nixVersions.nix_2_30;
    # Disable channels and add the inputs to the registry
    channel.enable = false;
    registry = mapAttrs (_: flake: {inherit flake;}) inputs;
    nixPath = mapAttrsToList (n: _: "${n}=flake:${n}") inputs;

    extraOptions = ''
      accept-flake-config      = true

      # Optimizing cache requests with faster failing
      connect-timeout          = 5
      stalled-download-timeout = 30
      download-attempts        = 2
      http-connections         = 50
      max-substitution-jobs    = 32
      fallback                 = true
    '';

    settings = {
      auto-optimise-store = true;
      warn-dirty = false;
      experimental-features = [
        "nix-command"
        "flakes"
        "pipe-operators"
      ];

      # Disable channels and add the inputs to the registry
      nix-path = mapAttrsToList (n: _: "${n}=flake:${n}") inputs;
      flake-registry = "";

      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://microvm.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "microvm.cachix.org-1:oXnBc6hRE3eX5rSYdRyMYXnfzcCxC7yKPTbZXALsqys="
      ];
      trusted-users = [
        "@wheel"
        "nix-ssh"
      ];
    };
  };
}
