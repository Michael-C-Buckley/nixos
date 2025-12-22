{
  config,
  lib,
  ...
}: {
  flake.lib.network = {
    # Simple helper to change the VLAN names
    fixVlanName = name: builtins.replaceStrings ["-"] ["."] name;

    # Takes a host's interface list from the flake host file
    # and parses out the VLANs and returns a list in the string format
    # such as `eth1.100` where it's name and ID
    #getVlanList = interfaces: map (a: builtins.replaceStrings ["-"] ["."] a) (builtins.filter (builtins.attrNames interfaces));
    getVlanList = interfaces:
      map
      config.flake.lib.network.fixVlanName
      (lib.filter (lib.hasInfix "-") (builtins.attrNames interfaces));

    # Template for the VLAN schema I use
    # converts from subinterface in the format `eno1.100`
    # where the decimal separate interface and VLAN ID
    mkVlanNetdev = vlanName: let
      parts = builtins.split "\\." vlanName;
      #iface = builtins.elemAt parts 0;
      vlanId = builtins.elemAt parts 2;
    in {
      name = "10-${vlanName}";
      value = {
        netdevConfig = {
          Kind = "vlan";
          Name = vlanName;
        };
        vlanConfig.Id = builtins.fromJSON vlanId;
      };
    };
  };
}
