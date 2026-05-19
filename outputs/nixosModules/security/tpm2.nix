# WIP MODULE
{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    ssh-tpm-agent
    tpm2-tools
    p11-kit
    age-plugin-tpm
  ];

  security.tpm2 = {
    enable = true;
    abrmd.enable = false;
    pkcs11.enable = true;
    tctiEnvironment = {
      enable = true;
    };
  };

  users.powerUsers.groups = ["tss"];
}
