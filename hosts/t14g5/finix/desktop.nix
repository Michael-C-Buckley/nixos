{
  config,
  lib,
  modules,
  pkgs,
  ...
}:
let
  home = config.hjem.users.michael;
  session = pkgs.writeShellScript "start-t14f-hyprland" ''
    set -eu
    while [ ! -r /var/lib/hjem/manifest-michael.json ]; do
      ${pkgs.coreutils}/bin/sleep 0.1
    done
    . ${home.environment.loadEnv}
    export PATH="${home.environment.profileDirectory}/bin:/run/wrappers/bin:/run/current-system/sw/bin:$PATH"
    export XDG_CURRENT_DESKTOP=Hyprland
    export XDG_SESSION_DESKTOP=Hyprland
    export XDG_SESSION_TYPE=wayland
    exec ${pkgs.dbus}/bin/dbus-run-session -- ${config.programs.hyprland.package}/bin/start-hyprland
  '';
  # NixOS socket-activates the upstream user unit; here the detector creates
  # $XDG_RUNTIME_DIR/yubikey-touch-detector.socket itself.
  touchDetector = pkgs.writeShellScript "yubikey-touch-detector-session" ''
    export PATH=${lib.makeBinPath [ pkgs.gnupg ]}:$PATH
    export YUBIKEY_TOUCH_DETECTOR_LIBNOTIFY=1
    exec ${lib.getExe pkgs.yubikey-touch-detector}
  '';
  sessionFile = pkgs.writeTextDir "share/wayland-sessions/hyprland.desktop" ''
    [Desktop Entry]
    Name=Hyprland
    Comment=Hyprland with the T14 Hjem desktop
    Exec=${session}
    Type=Application
    DesktopNames=Hyprland
  '';
in
{
  imports = [
    modules.bluetooth
    modules.brightnessctl
    modules.dconf
    modules.pipewire
    modules.wireplumber
    modules.power-profiles-daemon
    modules.rtkit
    modules.upower
  ];

  hjem.users.michael = {
    imports = [ ../hjem/desktop.nix ];
    environment.sessionVariables = {
      HYPRLAND_POWER_COMMAND = "loginctl";
      NIXOS_OZONE_WL = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      GDK_BACKEND = "wayland,x11";
      QT_QPA_PLATFORM = "wayland;xcb";
      _JAVA_AWT_WM_NONREPARENTING = "1";
    };
    programs = {
      hyprland.execOnce = [
        home.services.ssh-agent.sessionCommand
        "${config.programs.pipewire.package}/bin/pipewire"
        (lib.getExe home.programs.noctalia.package)
        "${touchDetector}"
      ];
      # Hyprland starts the authorization agent on Finix.
      noctalia.settings.shell.polkit_agent = false;
    };
  };

  # The greeter's menu and its initial session must load the same Hjem environment.
  environment.systemPackages = [ (lib.setPrio (-20) sessionFile) ];
  services.greetd.settings.initial_session.command = "${session}";
  # Wait for tmpfiles before login and for the first Hjem manifest in the
  # session wrapper. Later Hjem activations can run while greetd stays up.
  finit.services.greetd.conditions = [ "task/tmpfiles-setup/success" ];
  boot.kernelModules = [ "i2c-dev" ];
  users.groups.i2c = { };
  users.users.michael.extraGroups = [
    "audio"
    "i2c"
  ];

  programs = {
    brightnessctl.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      # PipeWire starts its dependents after opening the session sockets.
      settings."context.exec" = [
        {
          path = "${config.programs.pipewire.package}/bin/pipewire-pulse";
          args = "";
        }
        {
          path = "${config.programs.wireplumber.package}/bin/wireplumber";
          args = "";
        }
      ];
    };
    wireplumber.enable = true;
    # Sets GIO_EXTRA_MODULES, so GTK applications use the dconf settings that
    # Hjem loads instead of an in-memory GSettings backend.
    dconf.enable = true;
  };
  services = {
    bluetooth.enable = true;
    upower.enable = true;
    power-profiles-daemon.enable = true;
    rtkit.enable = true;
    udev.packages = [
      pkgs.ddcutil
      (pkgs.writeTextDir "lib/udev/rules.d/70-t14f-i2c.rules" ''
        SUBSYSTEM=="i2c-dev", GROUP="i2c", MODE="0660"
      '')
    ];
  };
  xdg = {
    sounds.enable = true;
    portal = {
      enable = true;
      portals = [
        pkgs.xdg-desktop-portal-hyprland
        pkgs.xdg-desktop-portal-gtk
      ];
    };
  };
}
