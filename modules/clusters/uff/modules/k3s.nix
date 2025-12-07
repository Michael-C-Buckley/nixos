{config, ...}: let
  inherit (config.flake) modules hosts;
in {
  flake.modules.nixos.uff = {config, ...}: let
    inherit (builtins) head;
    # This IP is the locally evaluated host's
    enusb = (head config.networking.interfaces.enu2.ipv4.addresses).address;
  in {
    imports = with modules.nixos; [
      k3s
      kube-longhorn
    ];

    services.k3s = {
      tokenFile = config.sops.secrets.k3s_token.path;
      serverAddr = enusb;
      extraFlags = [
        "--node-name ${config.networking.hostName}s"
        "--node-ip ${enusb}"
        "--advertise-address ${enusb}"
        "--server https://${hosts.uff1.interfaces.enu2.ipv4}:6443" # Serves as the bootstrapper
      ];
    };
  };
}
