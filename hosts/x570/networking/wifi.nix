{config, ...}: {
  flake.modules.nixos.x570 = {
    imports = [config.flake.modules.nixos.wifi-home];
    networking.networkmanager.ensureProfiles.profiles = {
      home = {
        connection.interface-name = "wlo1";
        ipv4.address = "172.16.166.10/16";
        ipv6.address = "fe80::570/64";
      };
      home2 = {
        connection.interface-name = "wlo1";
        ipv4.address = "172.30.166.10/16";
        ipv6.address = "fe80::570/64";
      };
    };
  };
}
