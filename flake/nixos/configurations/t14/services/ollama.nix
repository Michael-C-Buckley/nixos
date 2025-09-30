{
  # Persistent mount handled via filesystems
  services.ollama = {
    enable = true;
    acceleration = "rocm";
    #rocmOverrideGfx = "9.0.0";
  };
}
