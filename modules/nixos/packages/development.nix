# Basic local development-based tools
{
  flake.modules.nixos.packages-development = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      ns # local overlay
      python3
      lazygit
      difftastic
      gitFull
      tig
      jujutsu
      gh
      nix-tree
    ];
  };
}
