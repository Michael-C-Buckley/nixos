{config, ...}: {
  perSystem = {pkgs, ...}: {
    packages.helix = config.flake.wrappers.mkHelix {
      inherit pkgs;
    };
  };

  flake.wrappers.mkHelix = {
    pkgs,
    pkg ? pkgs.helix,
    extraRuntimeInputs ? [],
  }: let
    buildInputs = with pkgs;
      [
        alejandra
        nil
        nixd
        basedpyright
        ty
        ruff
        (python3.withPackages (ps: [ps.debugpy]))
      ]
      ++ extraRuntimeInputs;
  in
    pkgs.symlinkJoin {
      name = "hx";
      paths = [pkg];
      inherit buildInputs;
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/hx \
          --prefix PATH : ${pkgs.lib.makeBinPath buildInputs}
      '';
    };
}
