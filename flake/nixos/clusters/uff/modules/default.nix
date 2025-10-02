{config, ...}: let
  inherit (config.sops.secrets) corosync-authkey wifi;
in {
  system = {
    preset = "server";
    stateVersion = "25.11";
  };

  environment = {
    etc = {
      "corosync/authkey".source = corosync-authkey.path;
      "NetworkManager/system-connections/wifi.nmconnection" = {
        source = wifi.path;
        mode = "0600";
      };
    };
    persistence."/persist" = {
      directories = [
        "/var/lib/quadlet"
      ];
    };
  };

  services = {
    unbound.enable = true;
  };

  virtualisation = {
    podman.enable = true;
  };
}
