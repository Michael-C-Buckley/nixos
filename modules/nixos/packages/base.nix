{ pkgs, ... }: {
  environment.systemPackages =
    # TODO: clean paths up
    (import ../../../packages/lists.nix pkgs).base
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
