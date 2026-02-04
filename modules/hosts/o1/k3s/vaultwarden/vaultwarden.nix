{
  flake.modules.nixos.o1 = {
    config,
    flakeLib,
    ...
  }: let
    inherit (flakeLib.functions-yaml) checkYAML;
  in {
    sops = {
      secrets = {
        "vaultwarden/postgres_password" = {};
      };
      templates = {
        vaultwarden-secrets.content =
          # yaml
          ''
            apiVersion: v1
            kind: Secret
            metadata:
              name: vaultwarden-secrets
              namespace: vaultwarden
            stringData:
              postgres_password: ${config.sops.placeholder."vaultwarden/postgres_password"}
              database_url: postgresql://vaultwarden:${config.sops.placeholder."vaultwarden/postgres_password"}@10.42.0.1:5432/vaultwarden
          '';
      };
    };
    services = {
      postgresql = {
        ensureDatabases = ["vaultwarden"];
        ensureUsers = [
          {
            name = "vaultwarden";
            ensureDBOwnership = true;
            ensureClauses = {createdb = true;};
          }
        ];
      };
      k3s.manifests = {
        vaultwarden-secrets.source = checkYAML {
          yaml = config.sops.templates.vaultwarden-secrets.path;
          name = "vaultwarden-secrets";
        };
        vaultwarden-manifest.source = checkYAML {
          yaml = ./vaultwarden.yaml;
          name = "vaultwarden-manifest";
        };
      };
    };
  };
}
