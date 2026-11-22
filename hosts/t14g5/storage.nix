# Shared multi-boot disk which has nixos, finix, and debian
{
  systemUUID = "7f3b175a-eef0-47aa-9ddf-aa9b387d2edd";
  luksUUID = "71a0b8e0-efe1-4471-849a-4abe3edeafb9";
  luksName = "cryptroot";
  rootDevice = "/dev/mapper/crypt--lv-broot";
  espUUID = "3056-5D22";
  dataUUID = "0a16900f-4298-4515-9d67-a53f8755f6b0";
  subvolumes = {
    "/" = "@trixie-root";
    "/home" = "@trixie-home";
    "/var" = "@trixie-var";
    "/nix" = "@trixie-nix";
    "/opt" = "@trixie-opt";
    "/nobackup" = "@trixie-nobackup";
  };
  sharedSubvolumes = {
    "/var/lib/sbctl/keys" = "@sbctl-keys";
    "/var/lib/bluetooth" = "@bluetooth";
    "/etc/NetworkManager/system-connections" = "@networkmanager";
  };
}
