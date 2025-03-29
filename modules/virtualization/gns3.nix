{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  gns = config.custom.virtualisation.gns3;
in {
  options.custom.virtualisation.gns3 = {
    enable = mkEnableOption "GNS3";
  };

  config = mkIf gns.enable {
    environment.systemPackages = with pkgs; [
      dynamips
      alacritty # For the consoles for GNS nodes, for now, may change later
      gns3-gui
      gns3-server
    ];

    services.gns3-server = {
      enable = true;
      ubridge.enable = true;
    };
  };
}
