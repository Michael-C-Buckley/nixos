{
  config,
  lib,
  pkgs,
  ...
}:
let
  drivers = pkgs.buildEnv {
    name = "hjem-non-nixos-gpu";
    paths = [
      pkgs.mesa
      pkgs.libglvnd
      pkgs.libvdpau-va-gl
    ]
    ++ lib.optional pkgs.stdenv.hostPlatform.isx86_64 pkgs.intel-media-driver;
  };
  rule = pkgs.writeText "non-nixos-gpu.conf" "L+ /run/opengl-driver - - - - ${drivers}\n";
  setup = pkgs.writeShellApplication {
    name = "non-nixos-gpu-setup";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.systemd
    ];
    text = ''
      if [ "$EUID" -ne 0 ]; then echo "Run this command with sudo to install the graphics tmpfiles rule." >&2; exit 1; fi
      install -d /etc/tmpfiles.d /nix/var/nix/gcroots
      ln -sfn ${rule} /etc/tmpfiles.d/non-nixos-gpu.conf
      ln -sfn /etc/tmpfiles.d/non-nixos-gpu.conf /nix/var/nix/gcroots/non-nixos-gpu.conf
      systemd-tmpfiles --create non-nixos-gpu.conf
    '';
  };
in
{
  _file = __curPos.file;
  key = __curPos.file;
  assertions = [
    {
      assertion = config.environment.genericLinux && pkgs.stdenv.hostPlatform.isLinux;
      message = "generic-graphics is for non-NixOS Linux with Mesa drivers.";
    }
  ];
  packages = [ setup ];
  environment.sessionVariables = {
    XCURSOR_PATH = lib.mkDefault "${config.environment.profileDirectory}/share/icons:${config.xdg.data.directory}/icons:/usr/share/icons:/usr/share/pixmaps";
    TERMINFO_DIRS = lib.mkDefault "${config.environment.profileDirectory}/share/terminfo:/etc/terminfo:/lib/terminfo:/usr/share/terminfo";
  };
}
