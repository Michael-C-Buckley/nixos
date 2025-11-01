{
  flake.modules.nixos.ssh-agent = {
    config,
    lib,
    pkgs,
    ...
  }: let
    cfg = config.programs.ssh;
    askPasswordWrapper = pkgs.writeScript "ssh-askpass-wrapper" ''
      #! ${pkgs.runtimeShell} -e
      eval export $(systemctl --user show-environment | ${lib.getExe pkgs.gnugrep} -E '^(DISPLAY|WAYLAND_DISPLAY|XAUTHORITY)=')
      exec ${cfg.askPassword} "$@"
    '';
  in {
    # I enable and use GPG socket by default, so create an additional SSH socket that will not conflict
    # Taken from the Nixos SSH agent file:
    # https://github.com/NixOS/nixpkgs/blob/nixos-25.05/nixos/modules/programs/ssh.nix
    systemd.user.services.ssh-agent = {
      description = "SSH Agent";
      wantedBy = ["default.target"];
      unitConfig.ConditionUser = "!@system";
      serviceConfig = {
        ExecStartPre = "${pkgs.coreutils}/bin/rm -f %t/ssh-agent";
        ExecStart =
          "${cfg.package}/bin/ssh-agent "
          + lib.optionalString (cfg.agentTimeout != null) "-t ${cfg.agentTimeout} "
          + lib.optionalString (cfg.agentPKCS11Whitelist != null) "-P ${cfg.agentPKCS11Whitelist} "
          + "-a %t/ssh-agent";
        StandardOutput = "null";
        Type = "forking";
        Restart = "on-failure";
        SuccessExitStatus = "0 2";
      };
      # Allow ssh-agent to ask for confirmation. This requires the
      # unit to know about the user's $DISPLAY (via ‘systemctl
      # import-environment’).
      environment.SSH_ASKPASS = lib.optionalString cfg.enableAskPassword askPasswordWrapper;
      environment.DISPLAY = "fake"; # required to make ssh-agent start $SSH_ASKPASS
    };
  };
}
