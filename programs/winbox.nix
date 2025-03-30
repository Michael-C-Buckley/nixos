{
  config,
  pkgs,
  ...
}: let
  graphics = config.features.graphics;
  netTools = config.features.pkgs.netTools;
  # Winbox is not available on ARM
  useWinbox = graphics && netTools && config.nixpkgs.hostPlatform == "x86_64-linux";
in {
  programs.winbox = {
    enable = useWinbox;
    package = pkgs.winbox4;
    openFirewall = useWinbox;
  };
}
