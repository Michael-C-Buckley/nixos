{
  flake.modules.nixos.x570 = {
    virtualisation.quadlet = {
      pods.all = {};
      builds.ipex-llm = {
        autoStart = true;
        buildConfig.networks = ["host"];
      };
      containers.ipex-llm.containerConfig = {
        image = "intelanalytics/ipex-llm-inference-cpp-xpu:latest";
        exec = "ollama/ollama serve";
        publishPorts = ["11434:11434"];
        addHosts = ["host.containers.internal:host-gateway"];
        volumes = [
          "/var/lib/ipex/models:/root/.ollama/models"
          "/var/lib/ipex/ollama:/llm/ollama"
        ];
        shmSize = "16G";
        memory = "40G";
        devices = ["/dev/dri"];
        environments = {
          DEVICE = "Arc";
          no_proxy = "localhost,127.0.0.1";
          OLLAMA_NUM_GPU = "999";
          ZES_ENABLE_SYSMAN = "1";
          OLLAMA_HOST = "0.0.0.0:11434";
        };
      };
    };

    networking.firewall.allowedTCPPorts = [11434];
  };
}
