let
  mon1 = "eDP-1";
in {
  flake.modules.nixos.t14 = {
    hjem.users.michael = {
      files.".config/niri/host.kdl".text = ''
        workspace "N1" { open-on-output "${mon1}"; }
        workspace "N2" { open-on-output "${mon1}"; }
        workspace "N3" { open-on-output "${mon1}"; }
        workspace "N4" { open-on-output "${mon1}"; }
        workspace "N5" { open-on-output "${mon1}"; }

        output "${mon1}" {
          mode "1920x1080@60.008"
          scale 1.0
        }
      '';
    };
  };
}
