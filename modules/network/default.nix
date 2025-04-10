{lib, ...}: let
  inherit (lib) mkDefault;
in {
  imports = [
    ./bgp.nix
    ./eigrp.nix
    ./ospf.nix
  ];

  # Set sane standards on file descriptor limits for FRR daemons
  services.frr = {
    bgpd.options = mkDefault ["--limit-fds 2048"];
    zebra.options = mkDefault ["--limit-fds 2048"];
    openFilesLimit = mkDefault 2048;
  };
}
