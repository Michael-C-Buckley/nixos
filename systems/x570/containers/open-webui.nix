{
  flake.nixosConfigurations.x570.open-webui = {
    virtualisation.quadlet = {
      pods.all = {};
      builds.open-webui.buildConfig.networks = ["host"];
      containers.open-webui.containerConfig = {
        image = "ghcr.io/open-webui/open-webui:main";
        publishPorts = ["4400:8080"];
        addHosts = ["host.containers.internal:host-gateway"];
        volumes = ["/var/lib/open-webui:/app/backend/data"];
        environments = {
          OLLAMA_BASE_URL = "http://host.containers.internal:11434";
        };
      };
    };

    networking.firewall.allowedTCPPorts = [4400];
  };
}
