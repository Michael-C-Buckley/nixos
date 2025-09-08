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

  # Increase systemd limits for Hydra services
  systemd.services = mkIf hydra.enable {
    hydra-evaluator.serviceConfig = {
      MemoryMax = "32G";
      TasksMax = "8192";
      LimitNOFILE = "1048576";
    };

    hydra-queue-runner.serviceConfig = {
      MemoryMax = "16G";
      TasksMax = "8192";
      LimitNOFILE = "1048576";
    };
  };

  services.hydra = {
    hydraURL = mkDefault "http://localhost:3000";
    notificationSender = mkDefault "hydra@localhost";
    buildMachinesFiles = mkDefault [];
    useSubstitutes = mkDefault true;
    extraConfig = ''
      # This slows down evaluation but I use IFD within my configs so I'm allowing it
      allow-import-from-derivation = true

      # Substitution
      use-substitutes = 1
      connect-timeout = 60
      stalled-download-timeout = 300
      builders-use-substitutes = true

      # Evaluation
      evaluator_workers = 4
      evaluator_max_memory_size = 32768
      max_concurrent_evals = 8

      # Runner/DB/Timeout
      queue_runner_metrics_address = 127.0.0.1:9199
      max_db_connections = 50
      build_timeout = 7200          # 2 hours max per build
      evaluation_timeout = 3600     # 1 hour max per eval
    '';
  };
}
