{config, lib, pkgs, user, ... }:

let
  userArgs = { inherit config lib pkgs user; };

  # helper to import a module with special args
  importWithArgs = modulePath:
    (import modulePath) userArgs;

  modules = [
    (importWithArgs ./apps/browser/librewolf.nix)
    (importWithArgs ./modules)
  ];

in
lib.foldl' lib.recursiveUpdate {} modules
