{config, ...}: let
  inherit (config.flake.lib.packageLists) makePkgList;
in {
  flake.lib.packageLists = {
    # Take in a package list (list of strings) and convert to a list of derviations
    # string manipulation is to ensure proper matching of attributes
    makePkgList = pkgs: pkgList:
      map (x: pkgs.lib.attrByPath (pkgs.lib.splitString "." x) null pkgs) pkgList;

    # Take in a list of package lists as `a`, flatten, and get the derivations
    combinePkgLists = pkgs: a: makePkgList pkgs (pkgs.lib.lists.flatten a);
  };
}
