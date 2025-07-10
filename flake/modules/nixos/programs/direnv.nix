{
  config,
  lib,
  ...
}: let
  inherit (lib) optionals;
  inherit (config.system) impermanence;
in {
  programs.direnv = {
    enable = true;
    silent = true;
    nix-direnv.enable = true;
    direnvrcExtra = ''
      warn_timeout=0
      hide_env_diff=true
    '';
  };

  # WIP: for each user logic
  environment.persistence."/persist".users.michael.directories = optionals impermanence.enable [
    ".local/share/direnv"
  ];
}
