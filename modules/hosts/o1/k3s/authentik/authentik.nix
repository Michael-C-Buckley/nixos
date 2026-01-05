{
  flake.modules.nixos.o1 = {config, ...}: let
    inherit (config.sops) placeholder;
  in {
    sops = {
      secrets = {
        "authentik/postgres_username" = {};
        "authentik/postgres_password" = {};
        "authentik/secret_key" = {};
      };
      templates = {
        authentik-secrets.content =
          # yaml
          ''
            apiVersion: v1
            kind: Secret
            metadata:
              name: authentik-secrets
              namespace: authentik
            stringData:
              postgres_username: ${placeholder."authentik/postgres_username"}
              postgres_password: ${placeholder."authentik/postgres_password"}
              secret_key: ${placeholder."authentik/secret_key"}
          '';
      };
    };
    services = {
      postgresql = {
        ensureDatabases = ["authentik"];
        ensureUsers = [
          {
            name = "authentik";
            ensureDBOwnership = true;
            ensureClauses = {createdb = true;};
          }
        ];
      };
      k3s.manifests = {
        authentik-secrets.source = config.sops.templates.authentik-secrets.path;
        authentik-chart.source = ./authentik.yaml;
      };
    };
  };
}
