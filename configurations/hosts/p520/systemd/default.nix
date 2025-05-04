{...}: {
  systemd.services.shutdown-timer = {
    description = "Shutdown the system at night";
    wantedBy = [];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "/run/current-system/sw/bin/systemctl poweroff";
    };
  };

  systemd.timers.shutdown-timer = {
    description = "Timer to shut down the system at a specific time";
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = "22:00:00";
      Persistent = true;
    };
  };
}
