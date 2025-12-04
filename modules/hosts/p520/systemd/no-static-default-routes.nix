{
  # Delete junk default routes
  flake.modules.nixos.p520 = {pkgs, ...}: {
    systemd = {
      services.remove-static-default-route = {
        description = "Remove default routes created ";
        after = ["network.target"];
        wants = ["network.target"];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${pkgs.bash}/bin/bash -c 'while ${pkgs.iproute2}/bin/ip route delete default; do :; done'";
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
