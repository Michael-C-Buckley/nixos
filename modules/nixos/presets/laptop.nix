{inputs, ...}: {
  flake.modules.nixos.laptopPreset = {
    pkgs,
    lib,
    ...
  }: {
    imports = with inputs.self.modules.nixos; [
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
