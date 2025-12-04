{
  # Delete flannel's default route
  flake.modules.nixos.p520 = {pkgs, ...}: {
    systemd.services.remote-flannel-route = {
      description = "Route Flannel traffic";
      after = ["network.target"];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.iproute2}/bin/ip route delete default dev flannel.1";
      };
    };
  };
}
