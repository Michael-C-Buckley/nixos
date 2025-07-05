# Declarative Flatpaks
# Based heavily on Joshprk's work:
# https://github.com/joshprk/flake/blob/main/nixos/apps/flatpak.nix
{
  config,
  lib,
  ...
}: let
  inherit (lib) concatStringsSep mkIf mkOption optionals mapAttrsToList;
  inherit (lib.types) attrsOf listOf str submodule;
  inherit (config.services) flatpak;
  inherit (config.system) impermanence;

  local = config.services.flatpak;

  mkStrOption = mkOption {type = str;};

  appSubmodule = listOf (submodule {
    options = {
      remote = mkStrOption;
      name = mkStrOption;
    };
  });
in {
  options.services.flatpak = {
    remotes = mkOption {
      type = attrsOf str;
      description = "An attribute set of Flatpak remotes.";
      default = {
        flathub = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      };
    };
    apps = mkOption {
      type = appSubmodule;
      description = "A list of applications which are automatically installed.";
      default = [];
    };
  };

  config = mkIf flatpak.enable {
    environment = {
      persistence."/cache".directories = optionals impermanence.enable [
        "/var/lib/flatpak"
      ];
      sessionVariables = {
        XDG_DATA_DIRS = [
          "/var/lib/flatpak/exports/share"
          "/usr/share"
          "$HOME/.local/share/flatpak/exports/share"
        ];
      };
    };
    systemd.services.flatpak-declare = {
      enable = false; # Still testing
      wantedBy = ["multi-user.target"];
      after = ["network-online.target" "nss-lookup.target"];
      wants = ["network-online.target" "nss-lookup.target"];
      path = [config.services.flatpak.package];
      serviceConfig.IOSchedulingClass = "2";
      serviceConfig.IOSchedulingPriority = "6";
      script = let
        remotesScript =
          local.remotes
          |> mapAttrsToList (
            n: v: "flatpak remote-add --if-not-exists ${n} ${v}"
          )
          |> concatStringsSep "\n";

        installScript =
          local.apps
          |> map (v: "flatpak install ${v.remote} ${v.name}")
          |> concatStringsSep "\n";
      in ''
        ${remotesScript}
        ${installScript}
        flatpak remove --unused
      '';
    };
  };
}
