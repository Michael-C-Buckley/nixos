{config, ...}: let
  inherit (config.flake) hosts lib;
in {
  flake.modules.nixos.ntp = {config, ...}: let
    inherit (config.networking) hostName;
    lo = hosts.${hostName}.interfaces.lo.ipv4;
  in {
    custom.impermanence.persist.directories = [
      "/var/lib/chrony"
    ];

    services.chrony = {
      enable = true;

      extraConfig = ''
        allow 192.168.0.0/16
        bindaddress ${lib.network.getAddress lo}"
        cmdport 0
        noclientlog
        makestep 1.0 3
        maxupdateskew 100.0
        local stratum 10 orphan
      '';
    };

    networking.firewall.allowedUDPPorts = [123];
  };
}
