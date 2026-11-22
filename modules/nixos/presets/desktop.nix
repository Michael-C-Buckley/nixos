{
  imports = [
    # Templates
    ../presets/base.nix
    ../presets/metal.nix

    # Graphical
    ../graphical/tuigreet.nix
    ../graphical/curosr-gtk-qt.nix
    ../graphical/hyprland.nix
    ../graphical/mime.nix

    # Packages
    ../packages/desktop.nix
    ../packages/dev.nix
    ../packages/network.nix
    ../packages/fonts.nix

    #Security
    ../security/tpm2.nix
    ../security/yubikey.nix

    # System
    ../system/wifi.nix

    # Virtualization
    ../virtualization/containerlab.nix
    ../virtualization/libvirt.nix
    ../virtualization/agentbox.nix

  ];

  systemd.network.wait-online.enable = false;
}
