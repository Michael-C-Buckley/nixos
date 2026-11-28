# Hosts that run on bare metal
let
  metalPackages =
    pkgs: with pkgs; [
      # System
      killall
      expect
      efibootmgr
      gptfdisk
      parted

      # Performance
      btop

      # Hardware
      usbutils
      pciutils
    ];
in
# Template for defaults of bare metal systems
{ pkgs, lib, ... }: {
  imports = [
    ./base.nix
    ../system/modprobed-db.nix
    ../virtualization/agentbox.nix
  ];

  environment.systemPackages = metalPackages pkgs;

  boot.loader = {
    timeout = 10;
    # Systemd unless lanzaboote or something else is used
    systemd-boot = {
      enable = lib.mkDefault true;
      configurationLimit = 10;
      netbootxyz.enable = true;
    };
    efi.canTouchEfiVariables = true;
  };

  services.netbird.enable = true;

  programs = {
    ssh.startAgent = true;
    nh.enable = true;
    tack = {
      enable = true;
      package = lib.mkDefault (pkgs.localTack or pkgs.tack);
      nixConfTokens = true;
    };
  };
}
