{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.hyprland;
  toLua = lib.generators.toLua { };
  profile = config.environment.profileDirectory;
  systemPath =
    if config.environment.genericLinux then
      "/nix/var/nix/profiles/default/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games"
    else
      "/run/wrappers/bin:/run/current-system/sw/bin";
  sessionPath = "${profile}/bin:${config.directory}/.local/bin:${systemPath}";
  environment = config.environment.sessionVariables;
  importedVariables = "DISPLAY HYPRLAND_INSTANCE_SIGNATURE WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE XDG_SESSION_ID SSH_AUTH_SOCK QT_PLUGIN_PATH QT_QPA_PLATFORMTHEME XCURSOR_THEME XCURSOR_SIZE";
  execOnce = pkgs.writeShellApplication {
    name = "hyprland-exec-once";
    runtimeInputs = [
      pkgs.bash
      pkgs.coreutils
      pkgs.util-linux
      pkgs.socat
    ];
    text = builtins.readFile ../../../configs/hyprland/exec-once.sh;
  };
  startSession =
    "${pkgs.dbus}/bin/dbus-update-activation-environment"
    + lib.optionalString config.environment.useSystemd " --systemd"
    + " ${importedVariables}"
    + lib.optionalString config.environment.useSystemd " && ${pkgs.systemd}/bin/systemctl --user stop hyprland-session.target && ${pkgs.systemd}/bin/systemctl --user start hyprland-session.target"
    + lib.optionalString (
      cfg.execOnce != [ ]
    ) " && ${execOnce}/bin/hyprland-exec-once ${lib.escapeShellArgs cfg.execOnce}";
in
{
  _file = __curPos.file;
  key = __curPos.file;
  options.programs.hyprland = {
    execOnce = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = ''
        Commands started once when Hyprland starts, after publishing its D-Bus
        environment. They do not rerun on configuration reload. Foreground
        processes and their descendants are terminated when the compositor exits.
      '';
    };
    extraLuaFiles = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            content = lib.mkOption {
              type = with lib.types; either path lines;
              description = "Lua text or a file path.";
            };
            autoLoad = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "Require this module from the generated entrypoint.";
            };
          };
        }
      );
      default = { };
      description = "Hyprland Lua modules, with explicit entrypoint selection.";
    };
    extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = "Additional Lua appended to the Hyprland entrypoint.";
    };
  };
  config = {
    programs.hyprland.execOnce = lib.mkIf (!config.environment.useSystemd) [
      "${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent"
    ];
    programs.hyprland.extraLuaFiles = {
      personal.content = lib.mkDefault ../../../configs/hyprland/hyprland.lua;
    }
    // lib.genAttrs [ "binds" "input" "lookfeel" "noctalia" "windowrules" ] (name: {
      autoLoad = false;
      content = ../../../configs/hyprland + "/${name}.lua";
    });
    packages = [
      pkgs.playerctl
      pkgs.libnotify
      pkgs.wl-clipboard
      pkgs.hyprpolkitagent
    ];
    xdg.config.files = {
      "hypr/hyprland.lua".text = ''
        package.path = ${toLua "${config.xdg.config.directory}/hypr/?.lua;${config.xdg.config.directory}/hypr/?/init.lua;"} .. package.path
        ${lib.concatStringsSep "\n" (
          lib.mapAttrsToList (name: _: "require(${toLua (lib.removeSuffix ".lua" name)})") (
            lib.filterAttrs (_: file: file.autoLoad) cfg.extraLuaFiles
          )
        )}
        hl.env("PATH", ${toLua sessionPath})
        hl.env("XDG_DATA_DIRS", ${toLua "${config.xdg.data.directory}:${profile}/share:/run/current-system/sw/share:/nix/var/nix/profiles/default/share:/usr/local/share:/usr/share:/var/lib/snapd/desktop"})
        ${lib.optionalString (environment ? SSH_AUTH_SOCK) ''
          local hjem_socket = ${toLua environment.SSH_AUTH_SOCK}
          local hjem_runtime = os.getenv("XDG_RUNTIME_DIR") or ""
          hjem_socket = hjem_socket:gsub("%$%{XDG_RUNTIME_DIR%}", hjem_runtime):gsub("%$XDG_RUNTIME_DIR", hjem_runtime)
          hl.env("SSH_AUTH_SOCK", hjem_socket)
        ''}
        ${lib.concatMapStringsSep "\n"
          (
            name:
            lib.optionalString (environment ? ${name})
              "hl.env(${toLua name}, ${toLua (toString environment.${name})})"
          )
          [
            "QT_QPA_PLATFORMTHEME"
            "QT_PLUGIN_PATH"
            "QML2_IMPORT_PATH"
            "XCURSOR_THEME"
            "XCURSOR_SIZE"
            "XCURSOR_PATH"
          ]
        }
        hl.on("hyprland.start", function()
          hl.exec_cmd(${toLua startSession})
        end)
        ${lib.optionalString config.environment.useSystemd ''
          hl.on("hyprland.shutdown", function()
            os.execute(${toLua "${pkgs.systemd}/bin/systemctl --user stop hyprland-session.target"})
          end)
        ''}
        ${cfg.extraConfig}
      '';
      "xdg-desktop-portal/hyprland-portals.conf".text = ''
        [preferred]
        default=hyprland;gtk
        org.freedesktop.impl.portal.FileChooser=gtk
        org.freedesktop.impl.portal.Secret=none
      '';
    }
    // lib.mapAttrs' (
      name: file:
      lib.nameValuePair "hypr/${lib.removeSuffix ".lua" name}.lua" (
        if builtins.isPath file.content || lib.hasPrefix "/" file.content then
          { source = file.content; }
        else
          { text = file.content; }
      )
    ) cfg.extraLuaFiles;
    systemd.targets.hyprland-session = lib.mkIf config.environment.useSystemd {
      description = "Hyprland compositor session";
      bindsTo = [ "graphical-session.target" ];
      unitConfig.PropagatesStopTo = [ "graphical-session.target" ];
      wants = [ "graphical-session-pre.target" ];
      after = [ "graphical-session-pre.target" ];
    };
    systemd.services.hyprpolkitagent = lib.mkIf config.environment.useSystemd {
      description = "Hyprland polkit agent";
      wantedBy = [ "hyprland-session.target" ];
      after = [ "hyprland-session.target" ];
      partOf = [ "hyprland-session.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent";
        Restart = "on-failure";
      };
    };
  };
}
