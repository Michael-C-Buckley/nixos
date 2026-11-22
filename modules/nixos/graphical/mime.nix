{ lib, pkgs, ... }: {
  environment.systemPackages = [ pkgs.xdg-utils ];

  # User associations in ~/.config/mimeapps.list will take precedence
  xdg.mime = {
    enable = true;
    defaultApplications = lib.mapAttrs (_: lib.mkDefault) (
      import ./_mime-defaults.nix { inherit lib; }
    );
  };
}
