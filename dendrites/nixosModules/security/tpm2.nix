# WIP MODULE
{
  flake.modules.nixos.security.tpm2 = {
    config,
    lib,
    pkgs,
    ...
  }: let
    inherit (lib) mkIf;
    inherit (config.system) impermanence;
    local = config.security.tpm2;
  in {
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
      # Enable: set at host level
      abrmd.enable = false;
      pkcs11.enable = true;
      tctiEnvironment = {
        enable = true;
        # interface = "tabrmd";
      };
    };

    environment = mkIf (impermanence.enable && local.enable) {
      systemPackages = with pkgs; [
        ssh-tpm-agent
        tpm2-tools
      ];
      persistence."/persist".directories = [
        "/var/lib/tpm2-pkcs11"
        "/var/lib/tpm2-tss/system/keystore"
        "/etc/tpm2-tss"
      ];
    };

    users.powerUsers.groups = lib.mkIf config.security.tpm2.enable ["tss"];
  };
}
