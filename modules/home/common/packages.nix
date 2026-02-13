{config, ...}: let
  inherit (config) flake;
in {
  flake.modules.homeManager.packages = {
    pkgs,
    functions,
    ...
  }: let
    inherit (pkgs.stdenv.hostPlatform) system;
    localPkgs = with flake.packages.${system}; [
      helix
      ns
    ];
  in {
    home.packages =
      localPkgs
      ++ (functions.packageLists.combinePkgLists (with flake.packageLists; [cli development]));
  };
}
