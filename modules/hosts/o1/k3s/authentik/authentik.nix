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
        "authentik/postgres_password" = {};
        "authentik/secret_key" = {};
      };
      templates = {
        authentik-ingress.content =
          # yaml
          ''
            apiVersion: networking.k8s.io/v1
            kind: Ingress
            metadata:
              name: authentik
              namespace: authentik
              annotations:
                traefik.ingress.kubernetes.io/whitelist-source-range: "${config.sops.placeholder."k3s/whitelist"}"
            spec:
              ingressClassName: traefik
              tls:
                - hosts:
                    - authentik.o1.groovyreserve.com
              rules:
                - host: authentik.o1.groovyreserve.com
                  http:
                    paths:
                      - pathType: Prefix
                        path: /
                        backend:
                          service:
                            name: authentik-server
                            port:
                              number: 80
          '';
        authentik-secrets.content =
          # yaml
          ''
            apiVersion: v1
            kind: Secret
            metadata:
              name: authentik-secrets
              namespace: authentik
            stringData:
              postgres_password: ${config.sops.placeholder."authentik/postgres_password"}
              secret_key: ${config.sops.placeholder."authentik/secret_key"}
              whitelist: ${config.sops.placeholder."k3s/whitelist"}
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
        authentik-ingress.source = config.sops.templates.authentik-ingress.path;
        authentik-chart.source = checkYAML {
          yaml = ./authentik.yaml;
          name = "authentik-manifest";
        };
      };
    };
  };
}
