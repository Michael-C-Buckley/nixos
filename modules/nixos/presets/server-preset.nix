{flake, ...}: {
  imports = builtins.attrValues {
    inherit
      (flake.nixosModules)
      linux-preset
      network-base
      zfs
      shawn
      packages-base
      packages-network
      # Security
      clamav
      yubikey
      secrets
      # Users
      hjem
      ;
  };

  services = {
    resolved.enable = false;
    gnome.gnome-keyring.enable = false;
  };
}
