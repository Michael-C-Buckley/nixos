{
  imports = [
    ./ipex-llm.nix
    ./open-webui.nix
  ];

  environment.persistence."/cache".directories = [
    "/var/lib/containers"
    "/var/lib/open-webui"
    "/var/tmp"
  ];

  virtualisation.podman = {
    enable = true;
  };
}
