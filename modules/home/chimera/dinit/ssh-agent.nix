{
  flake.modules.homeManager.chimera-ssh-agent = {
    pkgs,
    lib,
    ...
  }: let
    SOCK = "/home/michael/.ssh/ssh-agent.sock";
    pidFile = "/home/michael/.ssh/ssh-agent.pid";

    wrapper = pkgs.writeShellScriptBin "dinit-ssh-wrapper" ''
      dinitctl --user setenv SSH_AUTH_SOCK=${SOCK}

      /usr/bin/ssh-agent -D -a ${SOCK} &
      /usr/bin/echo $! > "${pidFile}"
      /usr/bin/chmod 0600 ${pidFile}

      # Wait for socket to appear, then add keys
      while [ ! -S ${SOCK} ]; do sleep 0.1; done
      /usr/bin/ssh-add /home/michael/.ssh/id_*

      exit 0
    '';

    kill-wrapper = pkgs.writeShellScriptBin "dinit-ssh-kill" ''
      /usr/bin/kill $(cat ${pidFile})
      /usr/bin/rm ${pidFile}
      /usr/bin/rm ${wrapper}
    '';
  in {
    home.file = {
      ".config/dinit.d/ssh-agent".text = ''
        type = bgprocess
        command = ${lib.getExe wrapper}
        pid-file = ${pidFile}
        stop-command = ${lib.getExe kill-wrapper}
        restart = yes
      '';
    };
  };
}
