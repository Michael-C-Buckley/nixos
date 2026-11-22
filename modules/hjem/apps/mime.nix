{ lib, pkgs, ... }: {
  packages = [
    pkgs.xdg-utils
    pkgs.shared-mime-info
  ];
  xdg.mime-apps.default-applications = lib.mapAttrs (_: lib.mkDefault) (
    import ../../nixos/graphical/_mime-defaults.nix { inherit lib; }
  );
}
