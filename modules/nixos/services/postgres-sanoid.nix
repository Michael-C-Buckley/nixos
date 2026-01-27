{
  flake.modules.nixos.postgres-sanoid = {config, ...}: let
    inherit (config.services.postgresql) package;
  in {
    # This ensures the database is in a correct state to be successfully captured
    # from a snapshot
    systemd.services = {
      postgres-checkpoint = {
        wants = ["postgresql.service"];
        after = ["postgresql.service"];
        serviceConfig = {
          Type = "oneshot";
          User = "postgres";
          ExecStart = ''
            ${package}/bin/psql
            -h /run/postgresl \
            -d postgres \
            -c "CHECKPOINT;"
          '';
          StandardOutput = "journal";
          StandardError = "journal";
        };
      };
      # This makes sanoid absolutely depend on the completion of the checkpoint
      # Failure of the checkpoint *will stop* all snapshots, even of non-postgres
      # All snapshots of postgres will be safe due to this requirement
      sanoid = {
        after = ["postgres-checkpoint.service"];
        requires = ["postgres-checkpoint.service"];
      };
    };
  };
}
