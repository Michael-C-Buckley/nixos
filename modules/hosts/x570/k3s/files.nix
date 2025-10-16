# For linking the files here into the system
{
  flake.modules.nixos.x570 = {
    environment.etc = {
      "rancher/k3s/helm/open-wbui/values.yml".source = ./open-webui/values.yml;
    };
  };
}
