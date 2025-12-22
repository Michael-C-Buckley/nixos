{config, ...}: let
  inherit (config.flake) modules hosts;
in {
  flake.modules.nixos.uff = {config, ...}: let
    inherit (config.networking) hostName;
    # This IP is the locally evaluated host's
    enu2 = hosts.${hostName}.interfaces.enu2-6.ipv4;
  in {
    imports = with modules.nixos; [
      k3s
      kube-longhorn
    ];

    services.k3s = {
      tokenFile = config.sops.secrets.k3s_token.path;
      serverAddr = enu2;
      extraFlags = [
        "--node-name ${hostName}s"
        "--node-ip ${enu2}"
        "--advertise-address ${enu2}"
        "--server https://${hosts.uff1.interfaces.enu2-6.ipv4}:6443" # Serves as the bootstrapper
      ];
    };
  };
}
