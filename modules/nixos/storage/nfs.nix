{
  flake.modules.nixos.nfs = {pkgs, ...}: {
    boot.supportedFilesystems = ["nfs"];

    services = {
      nfs.server.enable = true;
      rpcbind.enable = true;
    };

    environment.systemPackages = [pkgs.nfs-utils];
  };
}
