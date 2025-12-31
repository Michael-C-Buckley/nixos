# Home-Manager for my WSL Alpine Instance
{config, ...}: let
  inherit (config) flake;
in {
  flake.modules.homeManager.alpine = {pkgs, ...}: let
    inherit (pkgs.stdenv.hostPlatform) system;
    localPkgs = with flake.packages.${system}; [
      nvf
    ];
  in {
    home.packages = with pkgs;
      [
        bash # Ensure that bash is available
        iproute2 # better than busybox's limited ip tool
        unixtools.whereis
      ]
      ++ localPkgs;
  };
}
