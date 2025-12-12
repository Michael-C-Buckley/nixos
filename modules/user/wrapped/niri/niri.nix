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
    spawnViaSystemd ? true,
  }: let
    inherit (pkgs.stdenv.hostPlatform) system;
    # Add the necessary packages for a functional as-is experience
    # For me, this means Noctalia and Kitty
    buildInputs =
      [
        pkgs.makeWrapper
        config.inputs.noctalia.packages.${system}.default # TODO: add wrapper for noctalia and it's deps
        config.flake.packages.${system}.kitty
      ]
      ++ extraRuntimeInputs;
  in
    pkgs.symlinkJoin {
      name = "niri";
      paths = [niri];
      inherit buildInputs;
      postBuild = ''
        wrapProgram $out/bin/niri \
          --add-flags "-c ${import ./_config.nix {inherit pkgs extraConfig spawnViaSystemd;}} --session" \
          --prefix PATH : ${pkgs.lib.makeBinPath buildInputs}
      '';
    };
}
