{config, ...}: let
  inherit (config) flake;
  editor = "vim"; # vim on servers, nvim on full systems
in {
  flake.hjemConfigs.default = {
    config,
    pkgs,
    lib,
    ...
  }: {
    hjem = {
      linker = pkgs.smfh;

      # Pull in all my modules
      extraModules = builtins.attrValues flake.hjemModules;

      users.michael = {
        impermanence = {
          enable = lib.mkDefault true;
          cache.directories = lib.optionals config.custom.impermanence.home.enable [
            "Downloads"
            ".cache"
            ".local"
            "flakes"
            "nixos"
            "projects/cache"
          ];
          persist.directories = lib.optionals config.custom.impermanence.home.enable [
            "Documents"
            "Pictures"
            "projects"
          ];
        };

        packages = [
          pkgs.bat
          pkgs.eza
          pkgs.nushell
        ];

        environment.sessionVariables = {
          EDITOR = editor;
          VISUAL = editor;
          GIT_EDITOR = editor;
          PAGER = "bat";
          MANPAGER = "less";
          DIFF = "difft";
          CLICOLOR = "1";
          DIFF_COLOR = "auto";
          NH_FLAKE = lib.mkDefault "/home/michael/nixos";
          IP_COLOR = "always";
          NIXPKGS_ALLOW_FREE = "1";
        };
      };
    };
  };
}
