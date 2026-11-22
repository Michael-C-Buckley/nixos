{ pkgs, ... }:
let
  nightLed = pkgs.callPackage ../modules/night-led-package.nix { };
in
{
  systemd.services.night-led = {
    description = "Adjust status LEDs for nighttime";

    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${nightLed.package}/bin/night-led apply";
      ReadWritePaths = map (led: "${led}/brightness") nightLed.leds;
    };
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
