# Not technically a DE/WM but a Quickshell theme I'm just living here
{inputs, ...}: {
  flake.modules.nixos.noctalia = {
    config,
    pkgs,
    lib,
    ...
  }: {
    options.custom.noctalia = {
      wrapperScript = lib.mkOption {
        type = lib.types.package;
        description = "Path to a wrapper script for Noctalia.";
        default = pkgs.writeShellScript "noctalia-wrapper" ''
          #!/usr/bin/env bash
          exec $(cat ~/.local/share/noctalia_path) "$@"
        '';
      };
      pathScript = lib.mkOption {
        type = lib.types.package;
        description = "Script to capture the active Noctalia session and path for IPC usage";
        default = pkgs.writeShellScript "noctalia-path" ''
          #!/usr/bin/env bash
          mkdir -p ~/.local/share
          echo $(whereis noctalia-shell | awk '{print $2}') > ~/.local/share/noctalia_path
        '';
      };
    };
    config = {
      imports = [
        inputs.noctalia.nixosModules.default
      ];

      custom.impermanence.persist.user.directories = [
        ".config/noctalia"
      ];
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
        # Add the wrapper scripts so they can be reused
        ++ (with config.custom.noctalia; [wrapperScript pathScript]);

      services.noctalia-shell = {
        enable = true;
      };

      # These fonts are used by default
      fonts.packages = with pkgs; [
        roboto
        inter
        material-symbols
      ];
    };
  };
}
