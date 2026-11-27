# A simple timer to get my loaded kernel mod info
# For more info, see classic and robust resources:
# https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Kernel
# https://wiki.archlinux.org/title/Modprobed-db
{
  lib,
  pkgs,
  ...
}:
let
  stateDirectory = "/var/lib/modprobed-db";
  modprobedDb = lib.getExe pkgs.modprobed-db;
in
{
  users.groups.modprobed-db = { };
  users.users.modprobed-db = {
    isSystemUser = true;
    group = "modprobed-db";
    home = stateDirectory;
  };

  systemd.services.modprobed-db = {
    description = "Record loaded kernel modules with modprobed-db";
    path = with pkgs; [
      gawk
      getent
    ];
    environment = {
      XDG_CONFIG_HOME = "/var/lib";
      XDG_DATA_HOME = "/var/lib";
    };
    serviceConfig = {
      Type = "oneshot";
      User = "modprobed-db";
      Group = "modprobed-db";
      StateDirectory = "modprobed-db";
      PrivateTmp = true;
      NoNewPrivileges = true;
    };
    script = ''
      # The first invocation creates the config and exits before scanning.
      if [ ! -f ${stateDirectory}/modprobed-db.conf ]; then
        ${modprobedDb} storesilent
      fi
      exec ${modprobedDb} storesilent
    '';
  };

  systemd.timers.modprobed-db = {
    description = "Periodically record loaded kernel modules";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnActiveSec = "30s";
      OnUnitActiveSec = "10min";
      AccuracySec = "1s";
    };
  };
}
