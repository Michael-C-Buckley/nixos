{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption mkIf optionals;
  inherit (config.system) impermanence;
  inherit (config.virtualisation) docker;
  inherit (docker) kata;
in {
  options.virtualisation.docker.kata = {
    enable = mkEnableOption "Enable Kata container runtime on Docker";
    package = mkOption {
      type = lib.types.package;
      default = pkgs.kata-runtime;
      description = "Which Kata container package to use with Docker";
    };
  };

  config = mkIf docker.enable {
    environment = mkIf kata.enable {
      persistence."/cache".directories = optionals impermanence.enable ["/var/lib/docker"];
      # Kata Features
      systemPackages = optionals kata.enable [kata.package];
      etc = mkIf kata.enable {
        "docker/daemon.json".text = builtins.toJSON {
          runtimes.kata-runtime.path = "${kata.package}/bin/kata-runtime";
        };
      };
    };
  };
}
