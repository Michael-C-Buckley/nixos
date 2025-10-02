# Traffic forwarders
{
  pkgs,
  lib,
  ...
}: let
  inherit (lib) getExe mkMerge;
  inherit (pkgs) socat;
  mkForwarder = {
    name,
    localPort,
    remoteHost,
    remotePort,
  }: {
    "tcp-forward-${name}" = {
      description = "TCP forwarder for ${name}";
      after = ["network.target"];
      wantedBy = ["multi-user.target"];
      path = [socat];

      serviceConfig = {
        ExecStart = "${getExe socat} TCP-LISTEN:${toString localPort},fork,reuseaddr TCP:${remoteHost}:${toString remotePort}";
        Restart = "always";
        RestartSec = "5";
        User = "nobody";
        Group = "nobody";
        Type = "simple";
        NoNewPrivileges = true;
        PrivateTmp = true;
      };
    };
  };

  forwards = [
    {
      name = "p520";
      localPort = 44851;
      remoteHost = "192.168.48.5";
      remotePort = 22;
    }
    {
      name = "hydra";
      localPort = 3000;
      remoteHost = "192.168.48.5";
      remotePort = 3000;
    }
  ];
in {
  # Generate the forwarders and allow them all
  systemd.services = mkMerge (map mkForwarder forwards);
  networking.firewall.allowedTCPPorts = map (f: f.localPort) forwards;
}
