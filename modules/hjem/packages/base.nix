{ pkgs, ... }:
{
  packages =
    (import ../../../packages/lists.nix pkgs).base
    ++ (with pkgs; [
      ddcutil
      alacritty.terminfo
      kitty.terminfo
      ghostty.terminfo
      tmux.terminfo
    ])
    ++ [
      pkgs.localFish
    ];
}
