{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config.system) impermanence;
in
  mkIf impermanence.enable {
    environment.persistence = {
      "/persist".users.shawn = {
        # Persist everything for now
        directories = [""];
      };
    };
  }
