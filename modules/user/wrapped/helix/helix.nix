{config, ...}: {
  perSystem = {pkgs, ...}: {
    packages.helix = config.flake.wrappers.mkHelix {
      inherit pkgs;
    };
  };

  flake.wrappers.mkHelix = {
    pkgs,
    pkg ? pkgs.helix,
    extraConfig ? "",
    extraRuntimeInputs ? [],
  }: let
    buildInputs = with pkgs;
      [
        alejandra
        nil
        nixd
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
          --add-flags "-c ${import ./_config.nix {inherit pkgs extraConfig;}}" \
          --prefix PATH : ${pkgs.lib.makeBinPath buildInputs}
      '';
    };
}
