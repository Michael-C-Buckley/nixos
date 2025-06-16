{
  config,
  pkgs,
  system,
  lib,
  ...
}: let
  inherit (config.features) graphics;
  inherit (config.features.pkgs) netTools;
  # Winbox is not available on ARM
  useWinbox = graphics && netTools && system == "x86_64-linux";
in {
  programs.winbox = {
    enable = lib.mkDefault useWinbox;
    package = pkgs.winbox4;
    openFirewall = useWinbox;
  };
}
