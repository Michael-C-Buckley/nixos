# Home-Manager for my WSL Alpine Instance
{config, ...}: let
  inherit (config) flake;
in {
  flake.modules.homeManager.alpine = {
    config,
    pkgs,
    ...
  }: let
    inherit (pkgs.stdenv.hostPlatform) system;
    pkgsFromNix = with pkgs; [
      iproute2 # better than busybox's limited ip tool
      lazygit
    ];

    localPkgs = with flake.packages.${system}; [
      nvf
      ns
    ];
  in {
    home.packages = pkgsFromNix ++ localPkgs;
  };
}
