_: {
  system.disko = {
    enable = true;
    main = {
      device = "/dev/nvme0n1";
      bootSize = "1G";
      rootSize = "2G";
      swapSize = "8G";
      zfsSize = "400G";
    };
  };
}
