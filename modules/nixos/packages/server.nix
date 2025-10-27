{
  flake.modules.nixos.packages-server = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
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
  };
}
