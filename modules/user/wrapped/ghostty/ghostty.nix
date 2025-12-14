{config, ...}: {
  perSystem = {pkgs, ...}: {
    packages = {
      ghostty = config.flake.wrappers.mkGhostty {
        inherit pkgs;
        extraConfig = ''
          window-decoration = false
        '';
      };
      ghosttyMac = config.flake.wrappers.mkGhostty {
        inherit pkgs;
      };
    };
  };

  flake.wrappers.mkGhostty = {
    pkgs,
    pkg ? pkgs.ghostty,
    extraConfig ? "",
    extraRuntimeInputs ? [],
  }: let
    buildInputs = [pkgs.cascadia-code] ++ extraRuntimeInputs;
  in
    pkgs.symlinkJoin {
      name = "ghostty";
      paths = [pkg];
      inherit buildInputs;
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/ghostty \
          --add-flags "--config-file=${import ./_config.nix {inherit pkgs extraConfig;}}" \
          --prefix PATH : ${pkgs.lib.makeBinPath buildInputs}
      '';
    };
}
