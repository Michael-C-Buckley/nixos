# Wrapping Ghostty allows me to ship the entire experience, which
# is the config I use plus the font I use with it
#
# There is some slightly different logic for handling the wrapping
# of Linux or MacOS versions with minor tweaks to the configs
{
  config,
  lib,
  ...
}: let
  inherit (config.flake.custom.wrappers) mkGhosttyConfig;
  cfg = {
    theme = "Niji";
    background = "#000000";
    cursor-color = "#44A3A3";
    cursor-opacity = "0.6";
    font-family = "Cascadia Code NF";
    font-size = "11";
    window-theme = "system";
  };

  binds = {
    "performable:ctrl+shift+h" = "previous_tab";
    "performable:ctrl+shift+l" = "next_tab";
  };
in {
  perSystem = {
    pkgs,
    system,
    lib,
    ...
  }: let
    # Separate logic is needed for linux or mac
    # One goes to linux; Two goes to Mac
    # I have a few things different on the MacOS side
    separate = one: two:
      if (lib.hasSuffix "linux" system)
      then one
      else two;
    pkg = separate pkgs.ghostty pkgs.ghostty-bin;
    extraConfig = separate {} {
      command = "fish";
      window-decoration = false;
    };
  in {
    packages = {
      ghostty = config.flake.custom.wrappers.mkGhostty {
        inherit pkg pkgs extraConfig;
      };
    };
  };

  flake.custom.wrappers = {
    mkGhosttyConfig = {
      pkgs,
      extraConfig ? {},
      extraBinds ? {},
    }: let
      allConfig = cfg // extraConfig;
      allBinds = binds // extraBinds;
      configLines = lib.mapAttrsToList (k: v: "${k} = ${toString v}") allConfig;
      bindLines = lib.mapAttrsToList (k: v: "keybind = ${k}=${v}") allBinds;
    in
      pkgs.writeText "ghostty-wrapped-config" (lib.concatStringsSep "\n" (configLines ++ bindLines));

    mkGhostty = {
      pkgs,
      pkg ? pkgs.ghostty,
      extraConfig ? {},
      extraBinds ? {},
    }: let
      # The MacOS ghostty comes from the official dmg and is in a different location
      ghosttyBinary =
        if pkgs.stdenv.isDarwin
        then "$out/Applications/Ghostty.app/Contents/MacOS/ghostty"
        else "$out/bin/ghostty";

      cfg = mkGhosttyConfig {inherit pkgs extraConfig extraBinds;};

      printCfg = config.flake.custom.functions.printConfig {
        inherit cfg pkgs;
        name = "ghostty-print-config";
      };
    in
      pkgs.symlinkJoin {
        name = "ghostty";
        paths = [pkg];
        nativeBuildInputs = [pkgs.makeWrapper];
        postBuild = ''
          cp -r ${printCfg}/bin $out

          wrapProgram ${ghosttyBinary} \
            --add-flags "--config-file=${cfg}" \
            --set FONTCONFIG_FILE ${pkgs.makeFontsConf {fontDirectories = [pkgs.cascadia-code];}}
        '';
      };
  };
}
