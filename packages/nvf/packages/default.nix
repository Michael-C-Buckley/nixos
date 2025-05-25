{system, inputs, ...}: let
  mkNvf = import ./mkNvf.nix {inherit system inputs;};
in mkNvf [../config/extended.nix]