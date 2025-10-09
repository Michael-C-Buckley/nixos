# Used solely to aggregate a nixosModule output
{
  imports = [
    ./default.nix
    ./bgp.nix
    ./eigrp.nix
    ./ospf.nix
    ./options.nix
    ./vrrp.nix
    ./vxlan.nix
    ./unbound.nix
  ];
}
