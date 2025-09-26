{
  flake.modules.nixosModules.hardware.bluetooth = {config, ...}: {
    # Bluetooth is enabled if Wifi is enabled
    hardware.bluetooth = {
      enable = config.features.wifi;
      powerOnBoot = config.features.wifi;
    };
  };
}
