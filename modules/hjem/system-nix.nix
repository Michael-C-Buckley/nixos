{ inputs, lib, ... }:
let
  pinned = import ../../lib/pinned-nix.nix { inherit lib; } inputs;
in
{
  environment.sessionVariables.NIX_PATH = "${lib.concatStringsSep ":" pinned.nixPath}\${NIX_PATH:+:$NIX_PATH}";
  xdg.config.files = {
    "nixpkgs/config.nix".text = ''
      { allowUnfree = true; }
    '';
    "nix/registry.json".text = builtins.toJSON {
      version = 2;
      flakes = lib.mapAttrsToList (name: entry: {
        from = {
          type = "indirect";
          id = name;
        };
        inherit (entry) to;
        exact = true;
      }) pinned.registry;
    };
  };
}
