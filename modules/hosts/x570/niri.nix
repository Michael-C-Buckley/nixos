{config, ...}: let
  mon1 = "DP-1";
  mon2 = "HDMI-A-3";
in {
  flake.modules.nixos.x570 = {pkgs, ...}: {
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
          workspace "N9" { open-on-output "${mon2}"; }
          workspace "N0" { open-on-output "${mon2}"; }

          output "${mon1}" {
            mode "3440x1440@165.000"
            position x=0 y=0
            focus-at-startup
            layout { default-column-width { proportion 0.5; }; }
          }

          output "${mon2}" {
            mode "2560x1440@74.599"
            position x=3440 y=-500
            transform "270"
            layout { default-column-width { proportion 1.0; }; }
          }
        '';
      };
    };
  };
}
