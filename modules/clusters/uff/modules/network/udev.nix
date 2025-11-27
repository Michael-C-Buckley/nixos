{
  flake.modules.nixos.uff = {config, ...}: {
    services.udev = {
      extraRules = ''
        SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="${config.custom.enusb1.mac}", NAME="enusb1"
      '';
    };
  };
}
