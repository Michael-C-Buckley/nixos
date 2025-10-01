{
  # Persistent mount handled via filesystems
  services = {
    ollama = {
      enable = true;
      # Skip for now
      acceleration = false;
      #rocmOverrideGfx = "9.0.0";
    };
    # Add a local UI for convenience
    nextjs-ollama-llm-ui.enable = true;
  };
}
