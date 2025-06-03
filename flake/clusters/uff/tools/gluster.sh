# WIP

zfs create -o mountpoint=none zdata/gluster
zfs create -o mountpoint=legacy zdata/gluster/attic
mkdir -p /data/gluster/attic
mount -t zfs zdata/gluster/attic /data/gluster/attic

# Options

gluster volume set attic cluster.eager-lock enable
gluster volume set attic cluster.quorum-type auto
gluster volume set attic storage.disperse.eager-lock enable
gluster volume set attic cluster.self-heal-daemon on
gluster volume set attic cluster.data-self-heal-algorithm full
