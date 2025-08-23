# Relink is a small utility that allows me to recreate nix-managed files
#  but mutably so that they can be modified
#  HOWEVER, the changes are impermanent and next activation restores the files
#  I created this to use with /etc/hosts with ContainerLab by Nokia
_: {
  systemd.services."relink-nix" = {
    wantedBy = ["multi-user.target"];
    after = ["local-fs.target" "sysinit-reactivation.target"];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    # Start with just my only needed file
    # WIP: transform to accept a list of files
    script = ''
      STORE_PATH=$(readlink /etc/hosts)
      echo "Converting hosts file: $STORE_PATH"
      rm /etc/hosts
      cat "$STORE_PATH" > /etc/hosts
      chmod 0644 /etc/hosts
    '';
  };
}
