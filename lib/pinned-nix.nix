{ lib }:
inputs:
let
  # Tack also exposes a __functor; only register actual flake inputs.
  flakes = lib.filterAttrs (
    _: input: builtins.isAttrs input && input._type or null == "flake"
  ) inputs;
in
{
  registry = lib.mapAttrs (_: input: {
    to = {
      type = "path";
      path = input.outPath;
    };
  }) flakes;
  nixPath = lib.mapAttrsToList (name: input: "${name}=${input.outPath}") flakes;
}
