{ inputs, pkgs, ... }:
let
  git-credential-sops = pkgs.callPackage ../packages/git/credential-sops.nix { };
  nvim = pkgs.callPackage ../packages/nvim { };
in
{
  inherit nvim git-credential-sops;
  git = pkgs.callPackage ../packages/git { inherit git-credential-sops; };
  zsh = pkgs.callPackage ../packages/zsh { inherit inputs; };
}
