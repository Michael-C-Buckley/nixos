# Home-Manager for my WSL Alpine Instance
{config, ...}: let
  inherit (config) flake;
in {
  flake.modules.homeManager.alpine = {pkgs, ...}: let
    inherit (pkgs.stdenv.hostPlatform) system;
    pkgsFromNix = with pkgs; [
      bash # Ensure that bash is available
      iproute2 # better than busybox's limited ip tool
      lazygit
      unixtools.whereis
    ];

    localPkgs = with flake.packages.${system}; [
      nvf
      ns
    ];

    wrappedPkgs = with flake.wrappers; [
      (mkGit {
        inherit pkgs;
        signingKey = "6F749AA097DC10EA46FE0ECD22CDD3676227046F!";
      })
    ];
  in {
    home.packages = pkgsFromNix ++ localPkgs ++ wrappedPkgs;
  };
}
