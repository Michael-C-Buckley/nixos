{inputs, ...}: let
  inherit (inputs.self) nixosModules;
in {
  imports = [../packages/_gui.nix]; # To make sure the GUI packages are available for evaluation
  flake.nixosModules.desktopPreset = {
    imports = with nixosModules; [
      # keep-sorted start
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
      hjem-extended
      hjem-root
      # keep-sorted end
    ];
  };
}
