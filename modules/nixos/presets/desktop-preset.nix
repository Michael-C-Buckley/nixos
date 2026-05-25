{
  flake,
  pkgs,
  lib,
  ...
}: {
  imports = builtins.attrValues {
    inherit
      (flake.nixosModules)
      linux-preset
      shawn
      zfs
      # Network
      network-base
      dnscrypt-proxy
      # Virtualization
      libvirt
      #containerlab # Temporarily disabled
      # Userspace
      chromium-policy
      dconf
      hyprland
      noctalia
      greetd
      mango
      # Security
      yubikey
      tpm2
      secrets
      tailscale
      packages-base
      packages-desktop
      packages-dev
      packages-network
      # Users
      michael-ssh-agent
      hjem
      hjem-extended
      ;
  };

  services = {
    gvfs.enable = true;
    tumbler.enable = true;
    gnome.gnome-keyring.enable = true;
  };

  # Gnome keyring should only do secrets on the keyring and not SSH, GPG, or PKCS11
  systemd.user.services.gnome-keyring.serviceConfig.ExecStart = [
    "${pkgs.gnome-keyring}/bin/gnome-keyring-daemon --start --foreground --components=secrets"
  ];

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
}
