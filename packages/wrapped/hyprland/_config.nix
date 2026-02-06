{
  pkgs,
  hostConfig ? null,
}: let
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

  # List of store paths to source
  filesToSource =
    [
      ./binds.conf
      ./lookfeel.conf
    ]
    ++ (
      if hostConfig == null
      then []
      else [hostConfig]
    );
in
  pkgs.writeText "hyprland-wrapped-config.conf"
  ''
    $terminal=kitty
    $browser=helium
    $browser2=librewolf
    $ide=zeditor
    $noctalia=${noctaliaWrapper}
    $launcher=$noctalia ipc call launcher toggle
    $files=dolphin
    $mod=SUPER

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

    # TODO: set env when wrapping
    env=XCURSOR_SIZE,28
    env=HYPRCURSOR_SIZE,28
    env=QT_QPA_PLATFORMTHEME,qt6ct
    env=QT_STYLE_OVERRIDE,kvantum
    env=KDE_PLATFORM_THEME,qt6ct


    # TODO: fix the systemd service in the wrapper
    exec-once=${noctaliaPathScript}
    exec-once=${noctaliaWrapper}
    #exec-once=systemctl --user start noctalia-shell.service
    exec-once=systemctl --user start hyprpolkitagent

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

    ${builtins.concatStringsSep "\n" (map (a: "source = ${a}") filesToSource)}
  ''
