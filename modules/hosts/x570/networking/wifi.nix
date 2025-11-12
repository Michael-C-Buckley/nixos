{config, ...}: {
  flake.modules.nixos.x570 = {
    imports = [config.flake.modules.nixos.home-wifi];
    networking.networkmanager.ensureProfiles.profiles = {
      home = {
        connection.interface-name = "wlp5s0";
        ipv4.address = "172.16.248.10/16";
        ipv6.address = "fe80::570/64";
      };
      home2 = {
        connection.interface-name = "wlp5s0";
        ipv4.address = "172.30.248.10/16";
        ipv6.address = "fe80::570/64";
      };
    };
  };
}
