{config, ...}: let
  inherit (config.flake) modules hosts;
  inherit (config.flake.lib.network) getAddress;
in {
  flake.modules.nixos.uff = {
    config,
    lib,
    ...
  }: let
    inherit (config.networking) hostName;
    # This IP is the locally evaluated host's
    enu2 = getAddress hosts.${hostName}.interfaces.enu2.ipv4;
  in {
    imports = with modules.nixos; [
      k3s
      kube-longhorn
    ];

    services.k3s = {
      tokenFile = config.sops.secrets.k3s_token.path;
      clusterInit = hostName == "uff1";
      extraFlags =
        [
          "--node-name ${hostName}s"
          "--node-ip ${enu2}"
          "--advertise-address ${enu2}"
        ]
        ++ lib.optionals (hostName != "uff1") [
          "--server https://${getAddress hosts.uff1.interfaces.enu2.ipv4}:6443" # Serves as the bootstrapper
        ];
    };
  };
}
