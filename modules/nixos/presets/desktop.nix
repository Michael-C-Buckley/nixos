{inputs, ...}: {
  flake.nixosModules.desktopPreset = {pkgs, ...}: {
    imports = with inputs.self.nixosModules; [
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
    ];

    environment.systemPackages = with pkgs; [
      winbox4
    ];
  };
}
