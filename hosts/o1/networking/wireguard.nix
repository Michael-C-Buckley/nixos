{
  flake.modules.nixos.o1 = {
    config,
    functions,
    ...
  }: let
    inherit (functions.wireguard) genInterface;
  in {
    systemd.services = {
      "wireguard-clients" = genInterface {
        inherit config;
        name = "clients";
        ipAddresses = ["192.168.32.129/27" "fe80::32:129/64"];
      };
      "wireguard-mt1" = genInterface {
        inherit config;
        name = "mt1";
        ipAddresses = ["192.168.254.81/31" "fe80::254:81/64"];
      };
    };
  };
}
