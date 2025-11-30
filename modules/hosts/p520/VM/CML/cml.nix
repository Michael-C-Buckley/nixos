# Take snapshots of the CML VM and replicate off to the HDD pool I have
# this will reduce the usage of the SSDs
{
  flake.modules.nixos.p520 = {
    services = {
      sanoid.datasets = {
        "zroot/local/vm/cml".useTemplate = ["short"];
        "zhdd/vm/cml".useTemplate = ["normal"];
      };

      # Replicate snapshots to HDD pool
      syncoid = {
        enable = true;
        interval = "*:0/55";

        # Replicate CML snapshots to HDD pool
        commands."cml-backup" = {
          source = "zroot/local/vm/cml";
          target = "zhdd/vm/cml";
          sendOptions = "w"; # Send raw/whole blocks (for zvols)
          recvOptions = "o compression=zstd";
          recursive = false;
          sshKey = null;
        };
      };
    };
  };
}
