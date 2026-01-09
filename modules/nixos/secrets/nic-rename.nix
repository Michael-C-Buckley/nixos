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
      description = "Rename NICs using secrets";
      wantedBy = ["network-pre.target"];
      before = ["systemd-networkd.service"];
      path = with pkgs; [
        bash
        busybox
        iproute2
        ssh-to-age
        sops
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

            current_name=$(ip -o link | grep -i "$mac_addr" | awk '{print $2}' | tr -d ':' || true)

            if [ -n "$current_name" ] && [ "$current_name" != "$desired_name" ]; then
              echo "Renaming $current_name (MAC: $mac_addr) to $desired_name"
              ip link set "$current_name" down
              ip link set "$current_name" name "$desired_name"
              ip link set "$desired_name" up
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
