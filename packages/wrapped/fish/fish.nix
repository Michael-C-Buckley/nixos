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
  inherit (config) flake;
  inherit (config.flake.custom.functions) printConfig;
  inherit (config.flake.custom.wrappers) mkFish mkGitSignersFile;
  inherit (config.flake.custom.userModules.shellAliases) basic extra fish;
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
        GIT_SIGNING_KEYS_FILE = "${mkGitSignersFile {inherit pkgs;}}";
      };
    };
  };
  flake.custom.wrappers.mkFish = {
    pkgs,
    env ? {},
    extraConfig ? "",
    extraAliases ? {},
    extraRuntimeInputs ? [],
  }: let
    aliases = basic // extra // fish // extraAliases;

    cfg = import ./_config.nix {
      inherit
        pkgs
        flake
        env
        extraConfig
        aliases
        ;
    };

    print = printConfig {
      inherit cfg pkgs;
      name = "fish-print-config";
    };

    runtimeEnv = pkgs.buildEnv {
      name = "fish-runtime-env";
      pathsToLink = ["/bin"];
      paths = with pkgs;
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
    };
  in
    pkgs.symlinkJoin {
      name = "fish";
      paths = [pkgs.fish];
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = ''
        cp -r ${print}/bin $out

        wrapProgram $out/bin/fish \
          --add-flags "--init-command 'source ${cfg}'" \
          --prefix PATH : ${runtimeEnv}/bin
      '';
      passthru.shellPath = "/bin/fish";
    };
}
