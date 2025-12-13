{config, ...}: {
  perSystem = {pkgs, ...}: {
    packages.niri = config.flake.wrappers.mkNiri {
      inherit pkgs;
    };
  };

  flake.wrappers.mkNiri = {
    pkgs,
    niri ? pkgs.niri,
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
      ]
      ++ [
        kitty
        noctalia
      ]
      ++ extraRuntimeInputs;
  in
    pkgs.symlinkJoin {
      name = "niri";
      paths = [niri];
      inherit buildInputs;
      passthru.providedSessions = ["niri"];
      postBuild = ''
        wrapProgram $out/bin/niri \
          --add-flags "--session -c ${import ./_config.nix {inherit pkgs extraConfig spawnNoctalia;}}" \
          --prefix PATH : ${pkgs.lib.makeBinPath buildInputs}
      '';
    };
}
