# WIP: not yet working
# This is a test to get it working for doas and switch to it for my security model
# Note to self: services.pam_pkcs11
{
  flake.modules.nixosModules.pam = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      pamtester
      pam_ssh_agent_auth
    ];

    security.pam.services.doas = {
      sshAgentAuth = true;
      text = ''
        auth required ${pkgs.pam_ssh_agent_auth}/libexec/pam_ssh_agent_auth.so file=/etc/ssh/sudo_authorized_keys debug
        auth include doas
      '';
      setEnvironment = true;
    };
  };
}
