{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) concatStringsSep mkDefault;
  inherit (config.users.users) michael shawn;
  michaelKeys = michael.openssh.authorizedKeys.keys;
  shawnKeys = shawn.openssh.authorizedKeys.keys;
in {
  environment = {
    etc = {
      "ssh/sudo_authorized_keys" = {
        mode = "0644";
        text = concatStringsSep "\n" (michaelKeys ++ shawnKeys);
      };
      "pkcs11/pkcs11.conf".text = ''
        module: ${pkgs.opensc}/lib/opensc-pkcs11.so
        critical: yes
        log-calls: yes
      '';
    };
    systemPackages = with pkgs; [
      pamtester
      pam_ssh_agent_auth
    ];
  };

  security = {
    # WIP: not yet working
    # This is a test to get it working for doas and switch to it for my security model
    pam.services.doas = {
      sshAgentAuth = true;
      text = ''
        auth required ${pkgs.pam_ssh_agent_auth}/libexec/pam_ssh_agent_auth.so file=/etc/ssh/sudo_authorized_keys debug
        auth include doas
      '';
      setEnvironment = true;
    };
    doas = {
      enable = false;
      wheelNeedsPassword = false;
    };
    sudo = {
      extraConfig = "Defaults lecture=never";
      wheelNeedsPassword = false;
    };
  };

  services = {
    # Farewell printing, read this article if you didn't know you could print with just netcat
    # https://retrohacker.substack.com/p/bye-cups-printing-with-netcat
    printing.enable = false;
    openssh = {
      enable = mkDefault true;
      settings = {
        PasswordAuthentication = mkDefault false;
        KbdInteractiveAuthentication = mkDefault false;
        streamLocalBindUnlink = mkDefault true;
      };
    };
  };

  networking = {
    firewall = {
      # Blocking ICMP is very dumb overall
      allowPing = mkDefault true;
      allowedTCPPorts = [22 53];
      allowedUDPPorts = [53];
    };
  };
}
