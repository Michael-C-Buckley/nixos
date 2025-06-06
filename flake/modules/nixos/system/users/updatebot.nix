{pkgs, ...}: let
  home = "/var/lib/updatebot";
  sshDir = "${home}/.ssh";
in {
  sops.secrets = {
    updateKey = {
      owner = "updatebot";
      path = "${sshDir}/id_ed25519";
      mode = "0600";
    };
    updatePubKey = {
      owner = "updatebot";
      path = "${sshDir}/id_ed25519.pub";
      mode = "0644";
    };
    updateKnownHosts = {
      owner = "updatebot";
      path = "${sshDir}/known_hosts";
    };
    updateSshConfig = {
      owner = "updatebot";
      path = "${sshDir}/config";
    };
  };

  users.users.updatebot = {
    isSystemUser = true;
    useDefaultShell = true;
    group = "update";
    packages = with pkgs; [git];
    inherit home;
  };
}
