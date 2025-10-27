{config, ...}: {
  flake.modules.nixos.desktopPreset = {
    imports = with config.flake.modules.nixos; [
      linuxPreset
      hyprland
      noctalia
      tuigreet
      gpg-yubikey
      fonts
      dconf
      tpm2
      impermanence
      zfs
      boot
      users
      hjem-extended
      hjem-root
      shawn

      packages
      packages-desktop

      # Applications
      app-bitwarden
      app-helium
      app-jan
      app-legcord
      app-librewolf
      app-materialgram
      app-obsidian
      app-signal
      app-vscode
      app-zed
    ];
  };
}
