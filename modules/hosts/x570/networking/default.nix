{
  flake.modules.nixos.x570 = {
    systemd.network.wait-online.enable = false;
    networking = {
      hostId = "c07fa570";
      hostName = "x570";
    };
  };
}
