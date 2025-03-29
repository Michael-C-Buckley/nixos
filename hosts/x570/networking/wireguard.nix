{
  config,
  pkgs,
  lib,
  ...
}: let
  wireguardInterface = import ../../../modules/network/wireguard-interface.nix {inherit config pkgs lib;};
in {
  systemd.services = {
    "wireguard-mt1" = wireguardInterface {
      name = "mt1";
      # Path because Agenix is currently not working on the desktop, this is the local file workaround
      cfgPath = "/etc/wireguard/wg-mt1.conf";
      ipAddresses = ["192.168.240.241/31"];
    };
  };
}
