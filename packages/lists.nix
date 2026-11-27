pkgs: with pkgs; {
  base = [
    age
    bat
    delta
    duf
    dust
    eza
    fd
    file
    fzf
    git
    jq
    mosh
    nh
    nix-graph
    nix-tree
    ripgrep
    socat
    sops
    starship
    tmux
    tig
    tmux
    vim
    yazi
    zoxide
    (callPackage ./ns { })
    alacritty.terminfo
    kitty.terminfo
    ghostty.terminfo
    tmux.terminfo
  ];

  dev = [
    git
    tig
    delta
    gh
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
