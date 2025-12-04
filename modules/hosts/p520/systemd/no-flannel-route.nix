{
  # Delete flannel's default route
  flake.modules.nixos.p520 = {pkgs, ...}: {
    systemd = {
      services.remove-static-default-route = {
        description = "Remove default routes created ";
        after = ["network.target"];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${pkgs.iproute2}/bin/ip route delete || true";
        };
      };
      timers.remove-static-default-route = {
        description = "Constantly scan for static default routes and remove them";
        wantedBy = ["timers.target"];
        timerConfig = {
          OnCalendar = "*:*:0/10";
          AccuracySec = "1s";
        };
      };
    };
  };
}
