pkgs: with pkgs; {
  base = [
    age
    bat
    delta
    dust
    eza
    fd
    fzf
    git
    jq
    mosh
    nix-graph
    nix-tree
    ripgrep
    sops
    starship
    tig
    tmux
    yazi
    zoxide
    (callPackage ./ns { })
  ];

  dev = [
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

  yubikey = [
    yubikey-manager
    age-plugin-yubikey
    age
    libfido2
    yubico-piv-tool
    libp11
  ];
}
