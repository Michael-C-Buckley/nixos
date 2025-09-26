{
  flake.modules.nixosModules.system.nix = {
    pkgs,
    lib,
    inputs,
    ...
  }: let
    inherit (lib) mapAttrs mapAttrsToList;
  in {
    environment.systemPackages = with pkgs; [
      npins
    ];

    nix = {
      package = pkgs.nixVersions.latest;
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
        ];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          # Personal cache capable devices and keys
          "x570-1:b3fLRrQyBeUbmpS+AGi68O1L2F1kSLEVX2ePAyDPNWk="
          "michael-hydra-1:i6EiwHcLtrM6EAdpeymEWqlWs9p15HVTCjS+Cs/cgH0="
          "nix-cache.groovyreserve.com-1:DI9lyYMkvLcXbifzvjZ85nJuxEkDOxRvs7fS/5r5vyg="
        ];
        trusted-users = ["root" "@wheel" "builder"];
        allowed-users = ["root" "@wheel" "builder"];
      };
    };
  };
}
