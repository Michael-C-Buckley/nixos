{
  config,
  lib,
  modules,
  pkgs,
  ...
}:
let
  socket = "/run/ssh-tpm-agent.sock";
  cfg = config.services.ssh-host-tpm-agent;
  agent = pkgs.writeShellScript "ssh-host-tpm-agent" ''
    umask 077
    ${pkgs.coreutils}/bin/rm -f ${socket}
    exec ${pkgs.ssh-tpm-agent}/bin/ssh-tpm-agent --key-dir ${lib.escapeShellArg cfg.keyDirectory} -l ${socket}
  '';
  # Finit has no socket activation; sshd checks the agent's keys at startup.
  waitForAgent = pkgs.writeShellScript "sshd-wait-tpm-agent" ''
    for _ in $(${pkgs.coreutils}/bin/seq 100); do
      if [ -S ${socket} ]; then exit 0; fi
      ${pkgs.coreutils}/bin/sleep 0.1
    done
    echo "${socket} missing; starting sshd without the TPM host key" >&2
  '';
in
{
  imports = [
    modules.openssh
    (import ../../nixos/security/_ssh-host-tpm-agent.nix "/var/lib/sshd")
  ];
  environment.systemPackages = with pkgs; [
    ssh-tpm-agent
    tpm2-tools
    age-plugin-tpm
    tpm2-pkcs11
  ];
  services.udev.packages = [
    (pkgs.writeTextDir "lib/udev/rules.d/60-tpm.rules" ''
      KERNEL=="tpm[0-9]*", MODE="0660", OWNER="root"
      KERNEL=="tpmrm[0-9]*", MODE="0660", OWNER="root", GROUP="tss"
    '')
  ];
  users = {
    groups.tss = { };
    users = {
      tss = {
        isSystemUser = true;
        group = "tss";
      };
      michael.extraGroups = [ "tss" ];
    };
  };
  security.pam.environment = {
    TPM2TOOLS_TCTI.default = "device:/dev/tpmrm0";
    TPM2_PKCS11_TCTI.default = "device:/dev/tpmrm0";
  };
  finit = {
    # Finix's openssh module already creates its own key directory.
    tmpfiles.rules = lib.optional (
      cfg.keyDirectory != "/var/lib/sshd"
    ) "d ${cfg.keyDirectory} 0700 root root - -";
    services.ssh-host-tpm-agent = {
      description = "SSH TPM host key agent";
      command = "${agent}";
      conditions = [ "task/tmpfiles-setup/success" ];
      log = { };
    };
    services.sshd.exec-start-pre = "${waitForAgent}";
  };
  services.openssh.settings = {
    HostKeyAgent = socket;
    # Finix's generator joins `HostKey` list entries on one line, which
    # sshd rejects; sshd accepts only one key per HostKey line.
    Include = "${pkgs.writeText "sshd-tpm-host-key.conf" ''
      HostKey ${cfg.keyDirectory}/${cfg.keyName}.pub
    ''}";
  };
}
