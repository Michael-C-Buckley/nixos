# Where I will be keeping personal secrets
{
  flake.hjemConfig.secrets = {config, ...}: {
    hjem.users.michael.files = {
      ".ssh/authorized_keys".source = config.sops.secrets.michael_ssh_pubkeys.path;
    };

    sops.secrets = {
      michael_ssh_pubkeys = {
        sopsFile = "/etc/secrets/users/michael/ssh_pubkeys.sops";
        mode = "0644";
        owner = "michael";
        format = "binary";
      };
    };
  };
}
