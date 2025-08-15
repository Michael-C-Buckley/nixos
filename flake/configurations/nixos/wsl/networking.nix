{pkgs, ...}: {
  networking = {
    ospf.enable = true;
    eigrp.enable = true;
    bgp.enable = true;

    networkmanager = {
      enable = true;
      unmanaged = ["*"];
    };
  };

  environment.systemPackages = [pkgs.dhcpcd];

  services.frr = {
    config = ''
      ip forwarding
      ipv6 forwarding
    '';
  };
}
