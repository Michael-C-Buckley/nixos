{
  flake.modules.nixos.secrets-nic-rename = {
    config,
    pkgs,
    ...
  }: {
    # Simple service unit to extract NIC secrets from sops and rename the NICs
    # there's issues with attempting this several other ways since udev in nixos
    # precludes using secrets since rules are built immutably and udevd runs early
    # same applies to systemd-networkd, as udev actually does the renaming
    systemd.services.rename-nics = {
      enable = false;
      description = "Rename NICs using secrets";
      wantedBy = ["multi-user.target"];
      after = ["systemd-networkd.service"];
      path = with pkgs; [
        bash
        busybox
        iproute2
        ssh-to-age
        sops
        systemd
      ];

      serviceConfig = {
        # Host key serves as the sops secret key material
        LoadCredentialEncrypted = ["ssh_host_ed25519_key:/var/lib/systemd/credentials/ssh_host_ed25519_key"];
        ExecStart = pkgs.writeShellScript "rename-nics-execstart" ''
          #!/usr/bin/env bash
          set -euo pipefail

          SOPS_AGE_KEY="$(ssh-to-age -private-key < "$CREDENTIALS_DIRECTORY/ssh_host_ed25519_key")" \
            sops -d --extract '["nic"]["${config.networking.hostName}"]' ${config.sops.defaultSopsFile} | \
          while IFS=': ' read -r desired_name mac_addr; do
            [ -z "$desired_name" ] && continue

            target=$(echo "$mac_addr" | tr '[:upper:]' '[:lower:]')
            current_name=""

            # Match by link/ether (current MAC) or permaddr (permanent MAC) from ip output
            for iface in $(ls /sys/class/net/); do
              iface_info=$(ip -o link show "$iface" 2>/dev/null || true)

              current_mac=$(echo "$iface_info" | sed -n 's/.*link\/ether \([^ ]*\).*/\1/p' | tr '[:upper:]' '[:lower:]')
              perm_mac=$(echo "$iface_info" | sed -n 's/.*permaddr \([^ ]*\).*/\1/p' | tr '[:upper:]' '[:lower:]')

              if [ "$current_mac" = "$target" ] || [ "$perm_mac" = "$target" ]; then
                current_name="$iface"
                break
              fi
            done

            if [ -n "$current_name" ] && [ "$current_name" != "$desired_name" ]; then
              echo "Renaming $current_name (MAC: $mac_addr) to $desired_name"
              ip link set "$current_name" down
              ip link set "$current_name" name "$desired_name"
              networkctl reconfigure "$desired_name"
            elif [ -z "$current_name" ]; then
              echo "Warning: No interface found with MAC $mac_addr for $desired_name"
            else
              echo "Interface $desired_name already has correct name"
            fi
          done
        '';
      };
    };
  };
}
