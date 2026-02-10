{
  flake.modules.nixos.o1 = {pkgs, ...}: {
    services = {
      postgresql = {
        ensureDatabases = [
          "headscale"
        ];
        ensureUsers = [
          {
            name = "headscale";
            ensureDBOwnership = true;
          }
        ];
      };

      k3s.manifests.headscale-config.source = pkgs.writers.writeYAML "headscale-config.yaml" {
        apiVersion = "v1";
        kind = "ConfigMap";
        metadata = {
          name = "headscale-config";
          namespace = "headscale";
        };
        data = {
          "config.yaml" = builtins.toJSON {
            server_url = "https://headscale.o1.groovyreserve.com";

            listen_addr = "0.0.0.0:80";
            metrics_listen_addr = "0.0.0.0:9090";
            grpc_listen_addr = "0.0.0.0:50443";
            grpc_allow_insecure = false;

            noise.private_key_path = "/var/lib/headscale/noise_private.key";

            prefixes = {
              v4 = "100.127.255.0/24";
              v6 = "fd7a:115c:a1e0::/48";
              allocation = "sequential";
            };

            derp = {
              server = {
                enabled = true;
                region_id = 999;
                region_code = "headscale";
                region_name = "Headscale Embedded DERP";
                verify_clients = true;
                stun_listen_addr = "0.0.0.0:3478";
                private_key_path = "/var/lib/headscale/derp_server_private.key";
                automatically_add_embedded_derp_region = true;
              };

              urls = [
                "https://controlplane.tailscale.com/derpmap/default"
              ];

              paths = [];

              auto_update_enabled = true;
              update_frequency = "3h";
            };

            disable_check_updates = true;

            ephemeral_node_inactivity_timeout = "30m";

            database = {
              type = "postgres";
              debug = false;

              postgres = {
                host = "/var/lib/postgresql";
                name = "headscale";
                user = "headscale";
                max_open_conns = 10;
                max_idle_conns = 10;
                conn_max_idle_time_secs = 3600;
              };

              gorm = {
                prepare_stmt = true;
                parameterized_queries = true;
                skip_err_record_not_found = true;
                slow_threshold = 1000;
              };
            };

            log = {
              level = "info";
              format = "text";
            };

            dns = {
              magic_dns = true;
              base_domain = "example.com";
              override_local_dns = false;

              nameservers = {
                global = [
                  "1.1.1.1"
                  "1.0.0.1"
                  "2606:4700:4700::1111"
                  "2606:4700:4700::1001"
                ];
                split = {};
              };
              search_domains = [];
              extra_records = [];
            };

            unix_socket = "/var/run/headscale/headscale.sock";
            unix_socket_permission = "0770";

            # https://tailscale.com/kb/1011/log-mesh-traffic#opting-out-of-client-logging
            logtail.enabled = false;

            randomize_client_port = false;
          };
        };
      };
    };
  };
}
