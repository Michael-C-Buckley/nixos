# DEACTIVATED: Cosmic flake is out of date and unmaintained
{
  config,
  inputs,
  lib,
  ...
}: {
  options.programs.cosmic = {
    enable = lib.mkEnableOption "Enable Cosmic Desktop on host";
  };

  imports = [
    inputs.cosmic.nixosModules.default
  ];

  config = {
    services.desktopManager = {
      cosmic.enable = config.programs.cosmic.enable;
    };
  };
}
