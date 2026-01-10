{lib, ...}: {
  flake.modules.nixos.kube-traefik = {
    config,
    pkgs,
    ...
  }: let
    inherit (config.services.k3s.custom) traefik;
  in {
    options.services.k3s.custom.traefik = {
      defaultCert = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "The default tlsStore certificate to use.";
      };
      ssh = {
        # TODO: add error for invalid
        enable = lib.mkEnableOption "Add SSH to ports.";
        port = lib.mkOption {
          type = lib.types.int;
          default = 22;
        };
      };
    };

    config = {
      warnings = lib.mkIf (traefik.defaultCert == {}) [
        "services.k3s.custom.traefik.defaultCert is not defined. The traefik manifest may be incomplete."
      ];

      services.k3s.manifests = {
        # Use a name other than traefik, as that default name is used by the system
        traefik-base.content = let
          yamlFormat = pkgs.formats.yaml {};
          valuesConfig = {
            # Set a default TLS certificate for Traefik to use
            tlsStore.default.defaultCertificate.secretName = traefik.defaultCert;

            # Use host network mode to bind directly to host ports 80/443 on all interfaces
            # This bypasses klipper-lb and allows binding to all interfaces including Netbird
            hostNetwork = true;
            updateStrategy.type = "Recreate";
            podSecurityContext = {
              runAsUser = 0;
              runAsGroup = 0;
              runAsNonRoot = false;
            };
            securityContext.capabilities = {
              add = ["NET_BIND_SERVICE"];
              drop = ["ALL"];
            };
            service.type = "ClusterIP";
            ports =
              {
                web.port = 80;
                websecure.port = 443;
              }
              // lib.optionalAttrs traefik.ssh.enable {
                ssh.port = traefik.ssh.port;
              };
          };
        in {
          apiVersion = "helm.cattle.io/v1";
          kind = "HelmChartConfig";
          metadata = {
            name = "traefik";
            namespace = "kube-system";
          };
          spec.valuesContent = builtins.readFile (yamlFormat.generate "traefik-values.yaml" valuesConfig);
        };
      };
    };
  };
}
