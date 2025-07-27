{config, ...}: let
  inherit (config.networking) loopback;
  mainIP = "192.168.65.133";
in {
  imports = [./filesystems.nix];

  # WIP: legacy options not long for this world
  cluster.ln.kubernetes.masterIP = mainIP;

  custom.routing.routerId = loopback.ipv4;

  networking = {
    hostId = "9db44f50";
    loopback.ipv4 = "192.168.78.133";
  };

  networkd = {
    enmlx1 = {
      mac = "f4:52:14:5e:22:20";
      addresses.ipv4 = ["192.168.254.3/29"];
    };
    enmlx2 = {
      mac = "f4:52:14:5e:22:21";
      addresses.ipv4 = ["192.168.254.20/29"];
    };
  };

  system = {
    boot.uuid = "93A8-3B45";
  };
}
