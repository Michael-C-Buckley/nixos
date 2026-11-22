{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    git
    tig
    delta
    gh
    herdr
    lazygit
    claude-code
    pi-coding-agent
    codex
  ];
}
