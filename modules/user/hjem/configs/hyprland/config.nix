{
  flake.modules.nixos.hyprland = {pkgs, ...}:
  # Some Hyprland scripts to assist with Noctalia instance tracking
  let
    noctaliaWrapper = pkgs.writeShellScript "noctalia-wrapper.sh" ''
      #!/usr/bin/env bash
      NOCTALIA_PATH=$(cat ~/.local/share/noctalia_path)
      $NOCTALIA_PATH "$@"
    '';

    noctaliaPathScript = pkgs.writeShellScript "noctalia-path.sh" ''
      #!/usr/bin/env bash
      mkdir -p ~/.local/share
      echo $(whereis noctalia-shell | awk '{print $2}') > ~/.local/share/noctalia_path
    '';
  in {
    hjem.users.michael.files = {
      ".config/hypr/binds.conf".source = ./binds.conf;
      ".config/hypr/lookfeel.conf".source = ./lookfeel.conf;
      ".config/hypr/hyprland.conf".text = ''
        $browser=helium
        $browser2=librewolf
        $browser3=qutebrowser
        $fileManager=nemo
        $ide=zeditor
        $ide2=code
        $noctalia=${noctaliaWrapper}
        $launcher=$noctalia ipc call launcher toggle
        $mod=SUPER
        $terminal=kitty
        $terminal2=ghostty

        master {
          new_status=master
        }

        misc {
          disable_hyprland_logo=true
          force_default_wallpaper=0
        }

        ecosystem {
          no_update_news=true
        }

        env=XCURSOR_SIZE,28
        env=HYPRCURSOR_SIZE,28

        # TODO: fix the systemd service in the wrapper
        #exec-once=systemctl --user start noctalia-shell.service
        exec-once=noctalia-shell

        exec-once=${noctaliaPathScript}
        exec-once=gammastep -l 36:-78 -t 6500k:1800k
        exec-once=systemctl --user start hyprpolkitagent

        source = ~/.config/hypr/binds.conf
        source = ~/.config/hypr/lookfeel.conf
        source = ~/.config/hypr/host.conf

        # https://wiki.hyprland.org/Configuring/Variables/#input

        device {
          name=epic-mouse-v1
          sensitivity=-0.500000
        }

        input {
          touchpad {
            natural_scroll=false
          }
          follow_mouse=1
          kb_layout=us
          sensitivity=0
        }

      '';
    };
  };
}
