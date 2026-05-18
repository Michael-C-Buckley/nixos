# ADD enable options and this modules
{
  flake.modules.nixos.p520 = {pkgs, ...}: let
    firewallPorts = [
      111 # rpcbind
      2049 # nfsd
      4000 # statd
      4001 # lockd
      4002 # mountd
    ];
  in {
    boot = {
      kernel.sysctl = {
        "fs.nfs.nlm_grace_period" = 10;
        "fs.nfs.nlm_timeout" = 10;
      };
      supportedFilesystems = ["nfs"];
    };

    services = {
      nfs.server = {
        enable = true;
        nproc = 16;

        statdPort = 4000;
        lockdPort = 4001;
        mountdPort = 4002;

        exports = ''
          /home/michael/share 192.168.0.0/16(rw,sync,no_subtree_check,no_root_squash,fsid=0)
        '';
      };
      rpcbind.enable = true;
    };

    networking.firewall = {
      allowedTCPPorts = firewallPorts;
      allowedUDPPorts = firewallPorts;
    };

    environment.systemPackages = with pkgs; [
      nfs-utils
    ];
  };
}
