{...}: let
  mkNvf = import ./mkNvf.nix;
in mkNvf [../config/extended.nix]