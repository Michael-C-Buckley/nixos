{inputs, ...}: {
  flake.nixosModules.desktopPreset = {
    imports = with inputs.self.nixosModules; [
      hyprland
      tuigreet
      gpg-yubikey
      netowork
      packages
      fonts
      dconf
      tpm2
      impermanence
      zfs
      boot
      users
    ];
  };
}
