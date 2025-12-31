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
    home.packages = with pkgs;
      [
        nh
        nix-tree
      ]
      ++ localPkgs ++ wrappedPkgs;
  };
}
