{
  config,
  lib,
  pkgs,
  ...
}:
let
  agentEnabled = config.services.ssh-agent.enable or false;
in
{
  _file = __curPos.file;
  key = __curPos.file;
  assertions = [
    {
      assertion = pkgs.stdenv.hostPlatform.isLinux;
      message = "TPM SSH integration requires Linux with a systemd user manager and host TPM access.";
    }
  ];
  packages = [
    pkgs.age-plugin-tpm
    pkgs.ssh-tpm-agent
  ];
  systemd.services.ssh-tpm-agent = {
    description = "SSH agent for TPM-backed keys";
    wantedBy = [ "default.target" ] ++ lib.optional agentEnabled "ssh-agent.service";
    wants = lib.optional agentEnabled "ssh-agent.service";
    after = lib.optional agentEnabled "ssh-agent.service";
    partOf = lib.optional agentEnabled "ssh-agent.service";
    serviceConfig = {
      ExecStart =
        "${pkgs.ssh-tpm-agent}/bin/ssh-tpm-agent -l %t/ssh-tpm-agent.sock"
        + lib.optionalString agentEnabled " -A %t/${config.services.ssh-agent.socket}";
      Restart = "on-failure";
      RestartSec = 2;
      UMask = "0077";
    };
  };
}
