{config, ...}: let
  inherit (config.flake.wrappers) mkHyprland mkHyprlandConfig;
in {
  perSystem = {
    pkgs,
    lib,
    system,
    ...
  }:
    lib.optionalAttrs (lib.hasSuffix "linux" system) {
      packages = {
        hyprland = mkHyprland {inherit pkgs;};
        hyprlandConfig = mkHyprlandConfig {inherit pkgs;};
      };
    };

  flake.wrappers = {
    mkHyprlandConfig = {
      pkgs,
      hyprland ? pkgs.hyprland,
      hostConfig ? null,
    }: let
      src = import ./_config.nix {inherit pkgs hostConfig;};
    in
      pkgs.stdenv.mkDerivation {
        name = "hyprland-config";
        inherit src;
        nativeBuildInputs = [hyprland];
        dontUnpack = true;
        dontInstall = true;
        buildPhase = ''
          # Needs to be set but isn't real and isn't used in prod
          export XDG_RUNTIME_DIR=/run/user/9999
          hyprland --verify-config -c ${src}
          cp ${src} $out
        '';
      };

    mkHyprland = {
      pkgs,
      hostConfig ? null,
      pkg ? pkgs.hyprland,
      extraRuntimeInputs ? [],
    }: let
      inherit (pkgs.stdenv.hostPlatform) system;
      inherit (config.flake.packages.${system}) kitty noctalia nordzy-cursor;
      # Add the necessary packages for a functional as-is experience
      # For me, this means Noctalia and Kitty
      buildInputs = with pkgs;
        [
          hyprshot
          hyprcursor
          hyprpolkitagent
          xdg-desktop-portal

          clipse
          wl-clip-persist
          wl-clipboard
          xclip

          makeWrapper
          wireplumber
          playerctl
        ]
        ++ [
          kitty
          noctalia
          nordzy-cursor
        ]
        ++ extraRuntimeInputs;

      hyprlandCfg = import ./_config.nix {inherit pkgs hostConfig;};
    in
      pkgs.symlinkJoin {
        name = "hyprland";
        paths = [pkg];
        inherit buildInputs;
        passthru.providedSessions = ["hyprland"];
        postBuild = ''
          # This is needed only to verify the config, not at runtime
          export XDG_RUNTIME_DIR=/run/user/9999

          $out/bin/hyprland --verify-config --config ${hyprlandCfg}
          wrapProgram $out/bin/start-hyprland \
            --prefix PATH : ${pkgs.lib.makeBinPath buildInputs} \
            --add-flags "-c ${hyprlandCfg}"
        '';
      };
  };
}
