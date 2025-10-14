{inputs, ...}: let
  inherit (inputs.self) nixosModules;
in {
  flake.nixosModules.desktopPreset = {
    imports = with nixosModules; [
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
    ];
  };
}
