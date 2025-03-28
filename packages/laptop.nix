{config, pkgs, lib, ...}: {
  options.features.laptop = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Enable laptop features on host.";
  };

  config.users.users.michael.packages = lib.mkIf config.features.laptop (with pkgs; [
    brightnessctl
  ]);
}
