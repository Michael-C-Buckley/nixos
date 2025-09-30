{
  virtualisation.quadlet.containers.open-webui.containerConfig = {
    image = "ghcr.io/open-webui/open-webui:main";
    publishPorts = ["4400:8080"];
    volumes = ["/var/lib/open-webui:/open-webui"];
    environments = {
      OLLAMA_BASE_URL = "https://127.0.0.1:11434";
    };
  };

  networking.firewall.allowedTCPPorts = [4400];
}
