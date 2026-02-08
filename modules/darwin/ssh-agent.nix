# The default SSH agent may be too old, such as on my
# M1 on sequoia, so swap for a controlled version one
{
  flake.modules.darwin.ssh-agent = {pkgs, ...}: let
    ssh = pkgs.writeShellScript "user-ssh-agent" ''
      #!/usr/bin/env zsh
      exec ${pkgs.openssh}/bin/ssh-agent -D -a $HOME/.ssh/ssh-agent.sock
    '';
  in {
    launchd.user.agents.ssh-agent = {
      serviceConfig = {
        ProgramArguments = ["${ssh}"];
        RunAtLoad = true;
        KeepAlive = true;
      };
    };
  };
}
