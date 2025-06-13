# in your flake or default.nix
{pkgs, ...}: let
  inherit (pkgs) socat writeShellApplication;
in
  writeShellApplication {
    name = "relay";
    runtimeInputs = [socat];

    checkPhase = ""; # Ignore the shell checks
    text = ''
      #!/usr/bin/env bash
      set -euo pipefail

      SSH_SOCK="/tmp/npiperelay-$PPID-ssh.sock"

      socat UNIX-LISTEN:"$SSH_SOCK",fork,mode=0600 \
          EXEC:"/mnt/c/wsl/npiperelay.exe -ei -s //./pipe/openssh-ssh-agent",nofork &

      sleep 0.5
      echo "SSH:  export SSH_AUTH_SOCK=$SSH_SOCK"
    '';
  }
