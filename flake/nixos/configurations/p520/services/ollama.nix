{config, ...}: {
  environment.persistence."/cache".directories = [
    config.services.ollama.home
  ];
  services.ollama = {
    enable = true;
    acceleration = "rocm";
    openFirewall = true;
  };
}
