{config, lib, pkgs, user, ...}: {
  imports = [
    # WIP: De-duplicate
    (import ./browser/librewolf.nix {inherit config lib pkgs user;})
    (import ./browser/vivaldi.nix {inherit config lib pkgs user;})
    (import ./communication/discord.nix {inherit config lib pkgs user;})
    (import ./communication/telegram.nix {inherit config lib pkgs user;})
    (import ./communication/signal.nix {inherit config lib pkgs user;})
  ];
}
