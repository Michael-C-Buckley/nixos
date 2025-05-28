# This idea is something I got from Iynaix and LuminarLeaf
# Leaf: https://github.com/LuminarLeaf/arboretum/blob/c5babe771d969e2d99b5fb373815b1204705c9b1/modules/user/shell/cli-tools.nix#L32
# Iynaix: https://github.com/iynaix/dotfiles/blob/ab3e10520ac824af76b08fac20eeed9a4c3f100a/home-manager/shell/nix.nix#L351

{
  config,
  lib,
  pkgs,
  ...
}: let 
  inherit (lib) mkOption mkEnableOption optionals;
  inherit (lib.types) listOf package;

  local = config.programs.custom.ns;
in {
  options.programs.custom.ns = {
    enable = lib.mkEnableOption "Enable `ns` for nix-search-tv with fzf.";
    additionalInputs = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
      description = "Additional `runtimeInputs` to add to this custom application.";
    };
    fzfPackage = mkOption {
      type = package;
      default = pkgs.fzf;
      description = "Package to use for the FZF input";
    };

  };

  config = {
    packageList = optionals local.enable [
      (pkgs.writeShellApplication {
        name = "ns";
        runtimeInputs = with pkgs;
          [
            local.fzfPackage
            nix-search-tv
          ]
          ++ config.programs.custom.ns.additionalInputs;
        checkPhase = ""; # Ignore the shell checks
        text = builtins.readFile "${pkgs.nix-search-tv.src}/nixpkgs.sh";
      })
    ];
  };
}
