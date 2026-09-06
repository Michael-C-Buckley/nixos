{ pkgs, ... }:
let
  leds = [
    "/sys/class/leds/tpacpi::power"
    "/sys/class/leds/platform::micmute"
    "/sys/class/leds/platform::mute"
  ];
in
{
  systemd.services.night-led = {
    description = "Adjust status LEDs for nighttime";

    serviceConfig = {
      Type = "oneshot";
      ReadWritePaths = map (led: "${led}/brightness") leds;
    };

    path = [ pkgs.coreutils ];

    script = ''
      hour=$(date +%H)

      if ((10#$hour >= 20 || 10#$hour < 8)); then
        # Nighttime: turn LEDs off.
        for led in ${builtins.concatStringsSep " " leds}; do
          [[ -w "$led/brightness" ]] && echo 0 > "$led/brightness"
        done
      else
        # Daytime: restore each LED to its maximum brightness.
        for led in ${builtins.concatStringsSep " " leds}; do
          if [[ -w "$led/brightness" && -r "$led/max_brightness" ]]; then
            cat "$led/max_brightness" > "$led/brightness"
          fi
        done
      fi
    '';
  };

  systemd.timers.night-led = {
    description = "Adjust status LEDs at 20:00 and 08:00";
    wantedBy = [ "timers.target" ];

    timerConfig = {
      OnCalendar = [
        "*-*-* 20:00:00"
        "*-*-* 08:00:00"
      ];

      # Catch up if the laptop was suspended or powered off.
      Persistent = true;
      Unit = "night-led.service";
    };
  };
}
