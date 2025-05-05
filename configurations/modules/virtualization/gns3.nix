{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkDefault mkOption mkEnableOption mkIf;
  inherit (lib.types) bool int;
  gns = config.virtualisation.gns3;
in {
  options.virtualisation.gns3 = {
    enable = mkEnableOption "GNS3";
    serverPort = mkOption {
      type = int;
      default = 3080;
      description = "GNS3 server listen port";
    };
    openFirewall = mkOption {
      type = bool;
      default = true;
      description = "Add a firewall allow entry for TCP and UDP on the server listen port";
    };
  };

  config = mkIf gns.enable {
    # Enable Libvirt if using this
    virtualisation.libvirtd.enable = mkDefault true;

    environment.systemPackages = with pkgs; [
      dynamips
      alacritty # For the consoles for GNS nodes, for now, may change later
      gns3-gui
      gns3-server
    ];

    # Open the firewall
    networking.firewall = mkIf gns.openFirewall {
      allowedUDPPorts = [gns.serverPort];
      allowedTCPPorts = [gns.serverPort];
    };

    services.gns3-server = {
      enable = true;
      ubridge.enable = true;
    };
  };
}
