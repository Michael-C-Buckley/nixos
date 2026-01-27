{
  flake.modules.nixos.o1 = {
    services.atticd.settings.database = {
      url = "postgresql://atticd@%2Frun%2Fpostgresql/atticd";
      heartbeat = true;
    };

    systemd.services.atticd = {
      after = ["postgresql.service"];
      requires = ["postgresql.service"];
    };

    services.postgresql = {
      ensureDatabases = [
        "atticd"
      ];
      ensureUsers = [
        {
          name = "atticd";
          ensureDBOwnership = true;
        }
      ];
    };
  };
}
