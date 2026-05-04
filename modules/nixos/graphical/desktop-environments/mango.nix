{inputs, ...}: {
  flake.modules.nixos.mango = {pkgs, ...}: let
    inherit (pkgs.stdenv.hostPlatform) system;
  in {
    imports = [inputs.mango.nixosModules.mango];

    programs.mango = {
      enable = true;
      package = inputs.mango.packages.${system}.mango;
    };

    environment.systemPackages = with pkgs; [
      grim
      slurp
      wl-clipboard

      bemenu
      fuzzel
      swaylock

      waybar
      wleave
      mako
      swaynotificationcenter
      networkmanagerapplet
      mpd-mpris
      waybar-mpris
    ];
  };
}
