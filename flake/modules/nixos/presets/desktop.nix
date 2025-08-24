{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkDefault mkIf;
  inherit (config.system) preset;
  inherit (pkgs) pulseaudioFull;
in {
  imports = [inputs.mangowc.nixosModules.mango];

  # These are shared on my systems, laptops get everything plus more
  config = mkIf (preset
    == "desktop"
    || preset == "laptop") {
    programs = {
      cosmic.enable = mkDefault false;
      hyprland.enable = mkDefault true;
      mango.enable = mkDefault true;
    };

    virtualisation = {
      containerlab.enable = mkDefault true;
      podman.enable = mkDefault true;
      libvirtd.enable = mkDefault true;
    };

    environment.systemPackages = [pulseaudioFull];

    features = {
      boot = mkDefault "systemd";
      michael = {
        extendedGraphical = mkDefault true;
        hyprland.enable = mkDefault true;
      };
      autoLogin = mkDefault true;
      displayManager = mkDefault "greetd";
      pkgs.fonts = mkDefault true;
    };
  };
}
