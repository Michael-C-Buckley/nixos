{
  flake.functions.packageLists = {pkgs}: let
    # Take in a package list (list of strings) and convert to a list of derviations
    # string manipulation is to ensure proper matching of attributes
    makePkgList = pkgList:
      map (x: pkgs.lib.attrByPath (pkgs.lib.splitString "." x) null pkgs) pkgList;
  in {
    inherit makePkgList;

    # Take in a list of package lists as `a`, flatten, and get the derivations
    combinePkgLists = a: makePkgList (pkgs.lib.lists.flatten a);
  };
}
