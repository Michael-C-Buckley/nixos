{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) optionals mkDefault mkOption mkEnableOption mkIf;
  inherit (lib.types) bool int;
  inherit (config.features) graphics;
  inherit (config.virtualisation) gns3;
  inherit (config.system) impermanence;
  gfxPkgs = with pkgs; [alacritty gns3-gui];
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

  config = mkIf gns3.enable {
    virtualisation.libvirtd.enable = mkDefault true;

    environment = {
      persistence."/cache".directories = optionals impermanence.enable ["/var/lib/gns3"];
      systemPackages = with pkgs;
        [dynamips gns3-server]
        ++ optionals graphics gfxPkgs;
    };

    # Open the firewall
    networking.firewall = mkIf gns3.openFirewall {
      allowedUDPPorts = [gns3.serverPort];
      allowedTCPPorts = [gns3.serverPort];
    };

    services.gns3-server = {
      enable = true;
      ubridge.enable = true;
    };
  };
}
