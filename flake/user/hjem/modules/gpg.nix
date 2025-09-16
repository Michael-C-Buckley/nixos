{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkOption mkEnableOption mkIf getExe;
  inherit (lib.types) int package;
  inherit (config) gnupg;

  # Returns the line or empty based on the bool, used later with the agent config
  mkCfgLine = bool: string: (
    if bool
    then ''
      ${string}
    ''
    else ''''
  );
in {
  options.gnupg = {
    enable = mkEnableOption "Enable gnupg features for the user.";
    package = mkOption {
      type = package;
      default = pkgs.gnupg;
      description = "Which GnuPG package to use in userspace.";
    };
    pinentryPackage = mkOption {
      type = package;
      default = pkgs.pinentry-curses;
      description = "Which pinentry package to use with GnuPG";
    };
    agent = {
      allowLoopbackPinentry = mkEnableOption "Allow loopback pinentry.";
      enableSSHsupport = mkEnableOption "Enable SSH support for GnuPG";
      cacheTTL = mkOption {
        type = int;
        default = 1200;
        description = "The number of seconds to cache the authorization on the GnuPG key.";
      };
    };
    scdaemon.disable-ccid = mkEnableOption ''
      Stops the CCID conflict from pcscd and scdaemon.
      See: https://support.yubico.com/hc/en-us/articles/4819584884124-Resolving-GPG-s-CCID-conflicts
    '';
  };

  config = mkIf gnupg.enable {
    fileList = {
      ".gnupg/gpg-agent.conf".text =
        ''
          pinentry-program ${getExe gnupg.pinentryPackage}
          default-cache-ttl ${builtins.toString gnupg.agent.cacheTTL}
        ''
        + mkCfgLine gnupg.agent.enableSSHsupport "enable-ssh-support"
        + mkCfgLine gnupg.agent.allowLoopbackPinentry "allow-loopback-pinentry";

      ".gnupg/scdaemon" = {
        enable = gnupg.scdaemon.disable-ccid;
        text = ''disable-ccid'';
      };
    };
    packageList = [
      gnupg.package
      gnupg.pinentryPackage
    ];
  };
}
