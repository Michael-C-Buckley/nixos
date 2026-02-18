{
  flake.packageLists.development = [
    # Version control tools
    "git"
    "lazygit"
    "tig"
    "jujutsu"
    "gh"

    # Nix tools
    "attic-client"
    "nix-tree"
    "nh"

    # Misc
    "python3"
    "nushell"
  ];
}
