{
  flake.modules.nixos.o1 = {config, ...}: let
    inherit (config.sops) placeholder;
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
              postgres_password: ${placeholder."vaultwarden/postgres_password"}
              database_url: postgresql://vaultwarden:${placeholder."vaultwarden/postgres_password"}@10.42.0.1:5432/vaultwarden
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
        vaultwarden-secrets.source = config.sops.templates.vaultwarden-secrets.path;
        vaultwarden-manifest.source = ./vaultwarden.yaml;
      };
    };
  };
}
