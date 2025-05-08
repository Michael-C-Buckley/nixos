{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption mkIf;
  cfg = config.virtualisation.docker;
  kata = cfg.kata;
in {
  options.virtualisation.docker.kata = {
    enable = mkEnableOption "Enable Kata container runtime on Docker";
    package = mkOption {
      type = lib.types.package;
      default = pkgs.kata-runtime;
      description = "Which Kata container package to use with Docker";
    };
  };

  config = {
    environment = mkIf kata.enable {
      systemPackages = [kata.package];
      etc."docker/daemon.json".text = builtins.toJSON {
        runtimes.kata-runtime = {
          path = "${kata.package}/bin/kata-runtime";
        };
      };
    };
  };
}
