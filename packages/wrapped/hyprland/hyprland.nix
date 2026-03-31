# Wrapped Hyprland for me is a full drop-in experience where I include
# configs plus other essentials like my wrapped Noctalia and Kitty
#
# I wrap the binary, unlike Niri, since it does not interfere with
# normal operation
#
# This is not yet deployed with Systemd, though I will eventually
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
      # Add the necessary packages for a functional as-is experience
      # For me, this means Noctalia and Kitty
      runtimeEnv = pkgs.buildEnv {
        name = "hyprland-runtime-env";
        pathsToLink = ["/bin"];
        paths =
          (builtins.attrValues {
            inherit
              (pkgs)
              hyprshot
              hyprcursor
              hyprpolkitagent
              xdg-desktop-portal
              clipse
              wl-clip-persist
              wl-clipboard
              xclip
              wireplumber
              playerctl
              ;

            inherit
              (config.flake.packages.${pkgs.stdenv.hostPlatform.system})
              kitty
              ghostty
              noctalia
              nordzy-cursor
              ;
          })
          ++ extraRuntimeInputs;
      };

      cfg = import ./_config.nix {inherit pkgs hostConfig;};

      printCfg = config.flake.functions.printConfig {
        inherit cfg pkgs;
        name = "hyprland-print-config";
      };
    in
      pkgs.symlinkJoin {
        name = "hyprland";
        paths = [pkg];
        buildInputs = [pkgs.makeWrapper];
        passthru.providedSessions = ["hyprland"];
        postBuild = ''
          cp -r ${printCfg}/bin $out

          # This is needed only to verify the config, not at runtime
          export XDG_RUNTIME_DIR=/run/user/9999
          $out/bin/hyprland --verify-config --config ${cfg}

          wrapProgram $out/bin/start-hyprland \
            --prefix PATH : ${runtimeEnv}/bin \
            --add-flags "-c ${cfg}"
        '';
      };
  };
}
