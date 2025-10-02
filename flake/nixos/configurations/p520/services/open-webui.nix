{
  environment.persistence."/persist".directories = [
    "/var/lib/open-webui"
  ];

  services.open-webui = {
    enable = false;
    host = "0.0.0.0";
    port = "8088";
    openFirewall = true;
    environment = {
      OLLAMA_API_BASE_URL = "http://127.0.0.1:11434";
    };
  };
}
