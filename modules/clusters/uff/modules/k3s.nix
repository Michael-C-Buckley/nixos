{config, ...}: let
  inherit (config.flake.modules.nixos) k3s;
in {
  flake.modules.nixos.uff = {config, ...}: let
    inherit (config) networking;

    # Get the first (and only) IPv4 set on the loopback interface
    loopback = builtins.head networking.interfaces.lo.ipv4.addresses;
  in {
    imports = [k3s];

    services.k3s = {
      tokenFile = config.sops.secrets.k3s_token.path;

      extraFlags = [
        "--node-name ${networking.hostName}"
        "--node-ip ${loopback.address}"
        "--server https://192.168.61.1:6443"
        "--server https://192.168.61.2:6443"
        "--server https://192.168.61.3:6443"
      ];
    };
  };
}
