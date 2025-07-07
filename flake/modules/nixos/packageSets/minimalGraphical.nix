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
    ghostty
    sakura
  ];
}
