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

  nix.settings.trusted-users = mkIf hydra.enable ["hydra" "hydra-queue-runner" "hydra-www"];

  services.hydra = {
    hydraURL = mkDefault "http://localhost:3000";
    notificationSender = mkDefault "hydra@localhost";
    buildMachinesFiles = mkDefault [];
    useSubstitutes = mkDefault true;
    extraConfig = ''
      allow-import-from-derivation = true

      # Use substituters for build dependencies
      use-substitutes = 1

      # Timeout settings for substituters
      connect-timeout = 60
      stalled-download-timeout = 300

      # Allow fetching from binary caches during builds
      builders-use-substitutes = true
    '';
  };
}
