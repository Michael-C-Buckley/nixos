{lib, ...}: {
  systemd.services.ollama.serviceConfig = {
    DynamicUser = lib.mkForce "false";
    StateDirectory = lib.mkForce "/var/lib/ollama";
  };

  services.ollama = {
    enable = true;
    acceleration = "rocm";
    openFirewall = true;
    host = "[::]";
    user = "ollama";
  };
}
