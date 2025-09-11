{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkOption mkEnableOption mkIf getExe;
  inherit (lib.types) int package;
  inherit (config) gnupg;
in {
  options.gnupg = {
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
  };

  config = mkIf gnupg.enable {
    fileList = {
      ".gnupg/gpg-agent.conf".text =
        ''
          allow-loopback-pinentry
          pinentry-program ${getExe gnupg.pinentryPkg}
          default-cache-ttl ${builtins.toString gnupg.cacheTTL}
        ''
        + (
          if gnupg.enableSSHsupport
          then ''
            enable-ssh-support
          ''
          else ''''
        );
    };
    packageList = [
      gnupg.package
      gnupg.pinentryPkg
    ];
  };
}
