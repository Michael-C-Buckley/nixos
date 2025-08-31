{pkgs, ...}: {
  packageSets.minimalGraphical = with pkgs; [
    # Clipboard
    wl-clipboard
    xclip
    cliphist
    wl-clipboard-x11

    # Display
    cage

    # Terminals
    wezterm
    kitty
    kitty-themes
    sakura
  ];
}
