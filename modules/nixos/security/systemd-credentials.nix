{
  flake.modules.nixos.systemd-credentials = {
    custom.systemdSops = true;

    services.openssh = {
      # Pre-provisioned, do not attempt to generate new ones
      generateHostKeys = false;
      hostKeys = [
        {
          path = "/run/credentials/sshd.service/ssh_host_ed25519_key";
          type = "ed25519";
        }
      ];
    };

    # Sops-nix and Openssh receives the protected SSH key from systemd-credentials
    # MUST be provisioned imperatively in advance
    systemd.services = let
      key = ["ssh_host_ed25519_key:/var/lib/systemd/credentials/ssh_host_ed25519_key"];
    in {
      sops-install-secrets = {
        serviceConfig.LoadCredentialEncrypted = key;
        # I use impermanence, so ensure everything exists
        after = ["local-fs.target"];
      };
      sshd.serviceConfig.LoadCredentialEncrypted = key;
    };
  };
}
