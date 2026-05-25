{
  pkgs,
  flake,
  lib,
  ...
}: let
  allInputs = with pkgs; [
    noctalia-shell
    # Required
    brightnessctl
    imagemagick
    python3
    git
    cliphist
    ddcutil
    wl-clipboard
    wlsunset
    wlr-randr
    # Optional that I include
    cava
    libnotify
  ];

  fonts = with pkgs; [
    dejavu_fonts
    inter
    material-symbols
    roboto
  ];

  # Not available on ARM
  x86Inputs = with pkgs; [gpu-screen-recorder];
in {
  environment.systemPackages = allInputs ++ fonts ++ lib.optionals (flake.system == "x86_64-linux") x86Inputs;
}
