# First draft at using Niri
{
  flake.modules.nixos.niri = {pkgs, ...}: let
    noctaliaWrapper = pkgs.writeShellScript "noctalia-wrapper" ''
      #!/usr/bin/env bash
      exec $(cat ~/.local/share/noctalia_path) "$@"
    '';
    noctaliaPath = pkgs.writeShellScript "noctalia-path" ''
      #!/usr/bin/env bash
      mkdir -p ~/.local/share
      echo $(whereis noctalia-shell | awk '{print $2}') > ~/.local/share/noctalia_path
    '';
  in {
    programs.niri.enable = true;
    environment.systemPackages = with pkgs; [
      xwayland-satellite
      wireplumber
      playerctl
      ghostty
      hyprlock
    ];

    hjem.users.michael = {
      files.".config/niri/config.kdl".text = ''
        input {
          warp-mouse-to-focus
          focus-follows-mouse
          touchpad {
            tap
            dwt // disable while typing

          }
        }

        layout {
          gaps 16
          center-focused-column "never"
          default-column-width { proportion 0.75; }

          // Mod+R to switch between layouts
          preset-column-widths {
            proportion 0.33333
            proportion 0.5
            proportion 0.66667
            proportion 0.9
          }

          focus-ring {
            width 4
            active-color "#2d6981ab"
            inactive-color "#595959aa"
          }
          border { off; }
        }

        spawn-sh-at-startup "systemctl --user start noctalia-shell.service"
        spawn-sh-at-startup "${noctaliaPath}"

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

        binds {
          ${import ./binds/_system.nix}
          ${import ./binds/_windows.nix}
          ${import ./binds/_workspace.nix}

          // Most actions that you can bind here can also be invoked programmatically with
          // `niri msg action do-something`.
          // Mod-Shift-/, which is usually the same as Mod-?,
          // shows a list of important hotkeys.
          Mod+Shift+Slash { show-hotkey-overlay; }

          // Suggested binds for running programs: terminal, app launcher, screen locker.
          Super+Return hotkey-overlay-title="Terminal: ghostty" { spawn "ghostty"; }
          Super+Shift+A hotkey-overlay-title="Screen Lock: hyprlock" { spawn "hyprlock"; }

          // Noctalia Functions
          Super+space hotkey-overlay-title="Noctalia: Launcher" { spawn-sh "${noctaliaWrapper} ipc call launcher toggle"; }
          Super+Ctrl+space hotkey-overlay-title="Noctalia: Toggle Bar" { spawn-sh "${noctaliaWrapper} ipc call bar toggle"; }
          Mod+Ctrl+M hotkey-overlay-title="Noctalia: Toggle Dark Mode" { spawn-sh "${noctaliaWrapper} ipc call darkMode toggle"; }
          Mod+Ctrl+N hotkey-overlay-title="Noctalia: Toggle Notifications Do Not Disturb" { spawn-sh "${noctaliaWrapper} ipc call notifications toggleDND"; }

          XF86AudioRaiseVolume allow-when-locked=true { spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+ -l 1.0"; }
          XF86AudioLowerVolume allow-when-locked=true { spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-"; }
          XF86AudioMute        allow-when-locked=true { spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"; }
          XF86AudioMicMute     allow-when-locked=true { spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"; }
          XF86AudioPlay        allow-when-locked=true { spawn-sh "playerctl play-pause"; }
          XF86AudioStop        allow-when-locked=true { spawn-sh "playerctl stop"; }
          XF86AudioPrev        allow-when-locked=true { spawn-sh "playerctl previous"; }
          XF86AudioNext        allow-when-locked=true { spawn-sh "playerctl next"; }
          XF86MonBrightnessUp allow-when-locked=true { spawn "brightnessctl" "--class=backlight" "set" "+10%"; }
          XF86MonBrightnessDown allow-when-locked=true { spawn "brightnessctl" "--class=backlight" "set" "10%-"; }

          Print { screenshot; }
          Ctrl+Print { screenshot-screen; }
          Alt+Print { screenshot-window; }
        }
      '';
    };
  };
}
