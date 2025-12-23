let
  inherit (builtins) replaceStrings split attrNames elemAt fromJSON head;
in
  {
    config,
    lib,
    ...
  }: {
    flake.lib.network = {
      # Helper to get split an IP with CIDR mask and return just the address
      getAddress = ip: head (split "/" ip);

      # Helper to convert standard address into common nix format
      getAddressAttrs = ip: let
        parts = split "/" ip;
      in {
        address = head parts;
        prefixLength = elemAt parts 2;
      };

      # Simple helper to change the VLAN names
      fixVlanName = name: replaceStrings ["-"] ["."] name;

      # Takes a host's interface list from the flake host file
      # and parses out the VLANs and returns a list in the string format
      # such as `eth1.100` where it's name and ID
      getVlanList = interfaces:
        map
        config.flake.lib.network.fixVlanName
        (lib.filter (lib.hasInfix "-") (attrNames interfaces));

      # Template for the VLAN schema I use
      # converts from subinterface in the format `eno1.100`
      # where the decimal separates the interface and VLAN ID
      mkVlanNetdev = vlanName: mtu: let
        parts = split "\\." vlanName;
        vlanId = elemAt parts 2;
      in {
        name = "10-${vlanName}";
        value = {
          netdevConfig = {
            Kind = "vlan";
            Name = vlanName;
            MTUBytes = mtu;
          };
          vlanConfig.Id = fromJSON vlanId;
        };
      };
    };
  }
