_: {
  imports = [
    ./routing.nix
    ./options.nix
    ./systemd.nix
  ];

  systemd.network.enable = true;

  # Use DHCP on the onboard ethernet ports
  networking.interfaces = {
    eno1.useDHCP = true;
    eno2.useDHCP = true;
  };
}
