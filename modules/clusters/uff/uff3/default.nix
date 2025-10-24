{
  flake.modules.uff.uff3 = {
    imports = [
      ./network
      ./filesystems.nix
    ];

    system = {
      boot.uuid = "1555-62FA";
    };

    containers = {
      coredns.autoStart = true;
      nginx.autoStart = true;
    };
  };
}
