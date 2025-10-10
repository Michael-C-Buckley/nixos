{inputs, ...}: {
  flake.nixosModules.desktopPreset = {pkgs, ...}: {
    imports = with inputs.self.nixosModules; [
      hyprland
      noctalia
      tuigreet
      gpg-yubikey
      network
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
