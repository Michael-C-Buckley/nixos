{
  flake.modules.nixos.uff = {lib, ...}: {
    services.keepalived.vrrpInstances = {
      wifi = {
        state = lib.mkDefault "BACKUP";
        interface = "wlan1";
        virtualRouterId = 2;
        virtualIps = [{addr = "172.16.248.30/16";}];
      };
      lan1 = {
        state = lib.mkDefault "BACKUP";
        interface = "eno1.3";
        virtualRouterId = 3;
        virtualIps = [{addr = "192.168.59.30/27";}];
      };
      lan2 = {
        state = lib.mkDefault "BACKUP";
        interface = "eno2.5";
        virtualRouterId = 4;
        virtualIps = [{addr = "192.168.59.94/27";}];
      };
    };
  };
}
