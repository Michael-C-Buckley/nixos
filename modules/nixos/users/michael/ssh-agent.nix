# Run at the system level so that I may use systemd-creds to protect my key
# This is a key stub that points to a yubikey, so leakage is not an issue
# but just another layer of due diligence
# I do also use secureboot so TPM2 PCR7 is in effect and only decrypts with
# a proper boot state
{
  flake.modules.nixos.michael-ssh-agent = {pkgs, ...}: {
    hjem.users.michael.environment.sessionVariables.SSH_AUTH_SOCK = "/home/michael/.ssh/ssh-agent.sock";

    systemd.services.ssh-agent-michael = {
      description = "SSH Agent for michael";
      wantedBy = ["multi-user.target"];
      after = ["local-fs.target"];

      serviceConfig = {
        Type = "forking";
        User = "michael";
        RuntimeDirectory = "ssh-agent-michael";
        Environment = "SSH_AUTH_SOCK=/home/michael/.ssh/ssh-agent.sock";
        ExecStart = "${pkgs.openssh}/bin/ssh-agent -a $SSH_AUTH_SOCK";
        ExecStartPost = "${pkgs.openssh}/bin/ssh-add /run/credentials/ssh-agent-michael.service/id_ed25519_sk";
        LoadCredentialEncrypted = "id_ed25519_sk:/home/michael/.ssh/crypt/id_ed25519_sk";
      };
    };
  };
}
