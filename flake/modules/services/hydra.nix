{
  config,
  lib,
  ...
}: let
  inherit (lib) mkDefault mkIf;
  inherit (config.services) hydra;
in {
  environment.persistence."/persist".directories = mkIf hydra.enable [
    "/var/lib/hydra"
  ];

  services.hydra = {
    hydraurl = mkDefault "http://localhost:3000";
    notificationsender = mkDefault "hydra@localhost";
    buildmachinesfiles = mkDefault [];
    usesubstitutes = mkDefault true;
  };
}
