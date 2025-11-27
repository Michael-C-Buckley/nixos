{config, ...}: let
  inherit (config.flake.modules) nixos;
in {
  flake.modules.nixos.uff = {config, ...}: let
    inherit (builtins) head;
    enusb = (head config.networking.interfaces.enusb1.ipv4.addresses).address;
  in {
    imports = with nixos; [
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
        "--server https://192.168.61.145:6443" # Serves as the bootstrapper
      ];
    };
  };
}
