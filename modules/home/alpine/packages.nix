# Home-Manager for my WSL Alpine Instance
{config, ...}: let
  inherit (config) flake;
in {
  flake.modules.homeManager.alpine = {pkgs, ...}: let
    inherit (pkgs.stdenv.hostPlatform) system;
    pkgsFromNix = with pkgs; [
      bash # Ensure that bash is available
      iproute2 # better than busybox's limited ip tool
      unixtools.whereis

      # Nix tools
      nh
      nix-tree
    ];

    localPkgs = with flake.packages.${system}; [
      nvf
      ns
    ];

    wrappedPkgs = with flake.wrappers; [
      (mkGit {inherit pkgs;})
    ];
  in {
    home.packages = pkgsFromNix ++ localPkgs ++ wrappedPkgs;
  };
}
