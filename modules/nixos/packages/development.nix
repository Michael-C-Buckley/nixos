# Basic local development-based tools
{
  flake.modules.nixos.packages-development = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      attic-client
      ns # local overlay
      python3
      lazygit
      tig
      jujutsu
      gh
      nix-tree
    ];
  };
}
