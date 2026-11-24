defaultDirectory:
{ lib, ... }:
{
  options.services.ssh-host-tpm-agent = {
    keyDirectory = lib.mkOption {
      type = lib.types.strMatching "/.+";
      default = defaultDirectory;
      description = "Directory holding the TPM-backed SSH host key, outside the Nix store.";
    };
    keyName = lib.mkOption {
      type = lib.types.str;
      default = "ssh_tpm_host_ecdsa_key";
      description = "Host key file name, without the `.tpm`/`.pub` suffix.";
    };
  };
}
