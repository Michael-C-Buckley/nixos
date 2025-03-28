{config, lib, pkgs, ...}: let
  inherit (lib) types mkOption mkEnableOption mkIf;
  dm = config.features.displayManager;
in {
  options.features = {
    autoLogin = mkEnableOption {};
    displayManager = mkOption {
      type = types.enum ["sddm" "ly"];
      default = "ly";
      description = "Which display manager to run";
    };
    graphics = mkOption {
      type = types.bool;
      default = true;
      description = "Enable graphical features on host.";
    };
  };


  config = mkIf config.features.graphics {
    hardware.graphics.enable = true;

    services = {
      xserver.enable = true;
      displayManager = {
        # Generic/Combined
        autoLogin = mkIf (dm != "ly") {
          enable = config.features.autoLogin;
          user = "michael";
        };
        defaultSession = "hyprland";

        sddm = {
          enable = mkIf (dm == "sddm") true;
          theme = "chili";
        };

        ly.enable = mkIf (dm == "ly") true;
      };
    };

    environment.systemPackages =  with pkgs; mkIf (dm == "sddm") [
      sddm-chili-theme
    ];
  };
}
