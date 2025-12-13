{config, ...}: {
  perSystem = {pkgs, ...}: {
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
        niri # include unwrapped for msg/ipc/etc
        makeWrapper
        hyprlock
        wireplumber
        playerctl
        xwayland-satellite
      ]
      ++ [
        kitty
        noctalia
      ]
      ++ extraRuntimeInputs;
  in
    pkgs.symlinkJoin {
      name = "niri-wrapped";
      paths = [pkg];
      inherit buildInputs;
      passthru.providedSessions = ["niri"];
      postBuild = ''
        mv $out/bin/niri $out/bin/niri-wrapped
        wrapProgram $out/bin/niri-wrapped \
          --add-flags "--session -c ${import ./_config.nix {inherit pkgs extraConfig spawnNoctalia;}}" \
          --prefix PATH : ${pkgs.lib.makeBinPath buildInputs}
      '';
    };
}
