{
  flake.hjemConfigs.ssh-agent = {pkgs, ...}: {
    hjem.users.michael.systemd = {
      enable = true;
      services.ssh-agent = {
        enable = true;
        after = ["local-fs.target"];
        serviceConfig = {
          Type = "forking";
          Environment = "SSH_AUTH_SOCK=%t/ssh-agent";
          ExecStart = pkgs.writeShellScript "michae-ssh-agent-start" ''
            ${pkgs.openssh}/bin/ssh-agent -a $SSH_AUTH_SOCK
            sleep 1
            echo "${pkgs.coreutils}/bin/ls -la $CREDENTIALS_DIRECTORY"
            ${pkgs.openssh}/bin/ssh-add "$CREDENTIALS_DIRECTORY/id_ed25519_sk" 2>&1 || true
          '';
          LoadCredentialEncrypted = "/home/michael/.ssh/id_ed25519_sk.enc:id_ed25519_sk";
        };
      };
    };
  };
}
