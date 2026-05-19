{
  inputs,
  flake,
  pkgs,
  lib,
  ...
}: let
  editor = "vim"; # vim on servers, nvim on full systems
  inherit (pkgs.stdenv.hostPlatform) system;
  username = "michael";
  home =
    if (lib.hasSuffix "linux" system)
    then "home"
    else "User";
in {
  imports = [
    flake.nixosModules.hjem-root
    inputs.hjem.nixosModules.default
  ];

  hjem = {
    linker = pkgs.smfh;

    users.michael = {
      environment.sessionVariables = {
        EDITOR = editor;
        VISUAL = editor;
        GIT_EDITOR = editor;
        PAGER = "bat";
        MANPAGER = "less";
        DIFF = "difft";
        CLICOLOR = "1";
        DIFF_COLOR = "auto";
        NH_FLAKE = lib.mkDefault "/${home}/${username}/nixos";
        IP_COLOR = "always";
        NIXPKGS_ALLOW_FREE = "1";
      };
    };
  };
}
