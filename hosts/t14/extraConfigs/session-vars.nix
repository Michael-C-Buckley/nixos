{config, ...}: let
  inherit (config.flake) packages;
in {
  # Common Session Variables I reuse
  # Will require priming with pkgs to get the cursor path
  flake.custom.extraConfigs.session-vars = {pkgs}: let
    inherit (pkgs.stdenv.hostPlatform) system;
  in {
    XCURSOR_PATH = "${packages.${system}.nordzy-cursor}/share/icons";
    XCURSOR_THEME = "Nordzy-cursors-white";
    XCURSOR_SIZE = "24";
  };
}
