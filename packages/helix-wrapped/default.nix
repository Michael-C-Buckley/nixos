{
  configPaths,
  inputs,
  extraGrammars ? [ ],
  callPackage,
  symlinkJoin,
  makeBinaryWrapper,
  buildEnv,
  yazi,
  scooter,
  lazygit,
  ...
}:
let
  helix = callPackage ../helix { inherit inputs extraGrammars; };
  helixEnv = buildEnv {
    name = "helix-buildenv";
    pathsToLink = [ "/bin" ];
    paths = [
      yazi
      scooter
      lazygit
    ];
  };
in
symlinkJoin {
  name = "hx";
  paths = [ helix ];
  nativeBuildInputs = [ makeBinaryWrapper ];

  postBuild = ''
    wrapProgram "$out/bin/hx" \
      --prefix PATH : ${helixEnv}/bin \
      --add-flag --config \
      --add-flag ${configPaths.helix + "/config.toml"}
  '';
}
