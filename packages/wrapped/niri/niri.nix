# Fully Wrapped Niri (with Caveats)
# This generally just works *but* only with systemd implementations
# as the binary itself is not wrapped
# You can check the builder were the config is injected into the
# service unit
#
# I previously attempted to manually wrap the binary instead and
# it had issues as the `niri msg` output stopped working due to
# flag interference
#
# I also include other elements of my Niri experience, which is
# Noctalia and Kitty
{config, ...}: let
  inherit (config.flake.custom.functions) printConfig;
in {
  perSystem = {
    pkgs,
    lib,
    system,
    ...
  }: let
    inherit (config.flake.custom.wrappers) mkNiri;
  in
    lib.optionalAttrs (lib.hasSuffix "linux" system) {
      packages = {
        niri = mkNiri {
          inherit pkgs;
        };
        niri-t14 = mkNiri {
          inherit pkgs;
          systemd = false;
          extraConfig = config.flake.custom.extraConfigs.t14-niri;
        };
      };
    };

  flake.custom.wrappers = {
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
      systemd ? true,
    }: let
      inherit
        (config.flake.packages.${pkgs.stdenv.hostPlatform.system})
        kitty
        ghostty
        noctalia
        nordzy-cursor
        ;
      # Add the necessary packages for a functional as-is experience
      # For me, this means Noctalia and Kitty
      nativeBuildInputs = with pkgs; [makeWrapper];
      runtimeInputs =
        (builtins.attrValues {
          inherit kitty ghostty noctalia;
          inherit
            (pkgs)
            wireplumber
            playerctl
            xwayland-satellite
            xdg-desktop-portal-gnome
            ;
        })
        ++ extraRuntimeInputs;

      runtimeEnv = pkgs.buildEnv {
        name = "niri-runtime-env";
        paths = runtimeInputs;
        pathsToLink = ["/bin"];
      };

      cfg = import ./_config.nix {inherit pkgs extraConfig systemd spawnNoctalia;};

      print = printConfig {
        inherit cfg pkgs;
        name = "niri-print-config";
      };

      stdArgs = ''
        --prefix PATH : ${runtimeEnv}/bin \
        --prefix XCURSOR_PATH : ${nordzy-cursor}/share/icons \
        --set XCURSOR_THEME "Nordzy-cursors-white" \
        --set XCURSOR_SIZE "24" \
      '';
    in
      pkgs.symlinkJoin {
        name = "niri";
        paths = [pkg];
        inherit nativeBuildInputs;
        passthru.providedSessions = ["niri"];
        postBuild = ''
          # A simple script to print the current config that is active
          cp -r ${print}/bin $out

          # Include a command that wraps the config to be able to just launch it without a service unit
          ln -s $out/bin/niri $out/bin/niri-wrapped
          wrapProgram $out/bin/niri-wrapped \
          --add-flags "-c ${cfg}" \
            ${stdArgs}

          ln -s $out/bin/niri $out/bin/niri-session-wrapped
          wrapProgram $out/bin/niri-session-wrapped \
          --add-flags "--session -c ${cfg}" \
            ${stdArgs}
          # Override the systemd unit to include the config
          mkdir -p $out/lib/systemd/user/niri.service.d
          cat > $out/lib/systemd/user/niri.service.d/override.conf <<EOF
          [Service]
          ExecStart=
          ExecStart=$out/bin/niri --session -c ${cfg}
          EOF

          $out/bin/niri validate -c ${cfg}
          wrapProgram $out/bin/niri \
            ${stdArgs}
        '';
      };
  };
}
