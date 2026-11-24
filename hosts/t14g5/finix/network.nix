{ lib, modules, ... }:
{
  imports = [
    modules.networkmanager
    modules.nftables
    modules.openssh
  ];

  programs.resolvconf.enable = true;
  users.users.michael.extraGroups = [ "networkmanager" ];

  providers.firewall.allowedTCPPorts = [ 22 ];

  services = {
    # The generated ed25519 host key also works when the TPM agent is unavailable.
    ssh-host-tpm-agent.keyDirectory = "/var/lib/sshd";
    openssh = {
      enable = true;
      settings.AuthorizedKeysFile = [ "/etc/ssh/authorized_keys.d/%u" ];
    };
    # Same stack as T14g5's other installations: NetworkManager with its default
    # wpa_supplicant Wi-Fi backend, profiles on the shared @networkmanager
    # subvolume. DNS goes through resolvconf (rc-manager set by the module).
    networkmanager.enable = true;
    nftables = {
      enable = true;
      tables.nixos-fw.content = lib.mkAfter ''
        # Replies to multicast pings do not match the request's conntrack entry
        # and would be dropped as invalid. Untracked, ICMPv6 rules accept them,
        # like T14's echo-reply accept before conntrack.
        chain prerouting-notrack {
          type filter hook prerouting priority raw; policy accept;
          icmpv6 type echo-reply notrack
        }

        chain rpfilter {
          type filter hook prerouting priority mangle + 10; policy drop;
          meta nfproto ipv4 udp sport . udp dport { 67 . 68, 68 . 67 } accept comment "DHCPv4 client/server"
          fib saddr . mark oif exists accept
        }

        chain input-allow {
          icmp type echo-request accept comment "allow ping"
          icmpv6 type != { nd-redirect, 139 } accept comment "ICMPv6 except redirects and node information queries (RFC 4890, 4.4)"
          ip6 daddr fe80::/64 udp dport 546 accept comment "DHCPv6 client"
        }
      '';
    };
  };
}
