{...}: {
  services = {
    iperf3 = {
      enable = true;
      openFirewall = true;
    };
  };
}
