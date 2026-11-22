{ lib, ... }:
{
  services.openssh = {
    enable = lib.mkDefault true;
    openFirewall = lib.mkDefault true;

    # Seriously, stop using RSA keys
    hostKeys = [
      {
        path = "/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
  };

  systemd = {
    generators.systemd-ssh-generator = "/dev/null";
    sockets.sshd-unix-local.enable = lib.mkForce false;
    sockets.sshd-vsock.enable = lib.mkForce false;
  };
}
