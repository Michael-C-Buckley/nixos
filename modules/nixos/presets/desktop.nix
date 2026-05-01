{config, ...}: let
  inherit (config.flake) modules;
in {
  flake.modules.nixos.desktopPreset = {
    pkgs,
    lib,
    ...
  }: {
    imports = builtins.attrValues {
      inherit
        (modules.nixos)
        linuxPreset
        shawn
        zfs
        # Network
        network
        dnscrypt-proxy
        # Virtualization
        libvirt
        #containerlab # Temporarily disabled
        # Userspace
        chromiumPolicies
        dconf
        hyprland
        greetd
        noctalia
        niri
        # Security
        yubikey
        tpm2
        pam-ssh
        secrets
        tailscale
        packages
        packages-desktop
        packages-development
        packages-network
        packages-fonts
        # Users
        michael-attic
        michael-ssh-agent
        hjem
        ;
    };

    services = {
      gvfs.enable = true;
      tumbler.enable = true;
    };

    environment.systemPackages = with pkgs; [
      thunar
      thunar-archive-plugin
      webp-pixbuf-loader
      geeqie
      libgsf
    ];

    # Move my shell to fish
    programs.fish.enable = true;
    users.users.michael.shell = lib.mkForce pkgs.fish;

    # Host bridge configuration
    networking = {
      bridges.br0.interfaces = [];
      interfaces.br0 = {
        ipv4.addresses = [
          {
            # Non-routable within my network, local to the host-only
            address = "192.168.254.193";
            prefixLength = 26;
          }
        ];
        ipv6.addresses = [
          {
            address = "fe80::1";
            prefixLength = 64;
          }
        ];
      };
    };
  };
}
