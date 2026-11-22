{
  config,
  pkgs,
  ...
}:
let
  provider = "${pkgs.yubico-piv-tool}/lib/libykcs11.so";
in
{
  imports = [
    ./yubikey.nix
    ./ssh-agent-linux.nix
  ];
  services.ssh-agent.pkcs11Whitelist = [ "${provider}*" ];
  packages = [
    (pkgs.writeShellApplication {
      name = "ssh-add-yubikey";
      runtimeInputs = [ config.services.ssh-agent.package ];
      text = ''
        export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/${config.services.ssh-agent.socket}"
        ssh-add "$@" -s ${provider}
        identities=$(ssh-add -L)
        while read -r key_type key_data comment; do
          case "$comment" in
            "Public key for Retired Key "* | "Public key for PIV Attestation")
              ssh-add -q -d - <<< "$key_type $key_data $comment"
              ;;
          esac
        done <<< "$identities"
      '';
    })
  ];
  assertions = [
    {
      assertion = pkgs.stdenv.hostPlatform.isLinux;
      message = "YubiKey Linux integration requires Linux.";
    }
  ];
}
