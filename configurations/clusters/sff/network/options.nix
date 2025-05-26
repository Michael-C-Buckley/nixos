{...}: let
  inherit (lib) mkOption;
  inherit (lib.types) str;
in {
  options = {
    networking.hardware = {
      enx520p1.mac = mkOption {
        type = str;
        description = "The MAC address of the first Intel X520DA2 port.";
      };
      enx520p2.mac = mkOption {
        type = str;
        description = "The MAC address of the second Intel X520DA2 port.";
      };
    };
  };
}