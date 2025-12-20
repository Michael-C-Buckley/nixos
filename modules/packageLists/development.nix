# Basic local development-based tools
{
  flake.packageLists.development = [
    # Git tools
    "git"
    "tig"
    "gh"
    "lazygit"
    "jujutsu"

    # Nix tools
    "nh"
    "nix-tree"
    "attic-client"

    # Misc
    "python3"
  ];
}
