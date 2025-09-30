{config, ...}: {
  environment.persistence."/cache".directories = [
    config.services.ollama.home
    {
      directory = "/var/lib/private/ollama";
      user = "ollama";
      group = "ollama";
    }
  ];
  services.ollama = {
    enable = true;
    acceleration = "rocm";
    openFirewall = true;
  };
}
