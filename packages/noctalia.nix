{ pkgs, ... }:
let
  inherit (pkgs) lib;
  defaultSettings = {
    bar = {
      order = [ "default" ];
      default = {
        background_opacity = 0.5;
        center = [
          "clock"
          "notifications"
        ];
        end = [
          "tray"
          "bluetooth"
          "volume"
          "brightness"
          "session"
        ];
        font_family = "Consolas";
        font_weight = 700;
        margin_edge = 0;
        margin_ends = 0;
        radius = 0;
        shadow = false;
        thickness = 22;
      };
    };

    nightlight.enabled = true;

    osd.position = "top_right";

    shell = {
      external_ip_enabled = true;
      polkit_agent = true;
      telemetry_enabled = false;
      screenshot = {
        directory = "/tmp";
        show_cursor = true;
      };
    };

    theme = {
      builtin = "Ayu";
      mode = "dark";
      source = "builtin";
    };

    wallpaper.directory = "/home/michael/Pictures/wallpapers";

    weather.unit = "imperial";

    widget = {
      launcher.glyph = "rocket";
      notifications.hide_when_no_unread = true;
    };
  };

  # extraSettings is recursively merged over defaultSettings, so callers only need to specify what they're changing
  mkNoctaliaConfig = lib.makeOverridable (
    {
      extraSettings ? { },
    }:
    let
      settings = lib.recursiveUpdate defaultSettings extraSettings;
      settingsToml = pkgs.writers.writeTOML "settings.toml" settings;
    in
    pkgs.stdenvNoCC.mkDerivation {
      pname = "noctalia-config";
      version = "0-unstable";

      dontUnpack = true;

      buildPhase = ''
        runHook preBuild
        cp ${settingsToml} settings.toml
        runHook postBuild
      '';

      # Lint the generated config with noctalia's own validator before it can be installed
      nativeCheckInputs = [ pkgs.noctalia ];
      doCheck = true;
      checkPhase = ''
        runHook preCheck
        noctalia config validate settings.toml
        runHook postCheck
      '';

      installPhase = ''
        runHook preInstall
        install -Dm444 settings.toml "$out/settings.toml"
        runHook postInstall
      '';
    }
  );
in
mkNoctaliaConfig { }
