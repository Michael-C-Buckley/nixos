{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.ssh-agent;
  loader = pkgs.writeShellApplication {
    name = "ssh-agent-load-active";
    runtimeInputs = [
      cfg.package
      pkgs.coreutils
    ];
    text = builtins.readFile ../../../configs/ssh-agent/linux/load-active.sh;
  };
  socket = "%t/${cfg.socket}";
  sessionSocket =
    lib.replaceStrings [ "$XDG_RUNTIME_DIR" "\${XDG_RUNTIME_DIR}" ] [ "%t" "%t" ]
      config.environment.sessionVariables.SSH_AUTH_SOCK;
  sessionAgents = [
    "ssh-agent.service"
  ]
  ++ lib.optional (lib.hasInfix "ssh-tpm-agent.sock" sessionSocket) "ssh-tpm-agent.service";
  sessionAgent = pkgs.writeShellApplication {
    name = "ssh-agent-session";
    runtimeInputs = [
      cfg.package
      pkgs.coreutils
      pkgs.inotify-tools
      pkgs.util-linux
    ];
    text = ''
      : "''${XDG_RUNTIME_DIR:?A login session must provide XDG_RUNTIME_DIR}"
      umask 077
      export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/${cfg.socket}"
      install -d -m 0700 "$HOME/.ssh" "$HOME/.ssh/active" "$(dirname "$SSH_AUTH_SOCK")"
      exec 8>"$SSH_AUTH_SOCK.lock"
      flock -n 8 || exit 0
      status=0
      ssh-add -l >/dev/null 2>&1 || status=$?
      if [ "$status" -ne 2 ]; then
        echo "Using existing SSH agent at $SSH_AUTH_SOCK" >&2
        exit 0
      fi
      if [ -S "$SSH_AUTH_SOCK" ]; then rm "$SSH_AUTH_SOCK"; fi
      ssh-agent -D -a "$SSH_AUTH_SOCK" ${
        lib.optionalString (
          cfg.pkcs11Whitelist != [ ]
        ) "-P ${lib.escapeShellArg (lib.concatStringsSep "," cfg.pkcs11Whitelist)}"
      } 8>&- &
      agent=$!
      watcher=""
      cleanup() {
        if [ -n "$watcher" ]; then kill "$watcher" 2>/dev/null || true; fi
        kill "$agent" 2>/dev/null || true
        wait "$agent" 2>/dev/null || true
        rm -f "$SSH_AUTH_SOCK"
      }
      trap cleanup EXIT
      trap 'exit 0' HUP INT TERM
      exec {events}< <(inotifywait -m -q -e close_write,create,moved_to,delete "$HOME/.ssh/active" 8>&-)
      watcher=$!
      ${loader}/bin/ssh-agent-load-active
      while kill -0 "$agent" 2>/dev/null && kill -0 "$watcher" 2>/dev/null; do
        if read -r -t 2 -u "$events"; then
          ${loader}/bin/ssh-agent-load-active
        fi
      done
    '';
  };
in
{
  _file = __curPos.file;
  key = __curPos.file;
  options.services.ssh-agent = {
    enable = lib.mkEnableOption "the OpenSSH agent and active-key watcher" // {
      default = true;
    };
    package = lib.mkPackageOption pkgs "openssh" { };
    socket = lib.mkOption {
      type = lib.types.strMatching "[A-Za-z0-9._/-]+";
      default = "ssh-agent";
      description = "Socket path relative to XDG_RUNTIME_DIR.";
    };
    pkcs11Whitelist = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Allowed PKCS11 provider patterns.";
    };
    sessionCommand = lib.mkOption {
      type = lib.types.str;
      readOnly = true;
      description = "Foreground agent and active-key watcher for a session without systemd.";
    };
  };
  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = pkgs.stdenv.hostPlatform.isLinux;
        message = "ssh-agent-linux requires Linux.";
      }
    ];
    packages = [ cfg.package ];
    services.ssh-agent.sessionCommand = "${sessionAgent}/bin/ssh-agent-session";
    environment.sessionVariables.SSH_AUTH_SOCK = lib.mkDefault "\${XDG_RUNTIME_DIR}/${cfg.socket}";
    # Start these units when activating the profile in an existing session.
    activation.commands."20-ssh-agent" = lib.mkIf config.environment.useSystemd ''
      if [ -S "$XDG_RUNTIME_DIR/bus" ]; then
        ${pkgs.systemd}/bin/systemctl --user start ssh-agent-load-active.path set-SSH_AUTH_SOCK.service
      fi
    '';
    systemd = lib.mkIf config.environment.useSystemd {
      services = {
        set-SSH_AUTH_SOCK = {
          description = "Publish the SSH agent socket to desktop applications";
          wantedBy = [ "default.target" ];
          wants = [ "dbus.socket" ] ++ sessionAgents;
          after = [ "dbus.socket" ] ++ sessionAgents;
          serviceConfig = {
            Type = "oneshot";
            Environment = [ "SSH_AUTH_SOCK=${sessionSocket}" ];
            ExecStart = "${pkgs.dbus}/bin/dbus-update-activation-environment --systemd SSH_AUTH_SOCK";
          };
        };
        ssh-agent = {
          description = "SSH authentication agent";
          wantedBy = [ "default.target" ];
          serviceConfig = {
            ExecStart =
              "${cfg.package}/bin/ssh-agent -D -a ${socket}"
              + lib.optionalString (
                cfg.pkcs11Whitelist != [ ]
              ) " -P '${lib.concatStringsSep "," cfg.pkcs11Whitelist}'";
            ExecStartPre = "${pkgs.coreutils}/bin/install -d -m 0700 %h/.ssh %h/.ssh/active %t/${builtins.dirOf cfg.socket}";
            ExecStartPost = "${loader}/bin/ssh-agent-load-active";
            Environment = [ "SSH_AUTH_SOCK=${socket}" ];
            Restart = "on-failure";
            RestartSec = 2;
            UMask = "0077";
            SuccessExitStatus = 2;
          };
        };
        ssh-agent-load-active = {
          description = "Load keys from ~/.ssh/active";
          requires = [ "ssh-agent.service" ];
          after = [ "ssh-agent.service" ];
          serviceConfig = {
            Type = "oneshot";
            ExecStart = "${loader}/bin/ssh-agent-load-active";
            Environment = [ "SSH_AUTH_SOCK=${socket}" ];
          };
        };
      };
      paths.ssh-agent-load-active = {
        description = "Watch ~/.ssh/active for downloaded keys";
        wantedBy = [
          "default.target"
          "ssh-agent.service"
        ];
        pathConfig = {
          PathChanged = "%h/.ssh/active";
          Unit = "ssh-agent-load-active.service";
        };
      };
    };
  };
}
