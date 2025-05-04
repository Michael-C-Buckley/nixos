{
  config,
  lib,
  ...
}: let
  inherit (lib) mkOption strings types;
  netCfg = config.cluster.ln.networking;

  mkLinkFile = {
    mac,
    name,
    mtu ? 1500,
  }: ''
    [Match]
    MACAddress=${mac}

    [Link]
    Name=${name}
    MTUBytes=${builtins.toString mtu}
  '';

  strOption = _:
    mkOption {
      type = types.str;
    };

  # Function to convert a standard string address into the nix attrset format
  # Ex "192.168.1.1/24"
  addr = addrStr: let
    parts = strings.splitString "/" addrStr;
  in {
    address = builtins.elemAt parts 0;
    prefixLength = builtins.fromJSON (builtins.elemAt parts 1);
  };
in {
  options.cluster.ln.networking = {
    lo.addr = strOption {};
    eno1.addr = strOption {};
    enmlx1 = {
      addr = strOption {};
      mac = strOption {};
    };
    enmlx2 = {
      addr = strOption {};
      mac = strOption {};
    };
  };

  config = {
    # WIP: Deduplicate
    networking.interfaces = {
      lo.ipv4.addresses = [(addr netCfg.lo.addr)];
      eno1.ipv4.addresses = [(addr netCfg.eno1.addr)];
      enmlx1.ipv4.addresses = [(addr netCfg.enmlx1.addr)];
      enmlx2.ipv4.addresses = [(addr netCfg.enmlx2.addr)];
    };

    environment.etc = {
      "systemd/network/10-enmlx1.link".text = mkLinkFile {
        mac = netCfg.enmlx1.mac;
        name = "enmlx1";
        mtu = 9000;
      };
      "systemd/network/11-enmlx2.link".text = mkLinkFile {
        mac = netCfg.enmlx2.mac;
        name = "enmlx2";
        mtu = 9000;
      };
    };
  };
}
