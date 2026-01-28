# Get helium to work properly
{config, ...}: let
  inherit (config) flake;
in {
  flake.modules.homeManager.helium = {pkgs, ...}: {
    fonts.fontconfig.enable = true;

    xdg.configFile."net.imput.helium/WidevineCdm/latest-component-updated-widevine-cdm".text = ''
      {"Path":"${pkgs.widevine-cdm}/share/google/chrome/WidevineCdm"}
    '';
    home.packages = [
      flake.packages.${pkgs.stdenv.hostPlatform.system}.helium
      pkgs.dejavu_fonts
      pkgs.noto-fonts
    ];
  };
}
