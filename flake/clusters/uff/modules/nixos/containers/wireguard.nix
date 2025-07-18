# NixOS Containers for Wireguard shared among UFFs
{
  self,
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) splitString elemAt mkDefault;

  mkInterface = {
    hostName,
    ipAddresses,
  }:
    self.lib.wireguard.genInterface {
      inherit config pkgs ipAddresses;
      name = elemAt (splitString "-" hostName) 1;
    };

  mkNspawn = {
    localAddress,
    hostName,
    ipAddresses,
    ...
  }: let
    cfgPath = config.sops.secrets.${hostName}.path;
    hostConfig = config;
  in {
    inherit localAddress;
    # For now, deploying manually on the selected nodes
    autoStart = mkDefault false;
    bindMounts.${cfgPath}.hostPath = cfgPath;
    privateNetwork = true;
    hostBridge = "br100";
    ephemeral = true;
    enableTun = true;

    config = {pkgs, ...}: {
      environment.systemPackages = with pkgs; [iproute2 wireguard-tools];
      system.stateVersion = hostConfig.system.stateVersion;
      systemd.services.${hostName} = mkInterface {inherit hostName ipAddresses;};
      networking = {
        inherit hostName;
        defaultGateway.address = "192.168.52.1";
        nameservers = ["192.168.52.1"];
      };
    };
  };
in {
  containers = {
    wireguard-mt1 = mkNspawn {
      hostName = "wireguard-mt1";
      localAddress = "192.168.52.11/26";
      ipAddresses = ["192.168.254.81/31" "fe80::254:81/64"];
    };
  };
}
