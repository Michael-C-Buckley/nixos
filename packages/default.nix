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
  comview = pkgs.callPackage ./comview { inherit inputs; };
  git = pkgs.callPackage ./git/git.nix { inherit configPaths git-credential-sops; };
  zsh = pkgs.callPackage ./zsh { inherit configPaths inputs; };
  fish = pkgs.callPackage ./fish { inherit configPaths; };
  nushell = pkgs.callPackage ./nushell { inherit configPaths; };
  helix = pkgs.callPackage ./helix { inherit inputs configPaths; };
  helix-wrapped = pkgs.callPackage ./helix-wrapped { inherit inputs configPaths; };
}
// pkgs.lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
  gram = pkgs.callPackage ./gram { };
}
// pkgs.lib.optionalAttrs (inputs ? "tack-${pkgs.stdenv.hostPlatform.system}") {
  tack = pkgs.callPackage ./tack { inherit inputs; };
}
