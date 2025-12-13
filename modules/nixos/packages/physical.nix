# Packages for bare metal instances
{
  flake.modules.nixos.packages-physical = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
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
