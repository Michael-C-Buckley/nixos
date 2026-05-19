{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    git
    lazygit
    tig
    delta
    jujutsu
    gh
    nix-tree
    nh
  ];
}
