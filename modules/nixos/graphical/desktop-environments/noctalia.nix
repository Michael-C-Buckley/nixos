# Not technically a DE/WM but a Quickshell theme I'm just living here
{inputs, ...}: {
  host.impermanence.persist.directories = [
    "/home/michael/.config/noctalia"
  ];

  flake.nixosModules.noctalia = {
    config,
    pkgs,
    ...
  }: {
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
