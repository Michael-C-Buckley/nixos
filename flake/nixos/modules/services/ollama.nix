{lib, ...}: {
  # Ollama uses links between various locations
  # These options make it work with split FS devices
  systemd.services.ollama.serviceConfig = {
    DynamicUser = lib.mkForce "false";
    StateDirectory = lib.mkForce "/var/lib/ollama";
  };

  # Most other settings are per-host basis
  services.ollama.user = "ollama";
}
