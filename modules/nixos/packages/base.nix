let
  commonPackages =
    pkgs:
    (
      with pkgs;
      [
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
      ]
      ++ [ (pkgs.callPackage ../../../packages/ns { }) ]
    );
in
{ pkgs, ... }: {
  environment.systemPackages =
    commonPackages pkgs
    ++ (with pkgs; [
      vim
      neovim
      duf
      file
      socat
      tmux
      alacritty.terminfo
      kitty.terminfo
      ghostty.terminfo
      tmux.terminfo
    ]);
}
