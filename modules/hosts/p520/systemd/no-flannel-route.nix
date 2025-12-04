{
  # Delete flannel's default route
  flake.modules.nixos.p520 = {pkgs, ...}: {
    systemd = {
      services.remove-flannel-route = {
        description = "Remove Flannel's default route";
        after = ["network.target"];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${pkgs.iproute2}/bin/ip route delete default dev flannel.1";
        };
      };
      timers.remove-flannel-route = {
        description = "Constantly scan for flannel's default route and remove it";
        wantedBy = ["timers.target"];
        timerConfig = {
          OnCalendar = "*:*:0/10";
          AccuracySec = "1s";
        };
      };
    };
  };
}
