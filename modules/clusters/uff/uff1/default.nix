{
  flake.modules.uff.uff1 = {
    imports = [
      ./network
      ./filesystems.nix
    ];

    system = {
      boot.uuid = "6B03-5772";
    };

    containers = {
      wireguard-mt1.autoStart = true;
    };

    virtualisation.quadlet.containers = {
      vaultwarden.autoStart = true;
    };
  };
}
