# Not technically a DE/WM but a Quickshell theme I'm just living here
{inputs, ...}: {
  flake.modules.nixos.noctalia = {
    config,
    pkgs,
    ...
  }: {
    custom.impermanence.persist.user.directories = [
      ".config/noctalia"
    ];
    # Dependencies and fonts
    environment = {
      systemPackages = with pkgs;
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
          inputs.noctalia.packages.${config.nixpkgs.system}.default
        ];
    };

    # These fonts are used by default
    fonts.packages = with pkgs; [
      roboto
      inter
      material-symbols
    ];
  };
}
