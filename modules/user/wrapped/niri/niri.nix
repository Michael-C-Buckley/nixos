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
  }: let
    buildInputs = [pkgs.makeWrapper] ++ extraRuntimeInputs;
  in
    pkgs.symlinkJoin {
      name = "niri";
      paths = [niri];
      inherit buildInputs;
      postBuild = ''
        wrapProgram $out/bin/niri \
          --add-flags "-c ${import ./_config.nix {inherit pkgs extraConfig;}} --session" \
          --prefix PATH : ${pkgs.lib.makeBinPath buildInputs}
      '';
    };
}
