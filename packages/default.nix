{
  inputs,
  pkgs,
  configPaths,
  ...
}:
let
  git-credential-sops = pkgs.callPackage ./git/git-credential-sops.nix {
    inherit configPaths;
  };
  nvim = pkgs.callPackage ./nvim { inherit configPaths; };
in
{
  inherit nvim git-credential-sops;
  agentbox = pkgs.callPackage ./agentbox { };
  git = pkgs.callPackage ./git/git.nix { inherit configPaths git-credential-sops; };
  zsh = pkgs.callPackage ./zsh { inherit configPaths inputs; };
}
