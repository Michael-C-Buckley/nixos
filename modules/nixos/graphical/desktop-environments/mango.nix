{inputs, ...}: {
  flake.modules.nixos.mango = {pkgs, ...}: let
    inherit (pkgs.stdenv.hostPlatform) system;
  in {
    programs.mangowc = {
      enable = true;
      package = inputs.mango.packages.${system}.mango;
    };

    environment.systemPackages = with pkgs; [
      grim
      slurp
    ];
  };
}
