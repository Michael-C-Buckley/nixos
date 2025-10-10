{
  flake.modules.nixosModules.bgp = {
    config,
    lib,
    ...
  }: let
    fileLimitStr = builtins.toString config.networking.bgp.fileLimit;
  in {
    options.networking.bgp = {
      port = lib.mkOption {
        type = lib.types.int;
        default = 179;
        description = "BGP Listen Port";
      };
      fileLimit = lib.mkOption {
        type = lib.types.int;
        default = 2048;
        description = "File descriptor limit for use with bgpd.";
      };
    };
    config = {
      networking.firewall.allowedTCPPorts = [config.networking.bgp.port];
      services.frr = {
        bgpd = {
          enable = true;
          options = ["--limit-fds ${fileLimitStr}"];
        };
        openFilesLimit = config.networking.bgp.fileLimit;
        zebra.options = ["--limit-fds ${fileLimitStr}"];
      };
    };
  };
}
