{config, ...}: let
  inherit (config.flake) hosts;
in {
  flake.modules.nixos.uff = {
    config,
    lib,
    ...
  }: let
    inherit (lib.strings) concatMapStringsSep;

    uffHosts = ["uff1" "uff2" "uff3"];

    # Exclude current host from BFD peers
    bfdPeers = let
      uffInterfaces =
        lib.concatMap (
          hostname:
            if hostname == config.networking.hostName
            then []
            else [
              hosts.${hostname}.interfaces.eno1.ipv4
              hosts.${hostname}.interfaces.enu2.ipv4
            ]
        )
        uffHosts;
      otherPeers = [
        # Other Hosts
        hosts.x570.interfaces.eno1.ipv4
        hosts.x570.interfaces.eno2.ipv4
        "192.168.49.2" # Cisco
      ];
    in
      concatMapStringsSep "\n" (n: "peer ${n}") (uffInterfaces ++ otherPeers);
  in {
    services.frr.config = ''
      int lo
       ip ospf area 0
       ip ospf passive
      int eno1
       ip ospf bfd
       ip ospf area 0
       ip ospf cost 1000
      int enu2
       ip ospf bfd
       ip ospf area 0
       ip ospf cost 400
      int eno1.3
       ip ospf area 0
       ip ospf cost 1001
      int eno1.4
       ip ospf area 0
       ip ospf cost 1000
      int enu2.5
       ip ospf area 0
       ip ospf cost 400
      int enu2.6
       ip ospf area 0
       ip ospf cost 401
      !
      bfd
       ${bfdPeers}
       peer 192.168.49.1
        transmit-interval 1000
        receive-interval 2000
    '';
  };
}
