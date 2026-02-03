{
  inputs,
  lib,
  ...
}: {
  flake.modules.systemManager.nix = {
    nix = {
      #registry = lib.mapAttrs (_: flake: {inherit flake;}) inputs;
      #nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") inputs;

      settings = {
        warn-dirty = false;

        experimental-features = ["flakes" "nix-command"];
        # Clear the default registry and add the inputs to the nix path
        nix-path = lib.mapAttrsToList (n: _: "${n}=flake:${n}") inputs;
        flake-registry = "";

        trusted-users = ["root" "@wheel" "@sudo" "michael"];
        allowed-users = ["root" "@wheel" "@sudo" "michael"];

        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
        substituters = [
          "https://cache.numtide.com"
          "https://nix-community.cachix.org"
          "https://cache.nixos.org"
        ];
      };
    };
  };
}
