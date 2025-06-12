# in your flake or default.nix
{pkgs, ...}: let
  inherit (pkgs) socat writeShellApplication;
in
  writeShellApplication {
    name = "relay";
    runtimeInputs = [pkgs.socat];

    checkPhase = ""; # Ignore the shell checks
    text = ''
      #!/usr/bin/env bash
      set -euo pipefail

      SSH_SOCK="/tmp/npiperelay-$PPID-ssh.sock"
      GPG_SOCK="/tmp/npiperelay-$PPID-gpg.sock"

      socat UNIX-LISTEN:"$SSH_SOCK",fork,mode=0600 \
          EXEC:"/mnt/c/wsl/npiperelay.exe -ei -s //./pipe/openssh-ssh-agent",nofork &

      socat UNIX-LISTEN:"$GPG_SOCK",fork,mode=0600 \
          EXEC:"/mnt/c/wsl/npiperelay.exe -ei -s //./pipe/gpg-agent",nofork &

      sleep 0.5
      echo "Sockets live on PID: $PPID"

      export SSH_AUTH_SOCK="$SSH_SOCK"
      export GPG_AGENT_SOCK="$GPG_SOCK"
      export GPG_AGENT_INFO="$GPG_SOCK"

      ssh-add -l
    '';
  }
