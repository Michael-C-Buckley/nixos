# NixOS Containers for Wireguard shared among UFFs
{
  self,
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (config.sops) secrets;

  mkWg = {
    localAddress,
    hostName,
    #wgInterface,
    cfgPath,
    ...
  }: {
    inherit localAddress;
    autoStart = true;
    privateNetwork = true;
    hostBridge = "br100";

    config = _: {
      environment = {
        enableAllTerminfo = true;
        systemPackages = with pkgs; [
          iproute2
          wireguard-tools
        ];
      };
      bindMounts.${cfgPath} = {
        hostPath = cfgPath;
        isReadOnly = true;
      };
      system.stateVersion = config.system.stateVersion;
      networking = {
        inherit hostName;
        defaultGateway.address = "192.168.52.1";
        nameservers = ["192.168.52.1"];
      };
    };
  };
in {
  # WIP: For testing, deploy only on UFF2 until proper clustering is completed
  containers = lib.mkIf (config.networking.hostName == "uff2") {
    wireguard-mt1 = mkWg {
      cfgPath = secrets."wg-mt1".path;
      hostName = "wireguard-mt1";
      localAddress = "192.168.52.11/26";
      wgInterface = self.lib.wireguard.genInterface {
        inherit config pkgs;
        name = "mt1";
        ipAddresses = ["192.168.254.81/31" "fe80::254:81/64"];
      };
    };
  };
}
