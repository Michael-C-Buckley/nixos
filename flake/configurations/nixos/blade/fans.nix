# Control SuperMicro Mother
{pkgs, ...}: {
  systemd.services.initialize-fans = {
    description = "Spin down SuperMicro Fans";
    wantedBy = ["basic.target"];
    before = ["multi-user.target"];
    after = ["systemd-modules-load.service"];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = [
        "${pkgs.ipmitool}/bin/ipmitool raw 0x30 0x70 0x66 0x01 0x00 0x00"
        "${pkgs.ipmitool}/bin/ipmitool raw 0x30 0x70 0x66 0x01 0x01 0x00"
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    ipmitool
  ];
}
