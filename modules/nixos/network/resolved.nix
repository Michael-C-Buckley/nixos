{
  flake.modules.nixos.resolved = {
    config,
    pkgs,
    lib,
    ...
  }: {
    services = {
      resolved.enable = true;
      unbound.enable = false;
    };

    # WIP: Split and create v6 addressing and options
    networking.nameservers = [
      "1.1.1.1#cloudflare-dns.com"
      "9.9.9.9#dns.quad9.net"
    ];

    systemd.services = {
      systemd-resolved = {
        wantedBy = ["multi-user.target"];
      };

      write-resolved-conf = {
        description = "Write systemd-resolved configuration";
        wantedBy = ["multi-user.target"];
        after = ["network.target"];
        before = ["systemd-resolved.service"];
        path = [pkgs.coreutils];

        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = pkgs.writeShellScript "write-resolved-conf" ''
            # Remove the system's generated immutable file
            rm -f /etc/systemd/resolved.conf

            # Rebuild it
            printf '[Resolve]\n' > /etc/systemd/resolved.conf
            cat "${config.sops.secrets.resolved-nextdns.path}" >> /etc/systemd/resolved.conf
            printf 'DNS=%s\n' "${lib.concatStringsSep " " config.networking.nameservers}" >> /etc/systemd/resolved.conf
            printf 'DNSOverTLS=yes\n' >> /etc/systemd/resolved.conf
            printf 'Domains=%s\n' "${lib.concatStringsSep " " config.networking.search}" >> /etc/systemd/resolved.conf

            # Final tweaks
            chmod 644 /etc/systemd/resolved.conf
            echo "Generated /etc/systemd/resolved.conf"
          '';

          User = "root";
        };

        # Ensure this runs at activation (on system startup)
        unitConfig.DefaultDependencies = false;
      };

      systemd-resolved = {
        wants = ["write-resolved-conf.service"];
        after = ["write-resolved-conf.service"];
      };
    };
  };
}
