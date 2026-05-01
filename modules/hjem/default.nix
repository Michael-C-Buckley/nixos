{config, ...}: let
  inherit (config) flake;
  editor = "vim"; # vim on servers, nvim on full systems
in {
  flake.custom.hjemConfigs.default = {
    config,
    pkgs,
    lib,
    ...
  }: let
    inherit (pkgs.stdenv.hostPlatform) system;
    inherit (config.custom.hjem) username;
    home =
      if (lib.hasSuffix "linux" system)
      then "home"
      else "User";
  in {
    config.hjem = {
      linker = pkgs.smfh;

      # Pull in all my modules
      extraModules = builtins.attrValues flake.custom.hjemModules;

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
          GIT_SIGNING_KEYS_FILE = flake.custom.wrappers.mkGitSignersFile {inherit pkgs;};
          GIT_CONFIG_GLOBAL = flake.custom.wrappers.mkGitConfig {inherit pkgs username;};
        };
      };
    };
  };
}
