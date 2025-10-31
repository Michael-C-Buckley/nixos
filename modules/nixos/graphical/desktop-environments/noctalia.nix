# Not technically a DE/WM but a Quickshell theme I'm just living here
{inputs, ...}: {
  flake.modules.nixos.noctalia = {pkgs, ...}: {
    imports = [
      inputs.noctalia.nixosModules.default
    ];

    custom.impermanence.persist.user.directories = [
      ".config/noctalia"
    ];
    # Dependencies and fonts
    environment = {
      systemPackages = with pkgs; [
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
      ];
    };
    services.noctalia-shell = {
      enable = true;
      package = inputs.noctalia.packages.${pkgs.system}.default.override {inherit (pkgs) quickshell;};
    };

    # These fonts are used by default
    fonts.packages = with pkgs; [
      roboto
      inter
      material-symbols
    ];
  };
}
