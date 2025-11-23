{
  flake.modules.nixos.uff = {lib, ...}: {
    services.keepalived.vrrpInstances = {
      wifi = {
        state = lib.mkDefault "BACKUP";
        interface = "wlp2s0";
        virtualRouterId = 2;
        virtualIps = [{addr = "172.16.248.30/16";}];
      };
    };
  };
}
