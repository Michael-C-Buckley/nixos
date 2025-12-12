let
  mon1 = "DP-1";
  mon2 = "HDMI-A-3";
in {
  flake.modules.nixos.x570 = {
    hjem.users.michael = {
      files.".config/niri/host.kdl".text = ''
        workspace "N1" { open-on-output "${mon1}"; }
        workspace "N2" { open-on-output "${mon1}"; }
        workspace "N3" { open-on-output "${mon1}"; }
        workspace "N4" { open-on-output "${mon1}"; }
        workspace "N5" { open-on-output "${mon1}"; }

        workspace "S1"  { open-on-output "${mon2}"; }
        workspace "S2"  { open-on-output "${mon2}"; }
        workspace "S3"  { open-on-output "${mon2}"; }
        workspace "S4"  { open-on-output "${mon2}"; }
        workspace "S5"  { open-on-output "${mon2}"; }

        output "${mon1}" {
          mode "3440x1440@165.000"
          position x=0 y=0
          focus-at-startup
        }

        output "${mon2}" {
          mode "2560x1440@74.599"
          position x=3440 y=-500
          transform "270"
        }
      '';
    };
  };
}
