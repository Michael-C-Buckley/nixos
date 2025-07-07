{pkgs, ...}: {
  networking = {
    ospf.enable = true;
    eigrp.enable = true;
    bgp.enable = true;

    interfaces.enu1c2.useDHCP = true;
  };

  environment.systemPackages = [pkgs.dhcpcd];

  services.frr = {
    config = ''
      ip forwarding
      ipv6 forwarding
    '';
  };
}
