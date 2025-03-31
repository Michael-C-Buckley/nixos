{
  config,
  pkgs,
  system,
  ...
}: let
  graphics = config.features.graphics;
  netTools = config.features.pkgs.netTools;
  # Winbox is not available on ARM
  useWinbox = graphics && netTools && system == "x86_64-linux";
in {
  programs.winbox = {
    enable = useWinbox;
    package = pkgs.winbox4;
    openFirewall = useWinbox;
  };
}
