{config, lib, ...}: let
  inherit (lib) mkOption types;
  cfg = config.custom.networking;
  mkLinkFile = {mac, name, mtu ? 1500}: ''
    [Match]
    MACAddress=${mac}

    [Link]
    Name=${name}
    MTUBytes=${builtins.toString mtu}
  '';
  mkNetFile = { name, addrs }: ''
    [Match]
    Name=${name}

    ${builtins.concatStringsSep "\n\n" (map (addr: ''
      [Address]
      Address=${addr}
    '') addrs)}
  '';

  addrOption = _: mkOption {
    type = types.listOf types.str;
  };
in {

  options.custom.networking = {
    lo.addrs = addrOption {};
    eno1.addrs = addrOption {};
    enmlx1 = {
      addrs = addrOption {};
      mac = mkOption {
        type = types.str;
      };
    };
    enmlx2 = {
      addrs = addrOption {};
      mac = mkOption {
        type = types.str;
      };
    };
  };

  # WIP: Move to just using systemd for renaming
  config.environment.etc = {
    "systemd/network/00-lo.network".text = mkNetFile {name = "lo"; addrs = cfg.lo.addrs;};
    "systemd/network/01-eno1.network".text = mkNetFile {name = "eno1"; addrs = cfg.eno1.addrs;};
    "systemd/network/10-enmlx1.link".text = mkLinkFile {mac = cfg.enmlx1.mac; name = "enmlx1"; mtu = 9000;};
    "systemd/network/11-enmlx1.network".text = mkNetFile {name = "enmlx1"; addrs = cfg.enmlx1.addrs;};
    "systemd/network/15-enmlx2.link".text = mkLinkFile {mac = cfg.enmlx2.mac; name = "enmlx2"; mtu = 9000;};
    "systemd/network/16-enmlx2.network".text = mkNetFile {name = "enmlx2"; addrs = cfg.enmlx2.addrs;};
  };
}
