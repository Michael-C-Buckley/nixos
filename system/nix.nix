{
  pkgs,
  lib,
  inputs,
  ...
}: let
  inherit (lib) mapAttrs mapAttrsToList;
in {
  nixpkgs.config.allowUnfree = true;

  nix = {
    # package = pkgs.nixVersions.latest;
    package = pkgs.lix;

    # Disable channels and add the inputs to the registry
    channel.enable = false;
    registry = mapAttrs (_: flake: {inherit flake;}) inputs;
    nixPath = mapAttrsToList (n: _: "${n}=flake:${n}") inputs;

    extraOptions = ''
      accept-flake-config      = True

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
      ];

      # Disable channels and add the inputs to the registry
      nix-path = mapAttrsToList (n: _: "${n}=flake:${n}") inputs;
      flake-registry = "";

      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://microvm.cachix.org"
        "https://cosmic.cachix.org/"
        "https://cache.thalheim.io" # sops-nix
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "microvm.cachix.org-1:oXnBc6hRE3eX5rSYdRyMYXnfzcCxC7yKPTbZXALsqys="
        "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
        "cache.thalheim.io-1:R7msbosLEZKrxk/lKxf9BTjOOH7Ax3H0Qj0/6wiHOgc="
      ];
      trusted-users = [
        "@wheel"
        "nix-ssh"
      ];
    };
  };
}
