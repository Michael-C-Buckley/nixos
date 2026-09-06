{
  self,
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) system;
  cfg = self.packages.${system}.umbriel-config.override {
    inherit (config.custom.umbriel) extraConfig;
  };
in
{
  options.custom.umbriel.extraConfig = lib.mkOption {
    description = "Extra config for umbriel";
    type = lib.types.attrsOf lib.types.anything;
    default = { };
  };
  config = {
    programs = {
      noctalia = {
        enable = true;
        systemd.enable = true;
        recommendedServices.enable = true;
      };
      umbriel.enable = true;
    };

    environment.systemPackages = with pkgs; [
      playerctl
      wl-clipboard
    ];

    hjem.users.michael.xdg.config.files = {
      "umbriel/config.toml".source = "${cfg}/umbriel.toml";
      "noctalia/settings.toml".source = "${self.packages.${system}.noctalia-config}/settings.toml";
    };
  };
}
