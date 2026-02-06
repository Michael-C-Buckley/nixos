{config, ...}: {
  perSystem = {pkgs, ...}: {
    packages.helix = config.flake.wrappers.mkHelix {
      inherit pkgs;
    };
  };

  flake.wrappers = {
    mkHelixLanguages = {pkgs}: pkgs.lib.importTOML ./languages.toml;
    mkHelixConfig = {pkgs}: import ./_config.nix {inherit pkgs;};

    mkHelix = {
      pkgs,
      pkg ? pkgs.helix,
      extraRuntimeInputs ? [],
    }: let
      buildInputs = with pkgs;
        [
          # Nix
          alejandra
          nil
          nixd
          # Python
          basedpyright
          ty
          ruff
          # Yaml/json
          yaml-language-server
          vscode-json-languageserver
        ]
        ++ extraRuntimeInputs;
    in
      pkgs.symlinkJoin {
        name = "hx";
        paths = [pkg];
        inherit buildInputs;
        nativeBuildInputs = [pkgs.makeWrapper];
        postBuild = ''
          mkdir $out/helix
          ln -s ${import ./_config.nix {inherit pkgs;}} $out/helix/config.toml
          ln -s ${./languages.toml} $out/helix/language.toml
          wrapProgram $out/bin/hx \
            --prefix PATH : ${pkgs.lib.makeBinPath buildInputs} \
            --set XDG_CONFIG_HOME $out
        '';
      };
  };
}
