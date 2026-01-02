{config, ...}: let
  inherit (config) flake;
in {
  flake.hjemConfigs.default = {
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

        impermanence.enable = lib.mkDefault true;

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
          EDITOR = "nvf";
          VISUAL = "nvf";
          PAGER = "bat";
          MANPAGER = "sh -c 'col -bx | bat -l man -p'";
          DIFF = "difft";
          GIT_EDITOR = "nvf";
          CLICOLOR = "1";
          DIFF_COLOR = "auto";
        };
      };
    };
  };
}
