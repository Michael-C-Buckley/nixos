{
  inputs,
  lib,
  ...
}: {
  containers.attic = {
    imports = [inputs.attic.nixosModules.atticd];
    # For now, deploying manually on the selected nodes
    autoStart = lib.mkDefault false;
    privateNetwork = true;
    hostBridge = "br100";
    ephemeral = true;
    localAddress = "192.168.52.25/26";

    services.atticd = {
      enable = true;

      environmentFile = "/etc/atticd.env";

      settings = {
        listen = "[::]:8080";

        jwt = {};

        # Chunking Info left to the recommended defaults
        chunking = {
          nar-size-threshold = 64 * 1024; # 64 KiB
          min-size = 16 * 1024; # 16 KiB
          avg-size = 64 * 1024; # 64 KiB
          max-size = 256 * 1024; # 256 KiB
        };
      };
    };
  };
}
