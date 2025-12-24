{config, ...}: {
  perSystem = {
    pkgs,
    lib,
    system,
    ...
  }:
    lib.optionalAttrs (lib.hasSuffix "linux" system) {
      packages.niri = config.flake.wrappers.mkNiri {
        inherit pkgs;
      };
    };

  flake.wrappers.mkNiri = {
    pkgs,
    pkg ? pkgs.niri,
    extraConfig ? "",
    extraRuntimeInputs ? [],
    spawnNoctalia ? true,
  }: let
    inherit (pkgs.stdenv.hostPlatform) system;
    inherit (config.flake.packages.${system}) kitty noctalia;
    # Add the necessary packages for a functional as-is experience
    # For me, this means Noctalia and Kitty
    buildInputs = with pkgs;
      [
        makeWrapper
        hyprlock
        wireplumber
        playerctl
        xwayland-satellite
        nordzy-cursor-theme
      ]
      ++ [
        kitty
        noctalia
      ]
      ++ extraRuntimeInputs;
  in
    pkgs.symlinkJoin {
      name = "niri";
      paths = [pkg];
      inherit buildInputs;
      passthru.providedSessions = ["niri"];
      postBuild = ''
        wrapProgram $out/bin/niri \
          --add-flags "--session -c ${import ./_config.nix {inherit pkgs extraConfig spawnNoctalia;}}" \
          --prefix PATH : ${pkgs.lib.makeBinPath buildInputs}
      '';
    };
}
