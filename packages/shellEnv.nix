{
  pkgs,
  extraPkgs ? [ ],
  ...
}:
let
  iproute2 = if pkgs.stdenv.hostPlatform.isDarwin then [ pkgs.iproute2mac ] else [ pkgs.iproute2 ];

  common =
    builtins.attrValues {
      inherit iproute2;
      inherit (pkgs)
        # CLI
        bat
        eza
        fd
        fzf
        ripgrep
        # Utility
        direnv
        # Git
        git
        tig
        delta
        # Security
        sops
        age
        # Nix
        nix-tree
        nix-direnv
        ;
    }
    ++ extraPkgs;
in
pkgs.buildEnv {
  name = "shell-buildenv";
  paths = common;
  pathsToLink = [ "/bin" ];
}
