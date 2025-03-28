{config, pkgs, ...}:
let
  graphics = config.features.graphics;
  netTools = config.features.pkgs.netTools;
  useWinbox = graphics && netTools;
in {
  programs.winbox = {
    enable = useWinbox;
    package = pkgs.winbox4;
    openFirewall = useWinbox;
  };
}
