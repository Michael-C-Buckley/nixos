{flake, ...}: {
  imports = builtins.attrValues {
    inherit
      (flake.nixosModules)
      linux-preset
      network-base
      zfs
      shawn
      packages
      packages-network
      # Security
      clamav
      yubikey
      secrets
      pam-ssh
      # Users
      hjem-base
      ;
  };

  services = {
    resolved.enable = false;
    gnome.gnome-keyring.enable = false;
  };
}
