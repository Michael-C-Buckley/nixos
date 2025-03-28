# WIP: trigger on login if after 9 PM

{...}: { 
  systemd.services.night-led-timer = let
    bash = "/run/current-system/sw/bin/bash";
    powerPath = "/sys/class/leds/tpacpi::power/brightness";
    micmutePath = "/sys/class/leds/platform::micmute/brightness";
    mutePath = "/sys/class/leds/platform::mute/brightness";
  in{
    description = "Automatically turn off the bright status LEDs at night";
    wantedBy = [];
    serviceConfig = {
      User = "root";
      Type = "oneshot";
      ReadWritePaths = [
        powerPath
        micmutePath
        mutePath
      ];
      ExecStart = [
        "${bash} -c 'echo 0 > ${powerPath}'"
        "${bash} -c 'echo 0 > ${mutePath}'"
        "${bash} -c 'echo 0 > ${micmutePath}'"
      ];
    };
  };

  systemd.timers.night-led-timer = {
    description = "Automatically turn off the bright status LEDs at night";
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = "21:00:00";
      Persistent = true;
    };
  };
}