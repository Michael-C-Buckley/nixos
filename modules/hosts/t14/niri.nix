{config, ...}: let
  mon1 = "eDP-1";
in {
  flake.modules.nixos.t14 = {pkgs, ...}: {
    programs.niri = {
      enable = true;
      package = config.flake.wrappers.mkNiri {
        inherit pkgs;
        extraConfig = ''
          workspace "N1" { open-on-output "${mon1}"; }
          workspace "N2" { open-on-output "${mon1}"; }
          workspace "N3" { open-on-output "${mon1}"; }
          workspace "N4" { open-on-output "${mon1}"; }
          workspace "N5" { open-on-output "${mon1}"; }
          workspace "N6" { open-on-output "${mon1}"; }
          workspace "N7" { open-on-output "${mon1}"; }
          workspace "N8" { open-on-output "${mon1}"; }
          workspace "N9" { open-on-output "${mon1}"; }
          workspace "N0" { open-on-output "${mon1}"; }


          output "${mon1}" {
            mode "1920x1080@60.008"
            scale 1.0
          }
        '';
      };
    };
  };
}
