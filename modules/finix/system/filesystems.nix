# Elements I want shared relating to filesystems
let
  supportedFilesystems.lvm.enable = true;
in
{ lib, ... }: {
  # Always support LVM
  boot = {
    initrd = { inherit supportedFilesystems; };
    inherit supportedFilesystems;
  };

  # Finix's default tmpfiles rule resets /tmp to 0755 after it is mounted.
  # Restore the sticky, writable mode so the user D-Bus session can bind its socket.
  finit.tmpfiles.rules = lib.mkAfter [ "d /tmp 1777 root root" ];
}
