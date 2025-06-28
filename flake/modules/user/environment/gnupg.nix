# This idea is something I got from Iynaix and LuminarLeaf
# Leaf: https://github.com/LuminarLeaf/arboretum/blob/c5babe771d969e2d99b5fb373815b1204705c9b1/modules/user/shell/cli-tools.nix#L32
# Iynaix: https://github.com/iynaix/dotfiles/blob/ab3e10520ac824af76b08fac20eeed9a4c3f100a/home-manager/shell/nix.nix#L351
{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkOption mkEnableOption mkIf getExe;
  inherit (lib.types) int package;

  local = config.environment.gnupg;
in {
  options.environment.gnupg = {
    enable = mkEnableOption "Enable gnupg features for the user.";
    package = mkOption {
      type = package;
      default = pkgs.gnupg;
      description = "Which GnuPG package to use in userspace.";
    };
    enableSSHsupport = mkEnableOption "Enable SSH support for GnuPG";
    cacheTTL = mkOption {
      type = int;
      default = 1200;
      description = "The number of seconds to cache the authorization on the GnuPG key.";
    };
    pinentryPkg = mkOption {
      type = package;
      default = pkgs.pinentry-curses;
      description = "Which pinentry package to use with GnuPG";
    };
    enableExtraSocket = mkEnableOption "Add the extra socket required for agent forwarding.";
  };

  config = mkIf local.enable {
    fileList = {
      ".gnupg/gpg.conf".text = ''
        auto-key-locate local
        auto-key-retrieve
      '';

      ".gnupg/gpg-agent.conf".text =
        ''
          allow-loopback-pinentry
          pinentry-program ${getExe local.pinentryPkg}
          default-cache-ttl ${builtins.toString local.cacheTTL}
        ''
        + (
          if local.enableSSHsupport
          then "enable-ssh-support"
          else ""
        )
        + (
          if local.enableExtraSocket
          then "extra-socket"
          else ""
        );

      ".gnupg/scdaemon.conf".text = ''
        # Stops the CCID conflict from pcscd and scdaemon
        # https://support.yubico.com/hc/en-us/articles/4819584884124-Resolving-GPG-s-CCID-conflicts
        disable-ccid
      '';
    };
    packageList = [
      local.package
      local.pinentryPkg
    ];
  };
}
