{
  virtualisation.quadlet.containers.ipex-llm.containerConfig = {
    image = "intelanalytics/ipex-llm-inference-cpp-xpu:latest";
    publishPorts = ["11434:11434"];
    volumes = ["/var/lib/ipex/:/models"];
    shmSize = "16G";
    memory = "40G";
    devices = ["/dev/dri"];
    environments = {
      DEVICE = "Arc";
      no_proxy = "localhost,127.0.0.1";
    };
  };

  networking.firewall.allowedTCPPorts = [11434];
}
