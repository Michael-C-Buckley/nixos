{config, ...}: {
  flake.modules.nixos.t14 = {
    imports = with config.flake.modules.nixos; [
      bgp
    ];

    networking = {
      hostId = "8425e349";
      hostName = "t14";
      networkmanager.enable = true;

      # For virtualization guests, if I have them
      nat = {
        enable = true;
        externalInterface = "wlp3s0";
        internalInterfaces = ["br0" "br1"];
      };
    };
  };
}
