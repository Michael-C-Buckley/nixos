{inputs, ...}: {
  flake.modules.nixos.desktopPreset = {
    imports = with inputs.self.modules.nixos; [
      linuxPreset
      hyprland
      noctalia
      tuigreet
      gpg-yubikey
      packages
      fonts
      dconf
      tpm2
      impermanence
      zfs
      boot
      users
      desktopPackages
      guiPackages
      hjem-extended
      hjem-root
      shawn

      # Applications
      app-jan
    ];
  };
}
