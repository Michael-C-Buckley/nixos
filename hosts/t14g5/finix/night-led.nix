{ pkgs, ... }:
let
  nightLed = pkgs.callPackage ../modules/night-led-package.nix { };
in
{
  # Finix has no calendar timers; a minute-resolution watcher replaces the
  # NixOS 08:00/20:00 timer and catches up after boot or resume.
  finit.services.night-led = {
    description = "Adjust status LEDs for nighttime";
    command = "${nightLed.package}/bin/night-led watch";
    log = { };
  };
}
