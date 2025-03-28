{ config, inputs, lib, ... }: {
  options.features.cosmic = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable Cosmic Desktop on host"; 
  };

  imports = [
    inputs.cosmic.nixosModules.default
  ];

  config = lib.mkIf config.features.cosmic {
    services.desktopManager = {
      cosmic.enable = true;
    };
  };
}
