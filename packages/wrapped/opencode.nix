# Helium Browser, pulled from the appImage and jailed
{inputs, ...}: {
  perSystem = {pkgs, ...}: let
    jail = inputs.jail.lib.init pkgs;
    homeBind = with jail.combinators; path: (rw-bind (noescape path) (noescape path));

    features = with jail.combinators;
      [
        network
        (readonly "/nix/store")
      ]
      ++ [
        (homeBind "~/projects")
        (homeBind "~/nixos")
      ];
  in {
    packages = {
      opencode = jail "opencode" pkgs.opencode features;
    };
  };
}
