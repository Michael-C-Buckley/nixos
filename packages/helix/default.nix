{
  inputs,
  extraGrammars ? [ ],
  callPackage,
  ...
}:
let
  grammars = import ../grammars.nix ++ extraGrammars;
in
# Build from the pinned source with this flake's nixpkgs instead of the
# helix flake's own instance. Only the grammars nvim uses are compiled; the
# rest stay in languages.toml so `hx -g fetch && hx -g build` can add them.
callPackage "${inputs.helix}/default.nix" {
  gitRev = inputs.helix.rev or null;
  includeGrammarIf = grammar: builtins.elem grammar.name grammars;
}
