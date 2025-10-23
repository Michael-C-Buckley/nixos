{config, ...}: {
  flake.modules.nixos.laptopPreset = {
    pkgs,
    lib,
    ...
  }: {
    imports = with config.flake.modules.nixos; [
      desktopPreset
      network
      wifi
    ];

    environment.systemPackages = with pkgs; [
      brightnessctl
    ];

    services = {
      upower.enable = true;
      tlp.enable = true;
      power-profiles-daemon.enable = lib.mkForce false;
    };
  };
}
