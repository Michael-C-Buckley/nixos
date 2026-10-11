{
  pkgs,
  lib,
  ...
}:
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
  };
}
