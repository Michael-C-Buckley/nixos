{config, lib, ...}: {
  options.features.podman = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable podman on the host.";
    };
  };

  config = let
    users = ["michael" "shawn" "root"];
  in {
    users.users = lib.attrsets.genAttrs users (_: {
      extraGroups = ["podman"];
    });

    virtualisation.podman = {
      enable = config.features.podman.enable;
      dockerCompat = true;
      dockerSocket.enable = true;
    };
  };
}
