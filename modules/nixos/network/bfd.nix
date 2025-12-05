{
  flake.modules.nixos.bfd = {
    services.frr.bfdd.enable = true;

    networking = {
      firewall.allowedUDPPorts = [3784 3785 4784];
    };
  };
}
