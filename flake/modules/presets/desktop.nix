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
  imports = [
    inputs.mangowc.nixosModules.mango
    inputs.schizofox.nixosModules.default
  ];

  # These are shared on my systems, laptops get everything plus more
  config = mkIf (preset
    == "desktop"
    || preset == "laptop") {
    programs = {
      # Graphical Environments
      cosmic.enable = mkDefault false;
      hyprland.enable = mkDefault true;
      mango.enable = mkDefault true;

      # Programs
      schizofox.enable = true;
      wireshark.enable = mkDefault true;
      winbox = {
        enable = mkDefault true;
        package = pkgs.winbox4;
        openFirewall = mkDefault true;
      };
    };

    virtualisation = {
      containerlab.enable = mkDefault true;
      libvirtd.enable = mkDefault true;
    };

    environment = {
      systemPackages = [pulseaudioFull];

      # Move some things out of home into cache
      persistence."/cache".directories = [
        "/home/michael/.config/legcord/Cache"
        "/home/michael/.config/legcord/Code Cache"
      ];
    };

    features = {
      boot = mkDefault "systemd";
      michael.extendedGraphical = mkDefault true;
      autoLogin = mkDefault true;
      displayManager = mkDefault "greetd";
      pkgs.fonts = mkDefault true;
    };

    # Add Wireshark if enabled
    users.powerUsers.groups =
      if config.programs.wireshark.enable
      then ["wireshark"]
      else [];
  };
}
