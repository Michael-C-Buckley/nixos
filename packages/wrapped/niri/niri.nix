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
{config, ...}: {
  perSystem = {
    pkgs,
    lib,
    system,
    ...
  }: let
    inherit (config.flake.wrappers) mkNiri;
  in
    lib.optionalAttrs (lib.hasSuffix "linux" system) {
      packages = {
        niri = mkNiri {
          inherit pkgs;
        };
        niri-t14 = mkNiri {
          inherit pkgs;
          extraConfig = config.flake.extraConfigs.t14-niri;
        };
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
      inherit
        (config.flake.packages.${system})
        kitty
        ghostty
        noctalia
        nordzy-cursor
        ;
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
          ghostty
          noctalia
          nordzy-cursor
        ]
        ++ extraRuntimeInputs;

      cfg = import ./_config.nix {inherit pkgs extraConfig spawnNoctalia;};

      print = config.flake.functions.printConfig {
        inherit cfg pkgs;
        name = "niri-print-config";
      };

      stdArgs = ''
        --prefix PATH : ${pkgs.lib.makeBinPath buildInputs} \
        --set XCURSOR_THEME "Nordzy-cursors-white" \
        --set XCURSOR_SIZE "24" \
      '';
    in
      pkgs.symlinkJoin {
        name = "niri";
        paths = [pkg];
        inherit buildInputs;
        passthru.providedSessions = ["niri"];
        postBuild = ''
          # A simple script to print the current config that is active
          cp -r ${print}/bin $out

          # Include a command that wraps the config to be able to just launch it without a service unit
          ln -s $out/bin/niri $out/bin/niri-wrapped
          wrapProgram $out/bin/niri-wrapped \
          --add-flags "-c ${cfg}" \
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
