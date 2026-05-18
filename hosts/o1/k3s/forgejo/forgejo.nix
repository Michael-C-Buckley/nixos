{
  flake.modules.nixos.o1 = {
    config,
    functions,
    ...
  }: let
    inherit (functions.yaml) checkYAML;
  in {
    sops = {
      secrets."forgejo/postgres_password" = {};
      templates.forgejo-secrets.content =
        # yaml
        ''
          ---
           apiVersion: v1
           kind: Secret
           metadata:
             name: postgres-secret
             namespace: forgejo
           type: Opaque
           stringData:
             POSTGRES_PASSWORD: "${config.sops.placeholder."forgejo/postgres_password"}"
        '';
    };
    services = {
      postgresql = {
        ensureDatabases = ["forgejo"];
        ensureUsers = [
          {
            name = "forgejo";
            ensureDBOwnership = true;
            ensureClauses = {createdb = true;};
          }
        ];
      };
      k3s.manifests = {
        forgejo-deployment.source = checkYAML {
          yaml = ./forgejo.yaml;
          name = "forgejo-deployment";
        };
        forgejo-secrets.source = config.sops.templates.forgejo-secrets.path;
      };
    };
  };
}
