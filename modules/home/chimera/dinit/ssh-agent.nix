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
      /usr/bin/rm -f ${SOCK}
      /usr/bin/rm -f ${pidFile}

      /usr/bin/ssh-agent -D -a ${SOCK} &
      /usr/bin/echo $! > "${pidFile}"
      /usr/bin/chmod 0600 ${pidFile}

      # Wait for socket to appear, then add keys
      while [ ! -S ${SOCK} ]; do sleep 0.1; done
      for f in /home/michael/.ssh/id_*; do
        [[ -f "$f" && ! "$f" =~ \.pub$ ]] && /usr/bin/ssh-add "$f"
      done

      exit 0
    '';

    kill-wrapper = pkgs.writeShellScriptBin "dinit-ssh-kill" ''
      /usr/bin/kill $(cat ${pidFile})
      /usr/bin/rm -f ${pidFile}
      /usr/bin/rm -f ${SOCK}
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
