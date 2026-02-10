{
  flake.modules.nixos.tailscale = {
    config,
    lib,
    ...
  }: {
    services.tailscale.enable = true;

    networking.firewall = {
      trustedInterfaces = ["tailscale0"];
      allowedUDPPorts = [config.services.tailscale.port];
    };

    systemd.services.tailscaled = {
      serviceConfig.Environment = lib.optionals config.networking.nftables.enable [
        "TS_DEBUG_FIREWALL_MODE=nftables"
      ];
    };
  };
}
