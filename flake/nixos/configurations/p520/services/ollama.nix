{
  services.ollama = {
    enable = true;
    acceleration = "rocm";
    openFirewall = true;
    host = "[::]";
  };
}
