{
  pkgs,
  lib,
  ...
}: let
  link_script = pkgs.writers.writePython3 "ssh_link_script" {} ./ssh_link.py;
in {
  programs.ssh.startAgent = true;

  services = {
    gnome.gcr-ssh-agent.enable = false;
    udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="hidraw", ENV{ID_VENDOR_ID}=="1050", ENV{SYSTEMD_WANTS}+="yubikey-link.service", TAG+="systemd"
    '';
  };

  systemd.services = {
    yubikey-link = {
      description = "Update Yubikey symlinks";
      path = with pkgs; [busybox yubikey-manager];
      serviceConfig = {
        User = "michael";
        Type = "oneshot";
        ExecStart = pkgs.writeShellScript "yubikey-linkstart" ''
          sleep 1
          ykman list
          ${link_script} ${lib.getExe pkgs.yubikey-manager}
        '';
      };
    };
  };
}
