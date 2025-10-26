{config, ...}: let
  inherit (config.flake.modules.nixos) k3s;
in {
  flake.modules.nixos.uff = {config, ...}: let
    inherit (builtins) head split;
    # Get the first (and only) IPv4 set on the loopback interface
    #loopback = (builtins.head networking.interfaces.lo.ipv4.addresses).address;
    # loopback severely complicated L3 routing, so fallback to best common interface for now
    enusb = head (split "/" (head config.networkd.enusb1.addresses.ipv4));
  in {
    imports = [k3s];

    networking.hosts = {
      "192.168.254.1" = ["uff1s"];
      "192.168.254.2" = ["uff2s"];
      "192.168.254.3" = ["uff3s"];
    };

    services.k3s = {
      tokenFile = config.sops.secrets.k3s_token.path;
      serverAddr = enusb;
      extraFlags = [
        "--node-name ${config.networking.hostName}s"
        "--node-ip ${enusb}"
        "--advertise-address ${enusb}"
        "--server https://192.168.254.1:6443" # Serves as the bootstrapper
      ];
    };
  };
}
