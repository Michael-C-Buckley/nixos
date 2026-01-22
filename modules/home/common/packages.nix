{config, ...}: let
  inherit (config) flake;
in {
  flake.modules.homeManager.packages = {pkgs, ...}: let
    inherit (pkgs.stdenv.hostPlatform) system;
    localPkgs = with flake.packages.${system}; [
      ns
    ];
    wrappedPkgs = with flake.wrappers; [
      (mkGit {inherit pkgs;})
    ];
  in {
    home.packages =
      localPkgs
      ++ wrappedPkgs
      ++ (flake.lib.packageLists.combinePkgLists pkgs (with flake.packageLists; [cli development]));
  };
}
