{ config, ... }:
let
  inherit (config.services) tailscale;
in
{
  services.tailscale.enable = true;

  networking.firewall = {
    trustedInterfaces = [ tailscale.interfaceName ];
    allowedUDPPorts = [ tailscale.port ];
  };
}
