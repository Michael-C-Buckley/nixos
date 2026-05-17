# WIP MODULE
{
  flake.modules.nixos.tpm2 = {pkgs, ...}: {
    custom.impermanence.persist.directories = [
      "/var/lib/tpm2-pkcs11"
      "/var/lib/tpm2-tss/system/keystore"
      "/etc/tpm2-tss"
    ];

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
  };
}
