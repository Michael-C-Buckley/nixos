{
  flake.modules.nixos.o1 = {
    config,
    flakeLib,
    ...
  }: let
    inherit (config.sops) placeholder templates;
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
                traefik.ingress.kubernetes.io/whitelist-source-range: "${placeholder."k3s/whitelist"}"
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
              postgres_password: ${placeholder."authentik/postgres_password"}
              secret_key: ${placeholder."authentik/secret_key"}
              whitelist: ${placeholder."k3s/whitelist"}
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
        authentik-secrets.source = checkYAML {
          yaml = templates.authentik-secrets.path;
          name = "authentik-secrets";
        };
        authentik-ingress.source = checkYAML {
          yaml = templates.authentik-ingress.path;
          name = "authentik-ingress";
        };
        authentik-chart.source = checkYAML {
          yaml = ./authentik.yaml;
          name = "authentik-manifest";
        };
      };
    };
  };
}
