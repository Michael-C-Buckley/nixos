{
  flake.modules.uff.uff2 = {
    imports = [
      ./network
      ./filesystems.nix
    ];

    system = {
      boot.uuid = "E8D1-BB86";
    };

    containers = {
      vault.autoStart = true;
    };

    virtualisation.quadlet.containers = {
      forgejo.autoStart = true;
    };
  };
}
