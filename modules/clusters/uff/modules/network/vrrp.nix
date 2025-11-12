{
  flake.modules.nixos.uff = {lib, ...}: {
    services.keepalived.vrrpInstances = {
      wan = {
        state = lib.mkDefault "BACKUP";
        interface = "eno1";
        virtualRouterId = 1;
        virtualIps = [{addr = "192.168.48.30/24";}];
      };
      wifi = {
        state = lib.mkDefault "BACKUP";
        interface = "wlp2s0";
        virtualRouterId = 2;
        virtualIps = [{addr = "172.16.248.30/16";} {addr = "172.30.248.30/16";}];
      };
    };
  };
}
