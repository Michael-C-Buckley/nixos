{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkOption mkEnableOption mkIf getExe;
  inherit (lib.types) int package lines listOf str;
  inherit (config) gnupg;

  # Returns the line or empty based on the bool, used later with the agent config
  mkCfgLine = bool: string: (
    if bool
    then ''
      ${string}
    ''
    else ''''
  );

  mkExtraLinesOption = file:
    mkOption {
      type = lines;
      default = '''';
      description = "Extra lines added to the `${file}` file.";
    };
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
    config = {
      extraLines = mkExtraLinesOption "gpg.conf";
    };
    agent = {
      enable = mkEnableOption "Enable the GPG agent.";
      allowLoopbackPinentry = mkEnableOption "Allow loopback pinentry.";
      enableSSHsupport = mkEnableOption "Enable SSH support for GnuPG";
      cacheTTL = mkOption {
        type = int;
        default = 1200;
        description = "The number of seconds to cache the authorization on the GnuPG key.";
      };
      extraLines = mkExtraLinesOption "gpg-agent.conf";
      sshKeys = mkOption {
        type = listOf str;
        default = [];
        description = "Keygrips of GPG authorization keys to add to the GPG agent for SSH. Each string is a line and can contain the keygrip as well as timeout and other per-line options that SSH control normally uses.";
      };
    };
    scdaemon = {
      disable-ccid = mkEnableOption ''
        Stops the CCID conflict from pcscd and scdaemon.
        See: https://support.yubico.com/hc/en-us/articles/4819584884124-Resolving-GPG-s-CCID-conflicts
      '';
      extraLines = mkExtraLinesOption "scdaemon.conf";
    };
  };

  config = mkIf gnupg.enable {
    environment.sessionVariables = mkIf gnupg.agent.enableSSHsupport {
      SSH_AUTH_SOCKET = "/run/user/1000/gnupg/S.gpg-agent.ssh";
    };
    files = {
      ".gnupg/gpg.conf" = {
        # Currently only has the extra lines
        enable = gnupg.config.extraLines != '''';
        text = gnupg.config.extraLines;
      };

      ".gnupg/gpg-agent.conf" = {
        inherit (gnupg.agent) enable;
        text =
          ''
            pinentry-program ${getExe gnupg.pinentryPackage}
            default-cache-ttl ${builtins.toString gnupg.agent.cacheTTL}
          ''
          + mkCfgLine gnupg.agent.enableSSHsupport "enable-ssh-support"
          + mkCfgLine gnupg.agent.allowLoopbackPinentry "allow-loopback-pinentry";
      };

      ".gnupg/scdaemon.conf" = {
        enable = gnupg.scdaemon.disable-ccid || gnupg.scdaemon.extraLines != '''';
        text =
          gnupg.scdaemon.extraLines
          + (
            if gnupg.scdaemon.disable-ccid
            then "\ndisable-ccid"
            else ""
          );
      };
      ".gnupg/sshcontrol" = {
        enable = gnupg.agent.sshKeys != [];
        text = lib.concatStringsSep "\n" gnupg.agent.sshKeys;
      };
    };
    packages = [
      gnupg.package
      gnupg.pinentryPackage
    ];
  };
}
