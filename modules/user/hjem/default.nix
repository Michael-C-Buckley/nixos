{config, ...}: let
  inherit (config) flake;
  editor = "hx";
in {
  flake.hjemConfigs.default = {
    config,
    pkgs,
    lib,
    ...
  }: {
    imports = with flake.hjemConfigs; [
      fastfetch
      git
    ];

    hjem = {
      linker = pkgs.smfh;

      # Pull in all my modules
      extraModules = builtins.attrValues flake.hjemModules;

      users.michael = {
        # Push the existing files in to be merged
        files = import ../_findFiles.nix {inherit lib;};

        impermanence = {
          enable = lib.mkDefault true;
          # Unconditionally bind out bulky replaceable items from snapshots
          cache.directories = [
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

          # add this to stop the shell error from my wrapped fish since something touched it after creation
          flake.packages.${pkgs.stdenv.hostPlatform.system}.starship

          # Wrapped packages
          flake.packages.${pkgs.stdenv.hostPlatform.system}.git
        ];

        environment.sessionVariables = {
          EDITOR = editor;
          VISUAL = editor;
          GIT_EDITOR = editor;
          PAGER = "bat";
          MANPAGER = "sh -c 'col -bx | bat -l man -p'";
          DIFF = "difft";
          CLICOLOR = "1";
          DIFF_COLOR = "auto";
        };
      };
    };
  };
}
