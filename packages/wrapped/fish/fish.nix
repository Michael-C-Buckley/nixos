# My Fish is a full basic CLI setup that I use, including configs, functions
# and a few common tools
#
# I use this quite regularly anywhere I am in a shell, which includes hosts,
# VMs, Mac, Linux, WSL, etc
{
  config,
  lib,
  ...
}: let
  inherit (config.flake.wrappers) mkFish mkStarshipConfig mkGitConfig;
in {
  perSystem = {
    pkgs,
    system,
    ...
  }: let
    home =
      if lib.hasSuffix "darwin" system
      then "Users"
      else "home";
  in {
    packages.fish = mkFish {
      inherit pkgs;
      env = {
        NH_FLAKE = "/${home}/michael/nixos";
        NIXPKGS_ALLOW_UNFREE = "1";
      };
    };
  };
  flake.wrappers.mkFish = {
    pkgs,
    env ? {},
    extraConfig ? "",
    extraAliases ? {},
    extraRuntimeInputs ? [],
  }: let
    starshipConfig = mkStarshipConfig {inherit pkgs;};
    gitConfig = mkGitConfig {inherit pkgs;};
    buildInputs = with pkgs;
      [
        bat
        direnv
        eza
        fd
        fzf
        jq
        nix-direnv
        starship
        git
        ripgrep
        delta
        tig
        lazygit
      ]
      ++ extraRuntimeInputs;
  in
    pkgs.symlinkJoin {
      name = "fish";
      paths = [pkgs.fish];
      inherit buildInputs;
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/fish \
          --add-flags "--init-command 'source ${
          import ./_config.nix {
            inherit
              pkgs
              env
              starshipConfig
              gitConfig
              extraConfig
              extraAliases
              ;
          }
        }'" \
          --prefix PATH : ${pkgs.lib.makeBinPath buildInputs}
      '';
      passthru.shellPath = "/bin/fish";
    };
}
