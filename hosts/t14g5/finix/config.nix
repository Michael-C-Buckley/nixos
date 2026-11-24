{
  lib,
  modules,
  pkgs,
  ...
}:
{
  imports = [
    ../modules/boot.nix
    ./filesystems.nix
    ../modules/hardware.nix
    ./night-led.nix
    ../../../modules/finix/presets/desktop.nix
    ../../../modules/finix/system/lanzaboote.nix
    modules.fcron
    modules.tuigreet
    ./desktop.nix
    ./network.nix
  ];

  # Finit boots to runlevel 2 by default, but finix's seatd and greetd only run
  # in runlevels 3-4. Other services use finit's default of 2-4.
  finit.runlevel = 3;

  # Finit mounts fstab before starting services. Refuse to start the daemon
  # against an unmounted alternate store if that mount failed.
  finit.services.nix-daemon.exec-start-pre = "${pkgs.util-linux}/bin/mountpoint -q /var/lib/machines/nixos/nix";

  users.users.michael = {
    uid = 1000;
    extraGroups = [ "video" ];
  };

  environment = {
    systemPackages = with pkgs; [
      busybox
      iproute2
      shadow
      # NixOS default packages that busybox does not provide.
      rsync
      strace
    ];
    etc = {
      sudoers.text = lib.mkAfter ''
        Defaults env_keep += "SSH_AUTH_SOCK"
      '';
    };
  };

  hardware = {
    firmware = [ pkgs.linux-firmware ];
    graphics.enable = true;
  };

  programs = {
    tuigreet = {
      enable = true;
      extraArgs = [
        "--time"
        "--remember"
        "--remember-session"
        "--asterisks"
        "--sessions"
        "/run/current-system/sw/share/wayland-sessions"
      ];
    };
  };

  security.pam.services.sudo.text = lib.mkBefore ''
    auth sufficient ${pkgs.pam_rssh}/lib/libpam_rssh.so auth_key_file=/etc/ssh/authorized_keys.d/$ruser cue
  '';

  services = {
    # Scheduler backend for persistent tasks such as the monthly Btrfs scrub.
    fcron.enable = true;
    udev.enable = true;
    dbus.enable = true;
    # elogind provides seats for Hyprland and XDG_RUNTIME_DIR via pam_elogind.
    # seatd's pam_rundir drops to the user's UID before creating
    # /run/user/<uid> in the root-owned /run/user, so the variable never got set.
    elogind.enable = true;
    # Lets the greeter and active sessions use `loginctl poweroff`/`reboot`.
    polkit.enable = true;
    # The desktop module supplies the initial Hyprland session.
    # After logout, greetd falls back to tuigreet; tty2 remains available.
    greetd.settings = {
      terminal.vt = 1;
      initial_session.user = "michael";
    };
    # Fallback console login while greetd owns tty1.
    getty.ttys = [ "tty2" ];
    nix-daemon.settings = {
      experimental-features = [ "read-only-local-store" ];
      # Trust only the other local installation's unsigned builds for now.
      extra-substituters = [
        "local?root=/var/lib/machines/nixos&read-only=true&trusted=true&priority=10"
      ];
      always-allow-substitutes = true;
    };
  };
}
