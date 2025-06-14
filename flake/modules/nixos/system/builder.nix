{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  local = config.system.builder;
in {
  options.system.builder = {
    enable = mkEnableOption "Enable building options on this host.";
  };

  config = mkIf local.enable {
    # I only use this to start from `x86_64-linux`
    boot.binfmt.emulatedSystems = [
      "aarch64-linux"
    ];
  };
}
