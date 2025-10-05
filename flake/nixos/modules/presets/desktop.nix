{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkDefault mkIf;
  inherit (config.system) preset;
in {
  imports = [
    inputs.mangowc.nixosModules.mango
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
      wireshark.enable = mkDefault true;
      winbox = {
        enable = mkDefault true;
        package = pkgs.winbox4;
        openFirewall = mkDefault true;
      };
    };

    virtualisation = {
      containerlab.enable = mkDefault true;
      libvirtd = {
        enable = mkDefault true;
        addGUIPkgs = mkDefault true;
      };
    };

    environment = {
      systemPackages = with pkgs; [
        pulseaudioFull
        hydra-cli
      ];
    };

    features = {
      boot = mkDefault "systemd";
      michael.extendedGraphical = mkDefault true;
      autoLogin = mkDefault true;
      displayManager = mkDefault "greetd";
      noctalia.enable = true;
    };

    # Add Wireshark if enabled
    users.powerUsers.groups =
      if config.programs.wireshark.enable
      then ["wireshark"]
      else [];
  };
}
