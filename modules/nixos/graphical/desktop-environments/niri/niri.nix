# First draft at using Niri
{
  flake.modules.nixos.niri = {pkgs, ...}: let
    # wrapperScript = pkgs.writeShellScript "noctalia-wrapper" ''
    #   #!/usr/bin/env bash
    #   exec $(cat ~/.local/share/noctalia_path) "$@"
    # '';
    pathScript = pkgs.writeShellScript "noctalia-path" ''
      #!/usr/bin/env bash
      mkdir -p ~/.local/share
      echo $(whereis noctalia-shell | awk '{print $2}') > ~/.local/share/noctalia_path
    '';
  in {
    programs.niri.enable = true;
    environment.systemPackages = [
      pkgs.xwayland-satellite
    ];

    hjem.users.michael = {
      files.".config/niri/config.kdl".text = ''
        input {
          warp-mouse-to-focus
          focus-follows-mouse
          touchpad {
            tap
          }
        }

        layout {
          gaps 16
          center-focused-column "never"
          default-column-width { proportion 0.75; }

          preset-column-widths {
            proportion 0.33333
            proportion 0.5
            proportion 0.66667
          }

          focus-ring {
            width 4
            active-color "#2d6981ab"
            inactive-color "#595959aa"
          }
          border { off; }
        }

        spawn-sh-at-startup "systemctl --user start noctalia-shell.service"
        spawn-sh-at-startup "${pathScript}"

        cursor {
          // TODO: integrate as option
          xcursor-theme "Nordzy-cursors-white"
          xcursor-size 24
        }

        // Rounded corners on all windows
        window-rule {
          geometry-corner-radius 12
          clip-to-geometry true
        }

        include "binds.kdl"
      '';
    };
  };
}
