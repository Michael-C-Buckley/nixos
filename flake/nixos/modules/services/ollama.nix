{
  config,
  lib,
  ...
}: let
  inherit (config.services) ollama;
in {
  config = lib.mkIf ollama.enable {
    # Ollama uses links between various locations
    # These options make it work with split FS devices
    systemd.services.ollama.serviceConfig = lib.mkDefault {
      DynamicUser = lib.mkForce "false";
      StateDirectory = lib.mkForce config.services.ollama.home;
    };

    # Most other settings are per-host basis
    services.ollama.user = "ollama";
  };
}
