{
  imports = [
    ./ipex-llm.nix
    ./open-webui.nix
  ];

  environment.persistence."/cache".directories = [
    "/var/lib/ipex"
    "/var/lib/open-webui"
    "/var/tmp"
  ];

  virtualisation.podman = {
    enable = true;
  };
}
