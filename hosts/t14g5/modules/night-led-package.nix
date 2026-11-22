# Status LEDs off from 20:00 to 08:00, shared by T14g5's NixOS timer and Finix
# service. `apply` sets the current period; `watch` reapplies only when the
# period changes, including after suspend.
{
  coreutils,
  lib,
  writeShellApplication,
}:
let
  leds = [
    "/sys/class/leds/tpacpi::power"
    "/sys/class/leds/platform::micmute"
    "/sys/class/leds/platform::mute"
  ];
in
{
  inherit leds;
  package = writeShellApplication {
    name = "night-led";
    runtimeInputs = [ coreutils ];
    text = ''
      leds=(${lib.escapeShellArgs leds})

      period() {
        local hour
        hour=$(date +%H)
        if ((10#$hour >= 20 || 10#$hour < 8)); then echo night; else echo day; fi
      }

      apply() {
        local led
        for led in "''${leds[@]}"; do
          if [[ "$1" == night ]]; then
            # Nighttime: turn LEDs off.
            if [[ -w "$led/brightness" ]]; then echo 0 > "$led/brightness"; fi
          elif [[ -w "$led/brightness" && -r "$led/max_brightness" ]]; then
            # Daytime: restore each LED to its maximum brightness.
            cat "$led/max_brightness" > "$led/brightness"
          fi
        done
      }

      case "''${1:-apply}" in
        apply) apply "$(period)" ;;
        watch)
          last=""
          while :; do
            current=$(period)
            if [[ "$current" != "$last" ]]; then
              apply "$current"
              last=$current
            fi
            sleep 60
          done
          ;;
        *)
          echo "usage: night-led [apply|watch]" >&2
          exit 2
          ;;
      esac
    '';
  };
}
