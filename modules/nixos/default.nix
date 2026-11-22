# Grab all the files and make them available
{ lib }:
let
  inherit (lib) filterAttrs;
  inherit (lib.filesystem) readDir;
  getFilename = n: builtins.head (lib.splitString "." n);
in
readDir ./.
# Get the folder names as attrs, exclude files at the base
|> filterAttrs (_: a: a == "directory")
# Start nesting them
|> builtins.mapAttrs (
  b: _:
  readDir (./. + "/${b}")
  |> filterAttrs (c: _: !lib.hasPrefix "_" c)
  |> lib.concatMapAttrs (d: _: { "${getFilename d}" = ./. + "/${b}/${d}"; })
)
