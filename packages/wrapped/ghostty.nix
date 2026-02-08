{config, ...}: let
  cfg = {
    theme = "Wombat";
    background = "#000000";
    cursor-color = "#44A3A3";
    cursor-opacity = "0.6";
    font-family = "Cascadia Code NF";
    font-size = "11";
    window-theme = "system";
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
    extraRuntimeInputs = separate [] [config.flake.packages.${system}.fish];
  in {
    packages = {
      ghostty = config.flake.wrappers.mkGhostty {
        inherit pkg pkgs extraConfig extraRuntimeInputs;
      };
    };
  };

  flake.wrappers.mkGhostty = {
    pkgs,
    pkg ? pkgs.ghostty,
    extraConfig ? {},
    extraRuntimeInputs ? [],
  }: let
    buildInputs = [pkgs.cascadia-code] ++ extraRuntimeInputs;
    # The MacOS ghostty comes from the official dmg and is in a different location
    ghosttyBinary =
      if pkgs.stdenv.isDarwin
      then "$out/Applications/Ghostty.app/Contents/MacOS/ghostty"
      else "$out/bin/ghostty";
  in
    pkgs.symlinkJoin {
      name = "ghostty";
      paths = [pkg];
      inherit buildInputs;
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram ${ghosttyBinary} \
          --add-flags "--config-file=${pkgs.writers.writeTOML "ghostty-wrapped-config" (cfg // extraConfig)}" \
          --prefix PATH : ${pkgs.lib.makeBinPath buildInputs}
      '';
    };
}
