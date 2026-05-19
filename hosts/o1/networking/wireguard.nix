{
  config,
  flake,
  ...
}: let
  inherit (flake.functions) wireguard;
in {
  systemd.services = {
    "wireguard-clients" = wireguard {
      inherit config;
      name = "clients";
      ipAddresses = ["192.168.32.129/27" "fe80::32:129/64"];
    };
    "wireguard-mt1" = wireguard {
      inherit config;
      name = "mt1";
      ipAddresses = ["192.168.254.81/31" "fe80::254:81/64"];
    };
  };
}
