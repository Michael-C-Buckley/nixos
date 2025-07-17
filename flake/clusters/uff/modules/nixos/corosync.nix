{
  config,
  inputs,
  ...
}: let
  inherit (config.sops.secrets) corosync-authkey hacluster-password;
in {
  imports = [inputs.pcsd.nixosModules.default];

  services.pcsd = {
    enable = true;
    enableBinaryCache = true;
    enableWebUI = true;
    clusterName = "uff";
    corosyncKeyFile = corosync-authkey.path;
    clusterUserPasswordFile = hacluster-password.path;

    virtualIps = [];

    systemdResources = [
      {
        systemdName = "wireguard-mt1";
        enable = true;
      }
    ];

    nodes = [
      {
        name = "uff1";
        nodeid = 1;
        ring_addrs = [
          "192.168.254.1"
          "192.168.61.1"
        ];
      }
      {
        name = "uff2";
        nodeid = 2;
        ring_addrs = [
          "192.168.254.2"
          "192.168.61.2"
        ];
      }
      {
        name = "uff3";
        nodeid = 3;
        ring_addrs = [
          "192.168.254.3"
          "192.168.61.3"
        ];
      }
    ];
  };
}
