# WIP MODULE
{
  flake.nixosModules.tpm2 = {pkgs, ...}: {
    custom.impermanence.persist.directories = [
      "/var/lib/tpm2-pkcs11"
      "/var/lib/tpm2-tss/system/keystore"
      "/etc/tpm2-tss"
    ];

    environment.systemPackages = with pkgs; [
      ssh-tpm-agent
      tpm2-tools
    ];

    # environment.etc."tpm2-tss/fapi-config.json".text = builtins.toJSON {
    #   profile_name = "pkcs11";
    #   profile_dir = "/etc/tpm2-tss/fapi-profiles";
    #   user_dir = "~/.local/share/tpm2-tss/user/keystore";
    #   system_dir = "/var/lib/tpm2-tss/system/keystore";
    #   log_dir = "/var/log/tpm2-tss";
    # };

    # environment = {
    #   etc."tpm2-tss/fapi-config.json".text =
    #     builtins.replaceStrings
    #     ["${pkgs.tpm2-tss}/var/lib"] # old fragment inside the file
    #     ["/var/lib"] # writable location
    #     (builtins.readFile "${pkgs.tpm2-tss}/etc/tpm2-tss/fapi-config.json");
    #
    #   variables.TPM2_PKCS11_STORE = "/var/lib/tpm2-pkcs11";
    # };

    security.tpm2 = {
      enable = true;
      abrmd.enable = false;
      pkcs11.enable = true;
      tctiEnvironment = {
        enable = true;
        # interface = "tabrmd";
      };
    };

    users.powerUsers.groups = ["tss"];
  };
}
