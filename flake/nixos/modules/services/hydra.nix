{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkDefault mkIf;
  inherit (config.services) hydra;
in {
  environment = mkIf hydra.enable {
    systemPackages = [pkgs.hydra-cli];
    persistence."/persist".directories = [
      "/var/lib/hydra"
    ];
  };

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

  # This instance is configured with remote builders
  #  so far I am only using this on P520, see that host for
  #  addition config like remote builders
  services.hydra = {
    hydraURL = mkDefault "http://localhost:3000";
    notificationSender = mkDefault "hydra@localhost";
    useSubstitutes = mkDefault true;
    extraConfig = ''
      store_uri = file:///nix/store?compression=zstd&parallel-compression=true&write-nar-listing=1&ls-compression=br&log-compression=br&secret-key=/run/secrets/cachePrivateKey

      # Substitution
      use-substitutes = 1
      connect-timeout = 60
      stalled-download-timeout = 1000
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
