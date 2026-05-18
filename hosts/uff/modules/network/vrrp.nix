{
  flake.modules.nixos.uff = {lib, ...}: {
    services.keepalived.vrrpInstances = {
      wifi = {
        state = lib.mkDefault "BACKUP";
        interface = "wlan1";
        virtualRouterId = 2;
        virtualIps = [{addr = "172.16.166.30/16";}];
      };
      lan = {
        state = lib.mkDefault "BACKUP";
        interface = "br1";
        virtualRouterId = 3;
        virtualIps = [{addr = "192.168.59.30/27";}];
      };
    };
  };
}
