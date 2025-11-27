{
  flake.modules.nixos.uff = {lib, ...}: let
    inherit (lib) mkOption;
    inherit (lib.types) str;
  in {
    # Merge in the option for the MAC address
    options.custom.enusb1 = {
      mac = mkOption {
        type = str;
        description = "USB 2.5G Ethernet MAC address.";
      };
    };
  };
}
