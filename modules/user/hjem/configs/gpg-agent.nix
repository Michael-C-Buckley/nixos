{
  flake.hjemConfig.gpgAgent = {
    hjem.users.michael = {
      gnupg = {
        agent = {
          enable = true;
          allowLoopbackPinentry = true;
          enableSSHsupport = true;
          extraLines = ''
            card-timeout 1
          '';
          sshKeys = [
            "B196C003243D0D4CC51060EFCA5373C79AED5E86 600"
            "15D0E64AB674D31570D84A748F36018AE1318441 600"
            "C82A06C34F20F9400E632819F2747D38692ED5D2 600"
            "6A2278CFC54B3F70E45F29876B69B3FDA0864758 600"
            "380E5513AD9311CA8AB10C2A9393A169D7EF6238 600"
          ];
        };
        scdaemon = {
          disable-ccid = true;
        };
      };
    };
  };
}
