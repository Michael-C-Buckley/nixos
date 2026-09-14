# Template for defaults of bare metal systems
{ pkgs, lib, ... }: {

  environment.systemPackages = with pkgs; [
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

  boot = {
    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
    initrd.systemd = {
      enable = true;
      packages = [ pkgs.busybox ];
      emergencyAccess = true;
    };
    loader = {
      timeout = 10;
      # Systemd unless lanzaboote or something else is used
      systemd-boot = {
        enable = lib.mkDefault true;
        configurationLimit = 10;
        netbootxyz.enable = true;
      };
      efi.canTouchEfiVariables = true;
    };
  };

  programs = {
    ssh.startAgent = true;
    nh.enable = true;
  };

}
