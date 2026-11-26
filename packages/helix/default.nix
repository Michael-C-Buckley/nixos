{
  inputs,
  extraGrammars ? [ ],
  configPaths,
  # Provided by callPackage when this is evaluated
  callPackage,
  symlinkJoin,
  makeBinaryWrapper,
  ...
}:
let
  grammars = import ../grammars.nix ++ extraGrammars;
  # Build from the pinned source with this flake's nixpkgs instead of the
  # helix flake's own instance. Only the grammars nvim uses are compiled; the
  # rest stay in languages.toml so `hx -g fetch && hx -g build` can add them.
  helix = callPackage "${inputs.helix}/default.nix" {
    gitRev = inputs.helix.rev or null;
    includeGrammarIf = grammar: builtins.elem grammar.name grammars;
  };
in
symlinkJoin {
  name = "hx";
  paths = [ helix ];
  nativeBuildInputs = [ makeBinaryWrapper ];
  # Add just the config, for now, as I used to change XDG Home
  # however this affects everything else that Helix runs, like LSPs
  postBuild = ''
    wrapProgram $out/bin/hx \
      --add-flags "-c ${configPaths.helix + "/config.toml"}"
  '';
}
