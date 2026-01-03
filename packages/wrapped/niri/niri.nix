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
    }: let
      inherit (pkgs.stdenv.hostPlatform) system;
      inherit (config.flake.packages.${system}) kitty noctalia nordzy-cursor;
      # Add the necessary packages for a functional as-is experience
      # For me, this means Noctalia and Kitty
      buildInputs = with pkgs;
        [
          makeWrapper
          hyprlock
          wireplumber
          playerctl
          xwayland-satellite
        ]
        ++ [
          kitty
          noctalia
          nordzy-cursor
        ]
        ++ extraRuntimeInputs;

      niriCfg = import ./_config.nix {inherit pkgs extraConfig spawnNoctalia;};
    in
      pkgs.symlinkJoin {
        name = "niri";
        paths = [pkg];
        inherit buildInputs;
        passthru.providedSessions = ["niri"];
        postBuild = ''
          # Override the system unit to include the config
          mkdir -p $out/lib/systemd/user/niri.service.d
          cat > $out/lib/systemd/user/niri.service.d/override.conf <<EOF
          [Service]
          ExecStart=
          ExecStart=$out/bin/niri --session -c ${niriCfg}
          EOF

          $out/bin/niri validate -c ${niriCfg}
          wrapProgram $out/bin/niri \
            --prefix PATH : ${pkgs.lib.makeBinPath buildInputs}
        '';
      };
  };
}
