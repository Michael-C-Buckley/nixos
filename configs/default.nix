{ lib }:
lib.filesystem.readDir ../configs
|> lib.filterAttrs (_: v: v == "directory")
|> builtins.mapAttrs (n: _: ../configs + "/${n}")
