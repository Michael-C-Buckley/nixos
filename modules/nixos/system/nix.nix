{inputs, ...}: {
  flake.modules.nixos.nix = {
    pkgs,
    lib,
    ...
  }: {
    nix = {
      package = pkgs.nixVersions.latest;

      # Disable channels and add the flake inputs to the registry
      channel.enable = false;
      registry = lib.mapAttrs (_: flake: {inherit flake;}) inputs;
      nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") inputs;

      extraOptions = ''
        # Optimizing cache requests with faster failing
        connect-timeout          = 5
        stalled-download-timeout = 30
        download-attempts        = 2
        http-connections         = 50
        max-substitution-jobs    = 32
        fallback                 = true
      '';

      settings = {
        warn-dirty = false;
        experimental-features = [
          "nix-command"
          "flakes"
          "pipe-operators"
        ];

        # Clear the default registry and add the inputs to the nix path
        nix-path = lib.mapAttrsToList (n: _: "${n}=flake:${n}") inputs;
        flake-registry = "";

        substituters = [
          "https://cache.nixos-cuda.org"
          "https://nix-community.cachix.org"
        ];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
        ];
        trusted-users = ["root" "@wheel" "builder"];
        allowed-users = ["root" "@wheel" "builder"];
      };
    };
  };
}
