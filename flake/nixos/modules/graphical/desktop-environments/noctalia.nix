# Not technically a DE/WM but a Quickshell theme I'm just living here
{
  inputs,
  config,
  pkgs,
  system,
  lib,
  ...
}: let
  inherit (config.features) noctalia;
in {
  options.features.noctalia = {
    enable = lib.mkEnableOption "Enable Noctalia Shell";
  };

  config = lib.mkIf noctalia.enable {
    # Dependencies and fonts
    environment.systemPackages = with pkgs;
      [
        brightnessctl
        cava
        cliphist
        coreutils
        ddcutil
        file
        findutils
        gpu-screen-recorder
        libnotify
        matugen
        swww
        wl-clipboard
        wlsunset
      ]
      ++ [
        inputs.noctalia.packages.${system}.default
      ];

    fonts.packages = with pkgs; [
      roboto
      inter
      material-symbols
    ];
  };
}
