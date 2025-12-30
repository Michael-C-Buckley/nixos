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

  flake.wrappers = {
    mkNiriConfig = {
      pkgs,
      extraConfig ? "",
      spawnNoctalia ? true,
    }:
      import ./_config.nix {inherit pkgs extraConfig spawnNoctalia;};
    mkNiri = {
      pkgs,
      pkg ? pkgs.niri,
      extraConfig ? "",
      extraRuntimeInputs ? [],
      spawnNoctalia ? true,
      useFlags ? true,
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
        postBuild =
          ''
            wrapProgram $out/bin/niri \
              --prefix PATH : ${pkgs.lib.makeBinPath buildInputs} \
          ''
          + (
            if useFlags
            then ''
              --add-flags "--session -c ${import ./_config.nix {inherit pkgs extraConfig spawnNoctalia;}}"
            ''
            else ''''
          );
      };
  };
}
