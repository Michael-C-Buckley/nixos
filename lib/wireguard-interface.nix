{
  pkgs,
  lib,
  ...
}: {
  name,
  config,
  cfgPath ? config.sops.secrets."wg-${name}".path,
  ipAddresses ? [],
  mtu ? 1420,
}: {
  description = "WireGuard: ${name}";
  wantedBy = ["multi-user.target"];
  serviceConfig = {
    Type = "oneshot";
    RemainAfterExit = true;

    ExecStartPre =
      [
        "${pkgs.iproute2}/bin/ip link add dev wg-${name} type wireguard"
        "${pkgs.iproute2}/bin/ip link set wg-${name} mtu ${toString mtu}"
        "${pkgs.wireguard-tools}/bin/wg setconf wg-${name} ${cfgPath}"
      ]
      ++ lib.concatMap (addr: [
        "${pkgs.iproute2}/bin/ip address add ${addr} dev wg-${name}"
      ])
      ipAddresses;

    ExecStart = "${pkgs.iproute2}/bin/ip link set wg-${name} up";
    ExecStopPost = "${pkgs.iproute2}/bin/ip link delete wg-${name}";
    Restart = "on-failure";
    RestartSec = "10s";
    StartLimitIntervalSec = 60;
    StartLimitBurst = 5;
  };
}
