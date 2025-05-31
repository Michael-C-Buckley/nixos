_: let
  fileLimit = 1024;
in {
  services.frr = {
    bgpd.enable = true;
    ospfd.enable = true;
    bgpd.options = ["--limit-fds ${toString fileLimit}"];
    zebra.options = ["--limit-fds ${toString fileLimit}"];
    openFilesLimit = fileLimit;
  };
}
