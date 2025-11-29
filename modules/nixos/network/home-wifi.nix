# I share the basic home network among multiple hosts, this is the blanket common components of it
# Individual needs like addresses settings are done per-host
# $VAR items are NetworkManager's form of substitution
#
# https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/services/networking/networkmanager.nix#L467
# Conveniently, I use Sops-nix to declare those files and then just read the path in
# NetworkManager is run under root so the `path` attr is sufficient and need not be linked anywhere or chown
{
  flake.modules.nixos.wifi-home = {config, ...}: {
    networking.networkmanager.ensureProfiles = {
      environmentFiles = [config.sops.secrets.michael-wifi.path];

      # - The actual profiles are all static IPs
      # - No reliance on DHCP means individual provisions for routing
      #   must also be accounted for, which is with the standard default routes
      # - Some hosts have additional routes for reaching various parts of the network
      profiles = {
        home = {
          connection = {
            id = "Home-Wifi";
            type = "wifi";
            autoconnect-priority = 10; # Prefer this SSID first
          };
          wifi = {
            # SSIDs can be used to physically locate someone if they're unique enough, so hide it
            ssid = "$MICHAEL_SSID";
            mode = "infrastructure";
          };
          wifi-security = {
            key-mgmt = "wpa-psk";
            psk = "$MICHAEL_PSK";
          };
          ipv4 = {
            method = "manual";
            ignore-auto-dns = true;
            ignore-auto-routes = true;
            route1 = "0.0.0.0/0,172.16.1.1,50";
          };
          ipv6 = {
            method = "manual";
            ignore-auto-dns = true;
            ignore-auto-routes = true;
          };
        };
        home2 = {
          connection = {
            id = "Home-Wifi2";
            type = "wifi";
            autoconnect-priority = 5;
          };
          wifi = {
            mode = "infrastructure";
            ssid = "$MICHAEL_SSID2";
          };
          wifi-security = {
            key-mgmt = "wpa-psk";
            psk = "$MICHAEL_PSK2";
          };
          ipv4 = {
            method = "manual";
            ignore-auto-dns = true;
            ignore-auto-routes = true;
            route1 = "0.0.0.0/0,172.30.1.1,50";
          };
          ipv6 = {
            method = "manual";
            ignore-auto-dns = true;
            ignore-auto-routes = true;
          };
        };
      };
    };
  };
}
