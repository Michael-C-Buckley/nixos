{
  flake.modules.nixos.t14 = {
    services.unbound.enable = true;

    networking = {
      hostId = "8425e349";
      hostName = "t14";
      networkmanager.enable = true;

      nat = {
        enable = true;
        externalInterface = "wlp3s0";
        internalInterfaces = ["br0" "br1"];
      };
    };
  };
}
