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

  networking.firewall.allowedTCPPorts = mkIf hydra.enable [3000];

  services.hydra = {
    hydraURL = mkDefault "http://localhost:3000";
    notificationSender = mkDefault "hydra@localhost";
    buildMachinesFiles = mkDefault [];
    useSubstitutes = mkDefault true;
  };
}
